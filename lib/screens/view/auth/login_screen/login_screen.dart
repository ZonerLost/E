import 'package:edwardb/config/assets/assets.dart';
import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../controllers/auth_controller/auth_controller.dart';
import '../../../custom/custom_text/custom_text.dart';
import '../../../custom/custom_text_from_field/custom_text_from_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  _body() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                  child: Image.asset(AppAssets.bannerImage),
                ),
                48.verticalSpace,
                EdwardbText(
                  'Login',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                48.verticalSpace,

                EdwardbTextField(
                  controller: controller.emailController,
                  hintText: 'Username',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                24.verticalSpace,
                EdwardbTextField(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                24.verticalSpace,
                Obx(() {
                  return Row(
                    children: [
                      Checkbox(
                        value: controller.rememberMe.value,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {
                          controller.rememberMe.value = value!;
                        },
                      ),
                      EdwardbText('Remember me', color: Colors.black),
                    ],
                  );
                }),
                38.verticalSpace,
                Obx(() {
                  return EdwardbButton(
                    label: 'Login',
                    backgroundColor: controller.controllerIsBusy.value
                        ? Colors.grey
                        : kPrimaryColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await controller.signIn();

                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
