// functions/index.js
const functions = require("firebase-functions/v1");
const { google } = require("googleapis");
const axios = require("axios");
const stream = require("stream");

// Google Drive setup
const drive = google.drive("v3");
const auth = new google.auth.GoogleAuth({
  credentials: {},
  scopes: ["https://www.googleapis.com/auth/drive"],
});

// Helper: find or create a folder under parentId (or root)
async function getOrCreateFolder(name, parentId) {
  const q = `'${parentId || "root"}' in parents and name='${name}' and mimeType='application/vnd.google-apps.folder' and trashed=false`;
  const res = await drive.files.list({ q, fields: "files(id, name)" });
  if (res.data.files && res.data.files.length > 0) return res.data.files[0].id;

  const metadata = { name, mimeType: "application/vnd.google-apps.folder" };
  if (parentId) metadata.parents = [parentId];
                                                                                                                          
  const folder = await drive.files.create({ resource: metadata, fields: "id" });
  return folder.data.id;
}

// Helper: upload file from URL to Drive
async function uploadFileByStream(url, mimeType, fileName, parentId) {
  const response = await axios({ url, method: "GET", responseType: "stream" });
  const resource = { name: fileName, parents: parentId ? [parentId] : undefined };
  const media = { mimeType, body: response.data };

  const res = await drive.files.create({
    resource,
    media,
    fields: "id, webViewLink",
  });
                 
  return res.data;
}

// ---------------------
// FUNCTION 1: uploadInspectionToDrive
// ---------------------
exports.uploadInspectionToDrive = functions
  .runWith({ memory: "1GB", timeoutSeconds: 540 })
  .https.onCall({ allowUnauthenticated: true }, async (data, context) => {
    const { username, videoUrl, signatureUrl } = data || {};
    if (!username || !videoUrl || !signatureUrl) {
      throw new functions.https.HttpsError("invalid-argument", "Missing parameters");
    }

    try {
      const authClient = await auth.getClient();
      google.options({ auth: authClient });

      const cfg = functions.config() || {};
      const inspectionsParent = cfg.drive && cfg.drive.inspections_parent ? cfg.drive.inspections_parent : null;

      const inspectionsFolderId = await getOrCreateFolder("inspections", inspectionsParent);
      const userFolderId = await getOrCreateFolder(username, inspectionsFolderId);
      const videosFolderId = await getOrCreateFolder("videos", userFolderId);

      const videoFile = await uploadFileByStream(videoUrl, "video/mp4", `video-${Date.now()}.mp4`, videosFolderId);
      const signatureFile = await uploadFileByStream(signatureUrl, "image/png", `signature-${Date.now()}.png`, videosFolderId);

      return { success: true, driveLinks: { video: videoFile.webViewLink, signature: signatureFile.webViewLink } };
    } catch (err) {
      console.error("uploadInspectionToDrive error:", err);
      throw new functions.https.HttpsError("internal", err.message || "Upload failed");
    }
  });

// ---------------------
// FUNCTION 2: uploadContractToDrive
// ---------------------
exports.uploadContractToDrive = functions.https.onCall({ allowUnauthenticated: true }, async (data, context) => {
  const { username, contractData, driverPhotoUrl, licensePhotoUrl, signatureUrl } = data || {};
  if (!username || !contractData) {
    throw new functions.https.HttpsError("invalid-argument", "Missing required fields");
  }

  try {
    const authClient = await auth.getClient();
    google.options({ auth: authClient });

    const cfg = functions.config() || {};
    const contractsParent = cfg.drive && cfg.drive.contracts_parent ? cfg.drive.contracts_parent : null;

    const contractsFolderId = await getOrCreateFolder("contracts", contractsParent);
    const userFolderId = await getOrCreateFolder(username, contractsFolderId);

    // Upload contract text as .txt
    const textContent = Object.entries(contractData)
      .map(([k, v]) => `${k}: ${v}`)
      .join("\n");

    const bufferStream = new stream.PassThrough();
    bufferStream.end(Buffer.from(textContent, "utf8"));

    await drive.files.create({
      resource: { name: "contract-details.txt", parents: [userFolderId] },
      media: { mimeType: "text/plain", body: bufferStream },
      fields: "id, webViewLink",
    });

    // Upload images
    if (driverPhotoUrl) await uploadFileByStream(driverPhotoUrl, "image/jpeg", `driver-${Date.now()}.jpg`, userFolderId);
    if (licensePhotoUrl) await uploadFileByStream(licensePhotoUrl, "image/jpeg", `license-${Date.now()}.jpg`, userFolderId);
    if (signatureUrl) await uploadFileByStream(signatureUrl, "image/png", `signature-${Date.now()}.png`, userFolderId);

    return { success: true };
  } catch (err) {
    console.error("uploadContractToDrive error:", err);
    throw new functions.https.HttpsError("internal", err.message || "Upload failed");
  }
});
