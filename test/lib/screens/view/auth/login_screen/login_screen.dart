import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/assets/assets.dart';
import 'package:freelance_market/config/constant/colors.dart';
import 'package:freelance_market/screens/custom/custom_button/custom_button.dart';
import 'package:freelance_market/screens/custom/custom_text/custom_text.dart';
import 'package:freelance_market/screens/custom/custom_text_from_field/custom_text_from_field.dart';
import 'package:get/get.dart';

import '../../../../../config/routes/routes_names.dart';
import '../../../../../controllers/auth_controller/auth_controller.dart';
import '../forgot_password_screen/forgot_password_screen.dart';
import '../third_part_auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

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
                  'Welcome Back',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                8.verticalSpace,
                FreelanceMarketText(
                  'Enter your credentials to access your account and continue your job search journey.',
                  fontSize: 14,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  color: kTextSecondaryColor,
                ),
                30.verticalSpace,
                FreelanceMarketTextField(
                  controller: authController.loginEmailController,
                  hintText: 'Your email here...',
                  validator: emailValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                16.verticalSpace,
                FreelanceMarketTextField(
                  controller: authController.loginPasswordController,
                  hintText: 'Your password here...',
                  validator: passwordValidator,
                  keyboardType: TextInputType.visiblePassword,
                ),
                16.verticalSpace,
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => ForgotPasswordScreen.showSheet(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FreelanceMarketText(
                      'Forgot Password?',
                      fontSize: 14,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                36.verticalSpace,
                Row(
                  children: [
                    Obx(() {
                      return Checkbox(
                        value: authController.isRememberMe.value,
                        activeColor: kPrimaryColor,
                        onChanged: (value) =>
                            authController.isRememberMe.toggle(),
                      );
                    }),
                    FreelanceMarketText(
                      'Remember me',
                      color: kTextSecondaryColor,
                    ),
                  ],
                ),
                16.verticalSpace,
                FreelanceMarketButton(
                  label: 'Login',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.offAndToNamed(RouteName.chooseYourRoleScreen);
                    }
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
                      "Don't have an account? ",
                      fontSize: 14,
                      color: kTextSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Get.offAndToNamed(RouteName.createAccountScreen),
                      child: FreelanceMarketText(
                        "Create account",
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
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';

    value = value.trim();

    if (value.isEmpty) return 'Email cannot be empty';

    if (!GetUtils.isEmail(value)) return 'Please enter a valid email address';

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';

    if (value.length < 6) return 'Password must be at least 6 characters long';

    return null;
  }
}
