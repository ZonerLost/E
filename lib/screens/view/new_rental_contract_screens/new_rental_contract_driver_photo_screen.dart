import 'dart:io';

import 'package:edwardb/controllers/new_rental_contract_controller/new_rental_contract_controller.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:edwardb/screens/view/new_rental_contract_screens/new_rental_contract_final_sign_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NewRentalContractDriverPhotoScreen extends StatefulWidget {
  const NewRentalContractDriverPhotoScreen({super.key});

  @override
  State<NewRentalContractDriverPhotoScreen> createState() =>
      _NewRentalContractDriverPhotoScreenState();
}

class _NewRentalContractDriverPhotoScreenState
    extends State<NewRentalContractDriverPhotoScreen> {
  final controller = Get.find<NewRentalContractController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        child: Icon(Icons.arrow_circle_left_outlined, size: 30.sp),
        onTap: () => Get.back(),
      ),
      title: EdwardbText(
        'Start New Rental Contract',
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
    );
  }

  _body() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_3_rounded, size: 30.sp),
                    10.horizontalSpace,
                    EdwardbText(
                      'Customer Information',
                      fontWeight: FontWeight.w700,
                      fontSize: 34,
                    ),
                  ],
                ),

                50.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 15.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      // Avatar Section
                      Obx(() {
                        return controller.DRIVER_PHOTO.value != null
                            ? CircleAvatar(
                                radius: 70.r,
                                backgroundImage: FileImage(
                                  File(controller.DRIVER_PHOTO.value!),
                                ),
                              )
                            : CircleAvatar(
                                radius: 70.r,
                                backgroundColor: const Color(0xFFF3F4F6),
                                child: Icon(
                                  Icons.person_3_rounded,
                                  color: const Color(0xFF6B7280),
                                ),
                              );
                      }),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            EdwardbText("Take Driver Photo"),

                            20.horizontalSpace,

                            SizedBox(
                              width: 240.w,
                              child: EdwardbButton(
                                label: 'Take Photo',
                                onPressed: () => controller.pickDriverPhoto(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                50.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 15.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      // License Photo Section - Rectangle Shape
                      Obx(() {
                        return controller.LICENSE_PHOTO.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Container(
                                  width: 190.w,
                                  height: 140.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(controller.LICENSE_PHOTO.value!),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 140.w,
                                height: 90.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: const Color(0xFFF3F4F6),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: Icon(
                                  Icons.card_membership_rounded,
                                  color: const Color(0xFF6B7280),
                                  size: 40.sp,
                                ),
                              );
                      }),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            EdwardbText("Take Driver License Photo"),

                            20.horizontalSpace,

                            SizedBox(
                              width: 240.w,
                              child: EdwardbButton(
                                label: 'Take Photo',
                                onPressed: () => controller.pickLicensePhoto(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                100.verticalSpace,
                EdwardbButton(
                  label: 'Next',
                  onPressed: () {
                    if (controller.validateDriverAndLicensePhoto()) {
                      Get.to(() => NewRentalContractFinalSignScreen());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
