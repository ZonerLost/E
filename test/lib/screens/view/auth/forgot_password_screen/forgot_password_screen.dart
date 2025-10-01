import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/constant/colors.dart';
import 'package:freelance_market/screens/custom/custom_button/custom_button.dart';
import 'package:freelance_market/screens/custom/custom_text/custom_text.dart';
import 'package:freelance_market/screens/custom/custom_text_from_field/custom_text_from_field.dart';
import 'package:get/get.dart';

import '../../../../../controllers/auth_controller/auth_controller.dart';
import '../opt_screen/opt_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static void showSheet() {
    Get.bottomSheet(
      const ForgotPasswordScreen(),
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
    );
  }

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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
                    'Forgot Password',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),

                  16.verticalSpace,

                  // Description
                  FreelanceMarketText(
                    'Forgot your password? No worries! Enter your email below to receive a reset link.',
                    fontSize: 14,
                    color: kTextSecondaryColor,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                  30.verticalSpace,

                  // Email Input Field
                  FreelanceMarketTextField(
                    controller: authController.forgotPasswordEmailController,
                    hintText: 'Your email here...',
                    validator: emailValidator,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  40.verticalSpace,

                  // Send Reset Link Button
                  FreelanceMarketButton(
                    label: 'Send Password Reset Link',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Get.back();
                        await Future.delayed(const Duration(milliseconds: 500));
                        OptScreen.showSheet();
                      }
                    },
                  ),
                  24.verticalSpace,

                  // Back to Login
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Back to ',
                            style: TextStyle(
                              fontSize: 14,
                              color: kTextSecondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';

    value = value.trim();

    if (value.isEmpty) return 'Email cannot be empty';

    if (!GetUtils.isEmail(value)) return 'Please enter a valid email address';

    return null;
  }
}
