import 'package:flutter/material.dart';
import 'package:freelance_market/screens/custom/custom_button/custom_button.dart';
import 'package:freelance_market/screens/custom/pop_ups/success_pop_up/success_pop_up.dart';
import 'package:get/get.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FreelanceMarketButton(
            label: 'SHOW',
            onPressed: () {
              SuccessPopUp.show(
                title: "Success!",
                description:
                    "Your account has been verified, and \n you're all set to explore the app.",
                callBack: () => Get.back(),
                callBackButtonText: 'Back to Login',
              );
            },
          ),
        ],
      ),
    );
  }
}
