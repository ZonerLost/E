/* eslint-disable no-console */
const { onCall } = require("firebase-functions/v2/https");
const { google } = require("googleapis");
const axios = require("axios");
const stream = require("stream");

// ---- Google Drive API client (Shared Drive–safe) ----
const drive = google.drive("v3");
const adcAuth = new google.auth.GoogleAuth({
  scopes: ["https://www.googleapis.com/auth/drive.file"],
});

async function ensureAuth() {
  const authClient = await adcAuth.getClient();
  google.options({ auth: authClient });
}

// Parent IDs (Shared Drive ID or folder IDs)
function getCfg() {
  let v1 = {};
  try {
    v1 = require("firebase-functions/v1").config();
  } catch {
    /* ignore */
  }
  return {
    inspectionsParent:
      v1.drive?.inspections_parent || process.env.DRIVE_INSPECTIONS_PARENT || null,
    contractsParent:
      v1.drive?.contracts_parent || process.env.DRIVE_CONTRACTS_PARENT || null,
  };
}

function callerEmail(req) {
  return req?.auth?.token?.email || null;
}

function resolveUsername(req, fallbackEmail) {
  const fromClient = (req.data?.username || "").toString().trim();
  return fromClient || fallbackEmail || "unknown";
}

/** Find or create folder "name" under parentId (My Drive or Shared Drive). */
async function getOrCreateFolder(name, parentId) {
  const q = `'${parentId || "root"}' in parents and name='${name}' and mimeType='application/vnd.google-apps.folder' and trashed=false`;

  const res = await drive.files.list({
    q,
    fields: "files(id,name,parents,driveId)",
    corpora: "allDrives",
    includeItemsFromAllDrives: true,
    supportsAllDrives: true,
  });

  if (res.data.files?.length) return res.data.files[0].id;

  const resource = {
    name,
    mimeType: "application/vnd.google-apps.folder",
    ...(parentId ? { parents: [parentId] } : {}),
  };

  const created = await drive.files.create({
    resource,
    fields: "id",
    supportsAllDrives: true,
  });

  return created.data.id;
}

/** Download a URL and upload to Drive under parentId. */
async function uploadFileByStream(url, mimeType, fileName, parentId) {
  const response = await axios({
    url,
    method: "GET",
    responseType: "stream",
    timeout: 120000,
  });

  const resource = { name: fileName, parents: parentId ? [parentId] : undefined };
  const media = { mimeType, body: response.data };

  const file = await drive.files.create({
    resource,
    media,
    fields: "id, webViewLink",
    supportsAllDrives: true,
  });

  return file.data; // { id, webViewLink }
}

/** Grant the caller read access to a file (so links work for them). */
async function shareFileWithUser(fileId, email) {
  if (!email) return;
  try {
    await drive.permissions.create({
      fileId,
      supportsAllDrives: true,
      sendNotificationEmail: false,
      requestBody: { type: "user", role: "reader", emailAddress: email },
    });
  } catch (e) {
    const msg = e?.message || e?.response?.data?.error?.message || "";
    if (/already.*(has|owner|permission)/i.test(msg)) return;
    console.warn("shareFileWithUser:", msg);
  }
}

/* ----------------------------------------------------------
   Debug function
   ---------------------------------------------------------- */
exports.whoAmI = onCall({ region: "us-central1", invoker: "public" }, (req) => {
  return {
    uid: req.auth?.uid || null,
    email: req.auth?.token?.email || null,
    hasAppCheck: !!req.appCheckToken,
  };
});

/* ----------------------------------------------------------
   uploadInspectionToDrive
   ---------------------------------------------------------- */
exports.uploadInspectionToDrive = onCall(
  { region: "us-central1", invoker: "public", timeoutSeconds: 540, memory: "1GiB" },
  async (req) => {
    const { videoUrl, signatureUrl } = req.data || {};
    if (!videoUrl || !signatureUrl)
      throw new Error("Missing parameters (videoUrl, signatureUrl)");

    try {
      await ensureAuth();
      const { inspectionsParent } = getCfg();
      if (!inspectionsParent)
        throw new Error(
          "Set drive.inspections_parent (Shared Drive ID or folder ID)"
        );

      const email = callerEmail(req);
      const username = resolveUsername(req, email);
      const inspectionsFolderId = await getOrCreateFolder(
        "inspections",
        inspectionsParent
      );
      const userFolderId = await getOrCreateFolder(username, inspectionsFolderId);
      const videosFolderId = await getOrCreateFolder("videos", userFolderId);

      const videoFile = await uploadFileByStream(
        videoUrl,
        "video/mp4",
        `video-${Date.now()}.mp4`,
        videosFolderId
      );
      const signatureFile = await uploadFileByStream(
        signatureUrl,
        "image/png",
        `signature-${Date.now()}.png`,
        videosFolderId
      );

      await shareFileWithUser(videoFile.id, email);
      await shareFileWithUser(signatureFile.id, email);

      return {
        success: true,
        driveLinks: {
          video: videoFile.webViewLink,
          signature: signatureFile.webViewLink,
        },
      };
    } catch (err) {
      console.error("uploadInspectionToDrive error:", err?.response?.data || err);
      throw new Error(err.message || "Upload failed");
    }
  }
);

/* ----------------------------------------------------------
   uploadContractToDrive
   ---------------------------------------------------------- */
exports.uploadContractToDrive = onCall(
  { region: "us-central1", invoker: "public" },
  async (req) => {
    const { contractData, driverPhotoUrl, licensePhotoUrl, signatureUrl } =
      req.data || {};
    if (!contractData) throw new Error("Missing required field: contractData");

    try {
      await ensureAuth();
      const { contractsParent } = getCfg();
      if (!contractsParent)
        throw new Error(
          "Set drive.contracts_parent (Shared Drive ID or folder ID)"
        );

      const email = callerEmail(req);
      const username = resolveUsername(req, email);
      const contractsFolderId = await getOrCreateFolder(
        "contracts",
        contractsParent
      );
      const userFolderId = await getOrCreateFolder(username, contractsFolderId);

      // 1) Write a text file containing contract fields
      const textContent = Object.entries(contractData)
        .map(([k, v]) => `${k}: ${v}`)
        .join("\n");
      const bufferStream = new stream.PassThrough();
      bufferStream.end(Buffer.from(textContent, "utf8"));

      const textFile = await drive.files.create({
        resource: { name: "contract-details.txt", parents: [userFolderId] },
        media: { mimeType: "text/plain", body: bufferStream },
        fields: "id, webViewLink",
        supportsAllDrives: true,
      });

      const createdIds = [textFile.data.id];

      // 2) Optional images
      if (driverPhotoUrl) {
        const f = await uploadFileByStream(
          driverPhotoUrl,
          "image/jpeg",
          `driver-${Date.now()}.jpg`,
          userFolderId
        );
        createdIds.push(f.id);
      }
      if (licensePhotoUrl) {
        const f = await uploadFileByStream(
          licensePhotoUrl,
          "image/jpeg",
          `license-${Date.now()}.jpg`,
          userFolderId
        );
        createdIds.push(f.id);
      }
      if (signatureUrl) {
        const f = await uploadFileByStream(
          signatureUrl,
          "image/png",
          `signature-${Date.now()}.png`,
          userFolderId
        );
        createdIds.push(f.id);
      }

      // Share all back
      for (const id of createdIds) await shareFileWithUser(id, email);

      return { success: true };
    } catch (err) {
      console.error("uploadContractToDrive error:", err?.response?.data || err);
      throw new Error(err.message || "Upload failed");
    }
  }
);
