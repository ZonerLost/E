import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/assets/assets.dart';
import '../../../../../config/constant/colors.dart';
import '../../../../../config/routes/routes_names.dart';
import '../../../../../controllers/auth_controller/auth_controller.dart';
import '../../../custom/custom_button/custom_button.dart';
import '../../../custom/custom_text/custom_text.dart';
import '../../../custom/custom_text_from_field/custom_text_from_field.dart';
import '../third_part_auth_button.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: _body()));
  }

  _body() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35.r,
                  backgroundColor: kPrimaryColor,
                  child: FreelanceMarketText('LOGO', color: Colors.white),
                ),
                16.verticalSpace,
                FreelanceMarketText(
                  'Create an account',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                8.verticalSpace,
                FreelanceMarketText(
                  'Start finding jobs that match your skills and preferences. Start your brilliant career now.',
                  fontSize: 14,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  color: kTextSecondaryColor,
                ),
                30.verticalSpace,

                // Name Field
                FreelanceMarketTextField(
                  controller: authController.createAccountNameController,
                  hintText: 'Your name here...',
                  validator: nameValidator,
                  keyboardType: TextInputType.name,
                ),
                16.verticalSpace,

                // Email Field
                FreelanceMarketTextField(
                  controller: authController.createAccountEmailController,
                  hintText: 'Your email here...',
                  validator: emailValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                16.verticalSpace,

                // Password Field
                FreelanceMarketTextField(
                  controller: authController.createAccountPasswordController,
                  hintText: 'Create Password...',
                  validator: passwordValidator,
                  obscureText: true,
                ),
                16.verticalSpace,

                // Confirm Password Field
                FreelanceMarketTextField(
                  controller:
                      authController.createAccountConfirmPasswordController,
                  hintText: 'Retype Password...',
                  validator: confirmPasswordValidator,
                  obscureText: true,
                ),
                36.verticalSpace,

                // Terms and Conditions Checkbox
                Row(
                  children: [
                    Obx(() {
                      return Checkbox(
                        value: authController.isAgreeToTerms.value,
                        activeColor: kPrimaryColor,
                        onChanged: (value) =>
                            authController.isAgreeToTerms.toggle(),
                      );
                    }),
                    Expanded(
                      child: FreelanceMarketText(
                        'I agree to Terms and Conditions',
                        color: kTextSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,

                FreelanceMarketButton(
                  label: 'Create Account',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
                16.verticalSpace,
                _divider('or continue with'),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    thirdPartyAuthButton(
                      icon: Platform.isIOS
                          ? AppAssets.appleIcon
                          : AppAssets.googleIcon,
                      onTap: () {},
                    ),
                    15.horizontalSpace,
                    thirdPartyAuthButton(
                      icon: AppAssets.facebookIcon,
                      onTap: () {},
                    ),
                  ],
                ),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FreelanceMarketText(
                      "Already have an account? ",
                      fontSize: 14,
                      color: kTextSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    GestureDetector(
                      onTap: () => Get.offAndToNamed(RouteName.loginScreen),
                      child: FreelanceMarketText(
                        "Login",
                        fontSize: 14,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _divider(String text) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: kTextSecondaryColor)),
        8.horizontalSpace,
        FreelanceMarketText(text, fontSize: 14, color: kTextSecondaryColor),
        8.horizontalSpace,
        Expanded(child: Container(height: 1, color: kTextSecondaryColor)),
      ],
    );
  }

  ///
  /// ============ Validators =============
  ///

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Name cannot be empty';

    value = value.trim();

    if (value.isEmpty) return 'Name cannot be empty';

    if (value.length < 2) return 'Name must be at least 2 characters long';

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';

    value = value.trim();

    if (value.isEmpty) return 'Email cannot be empty';

    if (!GetUtils.isEmail(value)) return 'Please enter a valid email address';

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';

    if (value.length < 8) return 'Password must be at least 8 characters long';

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';

    if (value != authController.createAccountPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }
}
