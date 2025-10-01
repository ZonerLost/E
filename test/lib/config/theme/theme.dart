import 'package:google_fonts/google_fonts.dart';

import '../constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: kWhiteColor,

      checkboxTheme: CheckboxThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: kWhiteColor,
        elevation: 5,
        position: PopupMenuPosition.under,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kPrimaryColor,
        selectedIconTheme: IconThemeData(color: kWhiteColor),
        unselectedIconTheme: IconThemeData(color: kTextSecondaryColor),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark();
  }
}
