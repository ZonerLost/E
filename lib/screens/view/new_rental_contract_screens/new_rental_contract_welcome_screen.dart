import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:edwardb/screens/view/new_rental_contract_screens/new_rental_contract_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NewRentalContractWelcomeScreen extends StatelessWidget {
  const NewRentalContractWelcomeScreen({super.key});

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
        'Start New Rental Contract',
        fontWeight: FontWeight.w700,
        fontSize: 24,
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
            EdwardbText('Welcome!', fontWeight: FontWeight.w700, fontSize: 34),

            20.verticalSpace,
            EdwardbText(
              'Let\'s begin the agreement process.',
              fontWeight: FontWeight.w400,
              fontSize: 24,
            ),

            100.verticalSpace,

            EdwardbText(
              'You\'ll fill:',
              fontWeight: FontWeight.w600,
              fontSize: 34,
            ),

            20.verticalSpace,
            Row(
              children: [
                CustomBullet(),
                20.horizontalSpace,
                EdwardbText(
                  'Customer Info',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ],
            ),

            50.verticalSpace,
            Row(
              children: [
                CustomBullet(),
                20.horizontalSpace,
                EdwardbText(
                  'Review Agreement Terms',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ],
            ),

            50.verticalSpace,
            Row(
              children: [
                CustomBullet(),
                20.horizontalSpace,
                EdwardbText(
                  'Driver and / Driver License Photos',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ],
            ),

            100.verticalSpace,

            EdwardbButton(
              label: 'Begin',
              onPressed: () {
                // Handle button press
                Get.to(() => NewRentalContractInfoScreen());
              },
            ),
          ],
        ),
      ),
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
