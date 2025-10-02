import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/constant/colors.dart';
import 'package:freelance_market/screens/custom/custom_button/custom_button.dart';
import 'package:freelance_market/screens/custom/custom_text/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../controllers/auth_controller/auth_controller.dart';

class OptScreen extends StatefulWidget {
  static void showSheet() {
    Get.bottomSheet(
      const OptScreen(),
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
    );
  }

  const OptScreen({super.key});

  @override
  State<OptScreen> createState() => _OptScreenState();
}

class _OptScreenState extends State<OptScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            width: double.infinity,
            height: 0.9.sh,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top handle/divider
                  Container(
                    width: 80.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: kTextSecondaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  30.verticalSpace,

                  // Title
                  FreelanceMarketText(
                    'OTP Verification',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),

                  16.verticalSpace,

                  // Description
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: FreelanceMarketText(
                      'Enter the One-Time Password (OTP) sent to your email to verify your account.',
                      fontSize: 14,
                      color: kTextSecondaryColor,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                  30.verticalSpace,
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: kTextSecondaryColor,
                    fieldWidth: 0.12.sw,
                    focusedBorderColor: kPrimaryColor,
                    cursorColor: kPrimaryColor,
                    showFieldAsBox: true,
                    autoFocus: true,
                    borderRadius: BorderRadius.circular(8.r),
                    textStyle: GoogleFonts.inter(
                      color: kPrimaryColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(),
                    onSubmit: (String verificationCode) {
                      Get.back();
                    },
                  ),
                  30.verticalSpace,
                  // Send Reset Link Button
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: FreelanceMarketButton(
                      label: 'Confirm',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// ============ Validators =============
  ///
  String? optValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';

    value = value.trim();

    if (value.isEmpty) return 'Email cannot be empty';

    if (!GetUtils.isEmail(value)) return 'Please enter a valid email address';

    return null;
  }
}
