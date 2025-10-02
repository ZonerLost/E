import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  ///
  /// ===== LOGIN ======
  ///

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  RxBool isRememberMe = true.obs;

  ///
  /// ===== CREATE ACCOUNT ======
  ///
  final createAccountNameController = TextEditingController();
  final createAccountEmailController = TextEditingController();
  final createAccountPasswordController = TextEditingController();
  final createAccountConfirmPasswordController = TextEditingController();
  RxBool isAgreeToTerms = false.obs;

  ///
  /// ===== FORGOT PASSWORD ======
  ///
  final forgotPasswordEmailController = TextEditingController();
}
