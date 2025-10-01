import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/assets/assets.dart';
import 'package:freelance_market/config/constant/colors.dart';
import 'package:freelance_market/screens/custom/custom_button/custom_button.dart';
import 'package:get/get.dart';

import '../../custom_text/custom_text.dart';

class SuccessPopUp {
  static void show({
    required String title,
    required String description,
    required VoidCallback callBack,
    required String callBackButtonText,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withAlpha(20),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.succcessPopUp, width: 120.w),
              FreelanceMarketText(
                title,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              10.verticalSpace,
              FreelanceMarketText(
                description,
                fontSize: 14,
                maxLines: 3,
                textAlign: TextAlign.center,
                color: kTextSecondaryColor,
              ),
              24.verticalSpace,
              FreelanceMarketButton(
                label: callBackButtonText,
                onPressed: callBack,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
