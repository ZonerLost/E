import 'package:edwardb/config/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edwardb/config/routes/routes_names.dart';
import 'package:edwardb/services/share_pref_service.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final hasUserId = await SharePrefService.instance.hasUserId();
      if (hasUserId) {
        Get.offAllNamed(RouteName.dashboardScreen);
      } else {
        Get.offAllNamed(RouteName.loginScreen);
      }
    } catch (e) {
      Get.offAllNamed(RouteName.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
    );
  }
}
