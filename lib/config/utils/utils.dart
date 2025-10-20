import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Utils {
  static Future<String> showDatePickerDialog(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((selectedDate) {
      if (selectedDate != null) {
        final formattedDate =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
        return formattedDate;
      } else {
        return '';
      }
    });
  }

static Future<String> showMothPickerDialog(BuildContext context) async {
  final DateTime? selectedDate = await showMonthPicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (selectedDate != null) {
    final formattedDate = DateFormat('MMM/yyyy').format(selectedDate);
    return formattedDate; 
  } else {
    return '';
  }
}


  static Future<XFile?> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      return pickedFile;
    } catch (e) {
      return null;
    }
  }

  /// ========================= Show Success Snackbar ==============================
  // static void showSuccessSnackbar(String title, String message) {
  //   Get.closeAllSnackbars();
  //   Get.snackbar(
  //     title,
  //     message,
  //     titleText: Driver4Text(
  //       title,
  //       fontSize: 16,
  //       fontWeight: FontWeight.bold,
  //       color: kWhiteColor,
  //     ),
  //     messageText: Driver4Text(
  //       message,
  //       fontSize: 12,
  //       maxLines: 3,
  //       color: kWhiteColor,
  //     ),
  //     backgroundColor: kPrimaryColor,
  //     colorText: kWhiteColor,
  //     icon: Icon(Icons.check, color: kWhiteColor, size: 20.sp),
  //     borderRadius: 10.r,
  //     margin: EdgeInsets.all(16.w),
  //     snackPosition: SnackPosition.TOP,
  //     duration: const Duration(seconds: 2),
  //   );
  // }

  /// ========================= Show Error Snackbar ==============================
  static void showErrorSnackbar(String title, String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      titleText: EdwardbText(
        title,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      messageText: EdwardbText(
        message,
        fontSize: 12,
        maxLines: 3,
        color: Colors.white,
      ),
      backgroundColor: kPrimaryColor,
      colorText: Colors.white,
      icon: Icon(Icons.error, size: 30.sp, color: Colors.white),
      borderRadius: 10.r,
      margin: EdgeInsets.all(16.w),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }
}
