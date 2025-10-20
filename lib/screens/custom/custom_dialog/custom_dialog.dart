import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showCustomDialog({
  required String title,
  required String message,
  String confirmText = "Confirm",
  String cancelText = "Cancel",
  Color confirmColor = const Color(0xFF2C3647),
  Color cancelColor = const Color(0xFFB22222),
  IconData? icon,
  Function()? onConfirm, 
}) async {
  final isLoading = false.obs;
  return await Get.defaultDialog<bool>(
    title: title,
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
    middleText: message,
    middleTextStyle: const TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    backgroundColor: Colors.white,
    radius: 12,
    barrierDismissible: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    content: Obx(() => Column(
      children: [
        EdwardbText(message, fontSize: 18, fontWeight: FontWeight.bold,),
      SizedBox(
        height: 20,
      ),
        Row(
          spacing: 10,
          children: [
          Expanded(child: EdwardbButton(label: cancelText, backgroundColor: cancelColor, onPressed: (){
            Get.back();
          })),
        Expanded(child: isLoading.value ?  Center(child: CircularProgressIndicator.adaptive(),) : EdwardbButton(label: confirmText, 
         backgroundColor: confirmColor, onPressed: ()async{
          isLoading.value = true;
                        await onConfirm!();           
                        Get.back(result: true);
         })),
        
          ],
        ),
      ],
    ))
  );
}
