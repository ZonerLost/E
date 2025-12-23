import 'dart:developer';

import 'package:edwardb/config/utils/utils.dart';
import 'package:edwardb/controllers/auth_controller/auth_repository.dart';
import 'package:edwardb/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController implements AuthRepository {
  RxBool controllerIsBusy = false.obs;
  RxBool isEmailFound = false.obs;
  RxBool checkingForEmail = false.obs;
  RxBool isUpdatingPassword = false.obs;

  ///
  /// ===== LOGIN ======
  ///
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = RxBool(false);

  @override
  Future<void> signIn() async {
    try {
      controllerIsBusy.value = true;

      await FirebaseService.instance.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
        rememberMe.value,
      );

    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      controllerIsBusy.value = false;
    }
  }

  ///
  /// ===== CHECK EMAIL =====
  ///
  @override
  Future<bool> checkEmail(String email) async {
    try {
      checkingForEmail.value = true;

      bool isExist = await FirebaseService.instance.checkUserEmailExists(email.trim());

      if (!isExist) {
        Utils.showErrorSnackbar('Error', 'Please enter a valid email');
        return false;
      } else {
      await FirebaseService.instance.sendForgotPasswordEmail(email.trim());
        Utils.showSuccessSnackbar('Succes', 'Reset Link Sent to $email');
        // isEmailFound.value = true;
        Get.back();
        return true;

      }

    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', e.toString());
      return false; // FIX: Always return a value
    } finally {
      checkingForEmail.value = false;
    }
  }

  ///
  /// ===== FORGOT PASSWORD =====
  ///
  @override
  Future<void> forgotPassword(String password) async {
    // try {
    //   isUpdatingPassword.value = true;

    //   if (emailController.text.trim().isEmpty) {
    //     Utils.showErrorSnackbar('Error', 'Please enter an email');
    //     return;
    //   }

    //   await FirebaseService.instance.updateUserPassword(password.trim());
  
    //   Utils.showSuccessSnackbar(
    //     'Success',
    //     'Password reset email sent successfully.',
    //   );

    // } catch (e) {
    //   log(e.toString());
    //   Get.snackbar('Error', e.toString());
    // } finally {
    //   isUpdatingPassword.value = false;
    // }
  }
}
