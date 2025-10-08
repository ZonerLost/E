
import 'dart:io';
import 'package:edwardb/controllers/new_rental_contract_controller/new_rental_contract_controller.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:edwardb/screens/custom/custom_text_from_field/custom_text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class NewRentalContractFinalSignScreen extends StatefulWidget {
  const NewRentalContractFinalSignScreen({super.key});

  @override
  State<NewRentalContractFinalSignScreen> createState() =>
      _NewRentalContractFinalSignScreenState();
}

class _NewRentalContractFinalSignScreenState
    extends State<NewRentalContractFinalSignScreen> {
  final controller = Get.find<NewRentalContractController>();


  @override
  void initState() {
    super.initState();
    if (controller.cardExpiry.text.isNotEmpty) {
      final parts = controller.cardExpiry.text.split('/');
      if (parts.length == 3) {
        final formatted = "${parts[1].padLeft(2, '0')}/${parts[2]}";
        controller.cardExpiry.text = formatted;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  _appBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        child: Icon(Icons.arrow_circle_left_outlined, size: 30.sp),
        onTap: () => Get.back(),
      ),
      title: EdwardbText(
        'Start New Rental Contract',
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      // actions: [
      //   GestureDetector(
      //     onTap: () {
      //       // Handle menu tap
      //     },
      //     child: Padding(
      //       padding: EdgeInsets.only(right: 20.w),
      //       child: Icon(Icons.menu, size: 30.sp),
      //     ),
      //   ),
      // ],
    );
  }

  _body() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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

            // Customer Information Form
            _buildCustomerInfoSection(),

            50.verticalSpace,

            // Photo Section
            _buildPhotoSection(),

            50.verticalSpace,

            // Signature Section
            _buildSignatureSection(),

            100.verticalSpace,

            // Submit Button
            Obx(() {
              return controller.isScreenBusy.value
                  ? Center(child: CircularProgressIndicator())
                  : EdwardbButton(
                      label: 'Submit and Finish',
                      onPressed: () async {
                        if (await controller.validateSignature()) {
                          await controller.handleSubmit();
                        }
                      },
                    );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoSection() {
    return Column(
      children: [
        // First Name and Last Name
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 55.h,
                child: EdwardbTextField(
                  controller: controller.firstName,
                  hintText: 'First Name',
                  readOnly: true,
                ),
              ),
            ),
            20.horizontalSpace,
            Expanded(
              child: SizedBox(
                height: 55.h,
                child: EdwardbTextField(
                  controller: controller.lastName,
                  hintText: 'Last Name',
                  readOnly: true,
                ),
              ),
            ),
          ],
        ),

        40.verticalSpace,

        // Phone Number and Email
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 55.h,
                child: EdwardbTextField(
                  controller: controller.phoneNumber,
                  hintText: 'Phone Number',
                  readOnly: true,
                ),
              ),
            ),
            20.horizontalSpace,
            Expanded(
              child: SizedBox(
                height: 55.h,
                child: EdwardbTextField(
                  controller: controller.email,
                  hintText: 'Email Address',
                  readOnly: true,
                ),
              ),
            ),
          ],
        ),

        40.verticalSpace,

        // License Number and License Expiry Date
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 55.h,
                child: EdwardbTextField(
                  controller: controller.licenseNumber,
                  hintText: 'License Number',
                  readOnly: true,
                ),
              ),
            ),
            20.horizontalSpace,
            Expanded(
              child: SizedBox(
                height: 55.h,
                child: EdwardbTextField(
                  controller: controller.date,
                  hintText: 'License Expiry Date',
                  readOnly: true,
                ),
              ),
            ),
          ],
        ),
        40.verticalSpace,

        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 55.h,
                child: EdwardbTextField(
                  controller: controller.cardNumber,
                  hintText: 'Card Number',
                  readOnly: true,
                ),
              ),
            ),
            20.horizontalSpace,
            Expanded(
              child: SizedBox(
                height: 55.h,
                child: EdwardbTextField(
                  controller: controller.cardExpiry,
                  hintText: 'Card Expiry Date',
                  readOnly: true,
                ),
              ),
            ),
          ],
        ),
        40.verticalSpace,
        SizedBox(
                height: 55.h,
                child: EdwardbTextField(
                  controller: controller.cvcNumber,
                  hintText: 'CVV',
                  readOnly: true,
                ),
              ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      children: [
        // Driver Photo Section
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Obx(() {
                return controller.DRIVER_PHOTO.value != null
                    ? CircleAvatar(
                        radius: 40.r,
                        backgroundImage: FileImage(
                          File(controller.DRIVER_PHOTO.value!),
                        ),
                      )
                    : CircleAvatar(
                        radius: 40.r,
                        backgroundColor: const Color(0xFFF3F4F6),
                        child: Icon(
                          Icons.person_3_rounded,
                          color: const Color(0xFF6B7280),
                          size: 30.sp,
                        ),
                      );
              }),
              20.horizontalSpace,
              Expanded(
                child: EdwardbText(
                  "Driver Photo",
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: EdwardbText(
                  'Completed',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        20.verticalSpace,

        // License Photo Section
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Obx(() {
                return controller.LICENSE_PHOTO.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          width: 80.w,
                          height: 50.h,
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
                        width: 80.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: const Color(0xFFF3F4F6),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Icon(
                          Icons.card_membership_rounded,
                          color: const Color(0xFF6B7280),
                          size: 24.sp,
                        ),
                      );
              }),
              20.horizontalSpace,
              Expanded(
                child: EdwardbText(
                  "License Photo",
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: EdwardbText(
                  'Completed',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        20.verticalSpace,

        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Obx(() {
                return controller.CUSTOMER_LICENSE_PHOTO.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          width: 80.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(
                                File(controller.CUSTOMER_LICENSE_PHOTO.value!),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 80.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: const Color(0xFFF3F4F6),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Icon(
                          Icons.card_membership_rounded,
                          color: const Color(0xFF6B7280),
                          size: 24.sp,
                        ),
                      );
              }),
              20.horizontalSpace,
              Expanded(
                child: EdwardbText(
                  "Driver License Photo",
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: EdwardbText(
                  'Completed',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EdwardbText(
          'Enter signature using stylus or finger',
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ),
        20.verticalSpace,
        Container(
          width: double.infinity,
          height: 300.h,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Signature(
              controller: controller.signatureController,
              width: double.infinity,
              height: 300.h,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        20.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                controller.signatureController.clear();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: EdwardbText(
                  'Clear',
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
