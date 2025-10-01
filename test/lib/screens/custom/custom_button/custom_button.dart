import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/constant/colors.dart';

class FreelanceMarketButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;
  // final double width;
  final double? width;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double borderRadius;
  final BorderSide? border;
  final double? elevation;

  const FreelanceMarketButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 48,
    this.width = double.infinity,
    this.fontSize = 16,
    this.backgroundColor = kPrimaryColor,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w700,
    this.borderRadius = 8,
    this.border,
    this.elevation = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      // width: width.w,
      width: width?.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            side: border ?? BorderSide.none,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: fontSize.sp,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
