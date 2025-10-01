import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/constant/colors.dart';

class EdwardbTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  // final IconData? prefixIcon;
  final bool readOnly;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;

  const EdwardbTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.suffixIcon,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: kTextPrimaryColor, fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        hintStyle: GoogleFonts.inter(
          color: kTextSecondaryColor,
          fontSize: 16.sp,
        ),
        labelStyle: GoogleFonts.inter(
          color: kTextSecondaryColor,
          fontSize: 16.sp,
        ),
        // prefixIcon: prefixIcon != null
        //     ? Icon(prefixIcon, color: kTextSecondaryColor, size: 24.w)
        //     : null,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: kTextSecondaryColor)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kTextSecondaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kTextSecondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kRedColor),
        ),
        errorStyle: GoogleFonts.inter(
          color: kRedColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kRedColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      ),
    );
  }
}
