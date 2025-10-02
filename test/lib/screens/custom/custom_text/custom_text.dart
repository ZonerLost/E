import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/constant/colors.dart';

class FreelanceMarketText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;
  final bool isUnderline;
  final bool isItalic;

  const FreelanceMarketText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color = kTextPrimaryColor,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.isUnderline = false,
    this.isItalic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.inter(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        decoration: isUnderline
            ? TextDecoration.underline
            : TextDecoration.none,
        decorationColor: color,
      ),
    );
  }
}
