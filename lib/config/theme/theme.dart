
import '../constant/colors.dart';
import 'package:flutter/material.dart';

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
