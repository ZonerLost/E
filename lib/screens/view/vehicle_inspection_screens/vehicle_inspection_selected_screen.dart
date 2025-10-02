import 'dart:io';
import 'package:camera/camera.dart';
import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/controllers/inspection_controller/inspection_controller.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Original Screen - Remains exactly the same
class VehicleInspectionSelectedScreen extends StatelessWidget {
  final String imageURL;
  final String contractId;
  final String name;
  final String date;

  VehicleInspectionSelectedScreen({
    super.key,
    required this.imageURL,
    required this.contractId,
    required this.name,
    required this.date,
  });

  final inspectionController = Get.find<InspectionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        child: Icon(Icons.arrow_circle_left_outlined, size: 30.sp),
        onTap: () => Get.back(),
      ),
      title: Row(
        children: [
          EdwardbText(
            'Vehicle Inspection',
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ],
      ),
    );
  }

  _body() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _customerSelectedSection(),
            60.verticalSpace,
            _beforeBeginningSection(),
            80.verticalSpace,
            _startRecordingButton(),
          ],
        ),
      ),
    );
  }

  _customerSelectedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person, size: 30.sp, color: kPrimaryColor),
            15.horizontalSpace,
            EdwardbText(
              'Customer Selected',
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ],
        ),
        30.verticalSpace,
        Row(
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundImage: FileImage(File(imageURL)),
              backgroundColor: Colors.grey[300],
            ),
            20.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      EdwardbText(
                        'File Name : ',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      EdwardbText(
                        name,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      EdwardbText(
                        'Ref # ',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      EdwardbText(
                        contractId,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      EdwardbText(
                        'Date : ',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      EdwardbText(
                        date,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _beforeBeginningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: EdwardbText(
                '!',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ),
            15.horizontalSpace,
            EdwardbText(
              'Before Beginning',
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ],
        ),
        40.verticalSpace,
        _instructionItem(
          'Use the tablet camera to record a clear video showing:',
        ),
        20.verticalSpace,
        Padding(
          padding: EdgeInsets.only(left: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bulletPoint('All sides of the exterior'),
              10.verticalSpace,
              _bulletPoint('Interior (seats, dashboard, etc.)'),
              10.verticalSpace,
              _bulletPoint('Any visible damage or issues'),
            ],
          ),
        ),
        30.verticalSpace,
        _instructionItem('Recommended Duration: 30-60 seconds'),
      ],
    );
  }

  _instructionItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Icon(Icons.play_arrow, size: 24.sp, color: Colors.grey[700]),
        ),
        15.horizontalSpace,
        Expanded(
          child: EdwardbText(
            text,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  _bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[600],
            ),
          ),
        ),
        15.horizontalSpace,
        Expanded(
          child: EdwardbText(
            text,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  _startRecordingButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: EdwardbButton(
          label: 'Start Recording',
          onPressed: () {
            inspectionController.contractId = contractId;
            Get.to(() => VideoRecordingScreen());
          },
        ),
      ),
    );
  }
}

// NEW: Video Recording Screen
class VideoRecordingScreen extends StatelessWidget {
  final inspectionController = Get.find<InspectionController>();

  VideoRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(child: _cameraPreview()),
            _bottomControls(),
          ],
        ),
      ),
    );
  }

  _topBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
            ),
          ),
          Spacer(),
          Obx(
            () => inspectionController.isRecording.value
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        8.horizontalSpace,
                        EdwardbText(
                          'REC ${inspectionController.formattedTime}',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  _cameraPreview() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Obx(
          () =>
              inspectionController.isInitialized.value &&
                  inspectionController.cameraController != null
              ? CameraPreview(inspectionController.cameraController!)
              : Container(
                  color: Colors.grey[900],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: kPrimaryColor),
                        20.verticalSpace,
                        EdwardbText(
                          'Initializing Camera...',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  _bottomControls() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
      child: Column(
        children: [
          // Progress Bar
          Obx(
            () => inspectionController.isRecording.value
                ? Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 6.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.r),
                          color: Colors.white24,
                        ),
                        child: LinearProgressIndicator(
                          value: inspectionController.recordingProgress,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                      20.verticalSpace,
                    ],
                  )
                : SizedBox.shrink(),
          ),

          // Recording Instructions
          Obx(
            () => !inspectionController.isRecording.value
                ? Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        EdwardbText(
                          'Ready to Record',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        10.verticalSpace,
                        EdwardbText(
                          'Capture all exterior and interior views\nMaximum duration: 60 seconds',
                          color: Colors.white70,
                          fontSize: 16,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),

          40.verticalSpace,

          // Record Button
          GestureDetector(
            onTap: () async {
              if (!inspectionController.isRecording.value) {
                await inspectionController.startVideoRecording();
              } else {
                await inspectionController.stopVideoRecording();
                // Navigate to preview after recording stops
                Get.off(() => VideoPreviewScreen());
              }
            },
            child: Obx(
              () => Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: inspectionController.isRecording.value
                      ? Colors.red
                      : Colors.white,
                  border: Border.all(
                    color: inspectionController.isRecording.value
                        ? Colors.white
                        : Colors.red,
                    width: 4,
                  ),
                ),
                child: Icon(
                  inspectionController.isRecording.value
                      ? Icons.stop
                      : Icons.videocam,
                  color: inspectionController.isRecording.value
                      ? Colors.white
                      : Colors.red,
                  size: 32.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// NEW: Video Preview Screen
class VideoPreviewScreen extends StatelessWidget {
  final inspectionController = Get.find<InspectionController>();

  VideoPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        child: Icon(Icons.arrow_circle_left_outlined, size: 30.sp),
        onTap: () => Get.back(),
      ),
      title: Row(
        children: [
          EdwardbText(
            'Video Preview',
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ],
      ),
    );
  }

  _body() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // Success Header
            // Row(
            //   children: [
            //     Icon(Icons.videocam, size: 30.sp, color: kPrimaryColor),
            //     15.horizontalSpace,
            //     EdwardbText(
            //       'Recording Complete',
            //       fontWeight: FontWeight.w700,
            //       fontSize: 24,
            //     ),
            //   ],
            // ),
            // 40.verticalSpace,

            // Video Preview Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video player placeholder
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black,
                      ),
                      // Play button overlay
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            20.verticalSpace,
                            EdwardbText(
                              'Video Recorded Successfully',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            10.verticalSpace,
                            Obx(
                              () => EdwardbText(
                                'Duration: ${inspectionController.formattedTime}',
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            40.verticalSpace,

            // // Recording Info
            // Container(
            //   padding: EdgeInsets.all(20.w),
            //   decoration: BoxDecoration(
            //     color: Colors.green.shade50,
            //     borderRadius: BorderRadius.circular(12.r),
            //     border: Border.all(color: Colors.green.shade200),
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(Icons.check_circle, color: Colors.green, size: 28.sp),
            //       15.horizontalSpace,
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             EdwardbText(
            //               'Video Recorded Successfully',
            //               fontSize: 18,
            //               fontWeight: FontWeight.w600,
            //               color: Colors.green.shade700,
            //             ),
            //             5.verticalSpace,
            //             EdwardbText(
            //               'Your vehicle inspection video has been captured',
            //               fontSize: 14,
            //               fontWeight: FontWeight.w400,
            //               color: Colors.green.shade600,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            40.verticalSpace,

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: EdwardbButton(
                    label: 'Retake Video',
                    onPressed: () {
                      inspectionController.deleteVideo();
                      Get.back(); // Go back to recording screen
                    },
                    backgroundColor: Colors.red.shade400,
                  ),
                ),
                20.horizontalSpace,
                Expanded(
                  child: EdwardbButton(
                    label: 'Continue',
                    onPressed: () {
                      inspectionController.proceedToNextScreen();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
