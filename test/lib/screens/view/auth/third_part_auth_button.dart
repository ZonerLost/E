import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/constant/colors.dart';

Widget thirdPartyAuthButton({
  required String icon,
  required VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: kTextSecondaryColor.withAlpha(50)),
      ),
      child: Image.asset(icon, width: 24.w),
    ),
  );
}
