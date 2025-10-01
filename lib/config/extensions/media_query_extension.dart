import 'package:flutter/material.dart';

extension ScreenSizes on BuildContext {
Size get mediaquery => MediaQuery.sizeOf(this);

double get screenHeight => mediaquery.height;
double get screenWidth => mediaquery.width;

}