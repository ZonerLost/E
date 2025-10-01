import 'package:google_fonts/google_fonts.dart';

import '../constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: kWhiteColor,
      appBarTheme: AppBarTheme(backgroundColor: kWhiteColor, elevation: 0),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark();
  }
}
