import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:edwardb/config/routes/routes_names.dart';
import 'package:edwardb/config/utils/utils.dart';
import 'package:edwardb/screens/view/vehicle_inspection_screens/vehicle_inspection_confirm_screen.dart';
import 'package:edwardb/screens/view/vehicle_inspection_screens/vehicle_inspection_selected_screen.dart';
import 'package:edwardb/services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

import '../../screens/view/vehicle_inspection_screens/done_screen.dart';

class InspectionController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  String contractId = '';
  late SignatureController signatureController;
  Uint8List? signatureBytes;

  // Observable variables
  var isRecording = false.obs;
  var isInitialized = false.obs;
  var recordingTime = 0.obs;
  var videoPath = ''.obs;
  var showPreview = false.obs;

  // Timer for recording duration
  Timer? recordingTimer;
  static const int maxRecordingTime = 60; // 60 seconds

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
    signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void onClose() {
    disposeCamera();
    super.onClose();
  }

  Future<void> initializeCamera() async {
    try {
      // Request camera permission
      var status = await Permission.camera.request();
      if (!status.isGranted) {
        Utils.showErrorSnackbar('Error', 'Camera permission denied');
        return;
      }

      // Get available cameras
      cameras = await availableCameras();
      if (cameras!.isEmpty) {
        Utils.showErrorSnackbar('Error', 'No cameras available');
        return;
      }

      // Initialize camera controller
      cameraController = CameraController(
        cameras![0], // Use first camera (usually back camera)
        ResolutionPreset.high,
        enableAudio: true,
      );

      await cameraController!.initialize();
      isInitialized.value = true;
    } catch (e) {
      Utils.showErrorSnackbar(
        'Error',
        'Failed to initialize camera: ${e.toString()}',
      );
    }
  }

  Future<void> startVideoRecording() async {
    if (!isInitialized.value || cameraController == null) {
      Utils.showErrorSnackbar('Error', 'Camera not initialized');
      return;
    }

    try {
      if (isRecording.value) {
        await stopVideoRecording();
        return;
      }

      // Start recording
      await cameraController!.startVideoRecording();
      isRecording.value = true;
      recordingTime.value = 0;

      // Start timer for recording duration
      recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
        recordingTime.value++;

        // Auto stop at 60 seconds
        if (recordingTime.value >= maxRecordingTime) {
          await stopVideoRecording();
          Get.off(() => VideoPreviewScreen());
        }
      });

      Utils.showErrorSnackbar('Success', 'Recording started');
    } catch (e) {
      Utils.showErrorSnackbar(
        'Error',
        'Failed to start recording: ${e.toString()}',
      );
    }
  }

  Future<void> stopVideoRecording() async {
    if (!isRecording.value || cameraController == null) return;

    try {
      recordingTimer?.cancel();

      final XFile videoFile = await cameraController!.stopVideoRecording();
      isRecording.value = false;
      videoPath.value = videoFile.path;
      showPreview.value = true;

      Utils.showErrorSnackbar('Success', 'Recording stopped');
    } catch (e) {
      Utils.showErrorSnackbar(
        'Error',
        'Failed to stop recording: ${e.toString()}',
      );
    }
  }

  void deleteVideo() {
    try {
      if (videoPath.value.isNotEmpty) {
        File(videoPath.value).deleteSync();
        videoPath.value = '';
        showPreview.value = false;
        recordingTime.value = 0;
        Utils.showErrorSnackbar('Success', 'Video deleted');
      }
    } catch (e) {
      Utils.showErrorSnackbar(
        'Error',
        'Failed to delete video: ${e.toString()}',
      );
    }
  }

  void proceedToNextScreen() {
    if (videoPath.value.isNotEmpty) {
      Get.to(() => VehicleInspectionConfirmScreen());
    }
  }

  void retakeVideo() {
    deleteVideo();
    // Reset to recording state
    showPreview.value = false;
  }

  String get formattedTime {
    int minutes = recordingTime.value ~/ 60;
    int seconds = recordingTime.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get recordingProgress {
    return recordingTime.value / maxRecordingTime;
  }

  void disposeCamera() {
    recordingTimer?.cancel();
    cameraController?.dispose();
    cameraController = null;
  }

  RxBool isLoading = false.obs;
  Future<void> submitInspection() async {
    if (signatureController.isEmpty) {
      Utils.showErrorSnackbar('Error', 'Please provide your signature.');
      return;
    }

    if (videoPath.value.isEmpty) {
      Utils.showErrorSnackbar('Error', 'Please record a video.');
      return;
    }

    // Set loading to true
    isLoading.value = true;

    try {
      // Convert signature to bytes
      signatureBytes = await signatureController.toPngBytes();

      // Submit inspection
      final success = await FirebaseService.instance.submitInspection(
        contractId: contractId,
        videoFilePath: videoPath.value,
        signatureBytes: signatureBytes!,
      );

      if (success) {
        Utils.showErrorSnackbar(
          'Success',
          'Inspection submitted successfully!',
        );
        // Clear data
        deleteVideo();
        signatureController.clear();
        signatureBytes = null;
        // Navigate back or to another screen
        Get.offAll(
          () =>
              DoneScreen(contractId: contract, name: username, imageUrl: image),
        );
      } else {
        Utils.showErrorSnackbar(
          'Error',
          'Failed to submit inspection. Please try again.',
        );
      }
    } catch (e) {
      Utils.showErrorSnackbar('Error', 'An error occurred: ${e.toString()}');
    } finally {
      // Set loading to false
      isLoading.value = false;
    }
  }

  // Done Screen Data
  String image = '';
  String username = '';
  String contract = '';

  void setDoneScreenData(imageURL, contractId, name) {
    contract = contractId;
    username = name;
    image = imageURL;
  }
}
