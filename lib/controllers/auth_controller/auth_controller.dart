import 'dart:developer';

import 'package:edwardb/config/routes/routes_names.dart';
import 'package:edwardb/controllers/auth_controller/auth_repository.dart';
import 'package:edwardb/services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController implements AuthRepository {
  RxBool controllerIsBusy = false.obs;

  ///
  /// ===== LOGIN ======
  ///

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = RxBool(false);

  @override
  Future<void> signIn() async {
    if (controllerIsBusy.value) return;
    try {
      controllerIsBusy.value = true;
      await FirebaseService.instance.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
        rememberMe.value,
      );
      Get.offAllNamed(RouteName.dashboardScreen);
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      controllerIsBusy.value = false;
    }
  }
}
