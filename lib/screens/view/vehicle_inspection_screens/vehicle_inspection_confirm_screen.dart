import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/controllers/inspection_controller/inspection_controller.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:edwardb/screens/view/new_rental_contract_screens/new_rental_contract_info_screen.dart';
import 'package:edwardb/screens/view/vehicle_inspection_screens/vehicle_inspection_contract_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class VehicleInspectionConfirmScreen extends StatelessWidget {
  VehicleInspectionConfirmScreen({super.key});

  final controller = Get.find<InspectionController>();

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
      title: EdwardbText(
        'Vehicle Inspection',
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      // actions: [
      //   GestureDetector(
      //     onTap: () {
      //       // Handle add contract tap
      //     },
      //     child: Padding(
      //       padding: EdgeInsets.only(right: 20.w),
      //       child: Icon(Icons.menu, size: 30.sp),
      //     ),
      //   ),
      // ],
    );
  }

  _body() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_car_filled, size: 30.sp),
                  10.horizontalSpace,
                  EdwardbText(
                    'Vehicle Inspection Complete',
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ],
              ),

              20.verticalSpace,
              EdwardbText(
                'Confirm Vehicle Condition',
                fontWeight: FontWeight.w700,
                fontSize: 34,
              ),
              20.verticalSpace,
              EdwardbText(
                'Please follow the steps to complete the vehicle walk-around process.',
                fontWeight: FontWeight.w400,
                fontSize: 24,
                maxLines: 3,
              ),

              100.verticalSpace,

              Row(
                children: [
                  CustomBullet(),
                  20.horizontalSpace,
                  Expanded(
                    child: EdwardbText(
                      'Please ask the customer to review the video and confirm the vehicle condition.',
                      maxLines: 3,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),

              50.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: EdwardbText(
                      'I confirm that the video accurately reflects the condition of the vehicle I am receiving.',
                      maxLines: 3,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              50.verticalSpace,

              _buildSignatureSection(),

              20.verticalSpace,

              Obx(() {
                return controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : EdwardbButton(
                        label: 'Begin',
                        onPressed: () {
                          // Handle button press
                          controller.submitInspection();
                        },
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EdwardbText(
          'Enter signature using stylus or finger',
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ),
        20.verticalSpace,
        Container(
          width: double.infinity,
          height: 300.h,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Signature(
              controller: controller.signatureController,
              width: double.infinity,
              height: 300.h,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        20.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                controller.signatureController.clear();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: EdwardbText(
                  'Clear',
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomBullet extends StatelessWidget {
  const CustomBullet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(24.w, 44.h), painter: TrianglePainter());
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kPrimaryColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, size.height / 2); // Start at the middle-right
    path.lineTo(0, 0); // Top-left corner
    path.lineTo(0, size.height); // Bottom-left corner
    path.close(); // Close the path to form the triangle

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
