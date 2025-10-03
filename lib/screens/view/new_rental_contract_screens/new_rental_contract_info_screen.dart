
import 'package:edwardb/config/utils/utils.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:edwardb/screens/custom/custom_text_from_field/custom_text_from_field.dart';
import 'package:edwardb/screens/view/new_rental_contract_screens/term_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/new_rental_contract_controller/new_rental_contract_controller.dart';

class NewRentalContractInfoScreen extends StatefulWidget {
  const NewRentalContractInfoScreen({super.key});

  @override
  State<NewRentalContractInfoScreen> createState() =>
      _NewRentalContractInfoScreenState();
}

class _NewRentalContractInfoScreenState
    extends State<NewRentalContractInfoScreen> {
  final controller = Get.put(NewRentalContractController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

                60.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: EdwardbTextField(
                        controller: controller.firstName,
                        hintText: 'First Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: EdwardbTextField(
                        controller: controller.lastName,
                        hintText: 'Last Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                40.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: EdwardbTextField(
                        controller: controller.phoneNumber,
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: EdwardbTextField(
                        controller: controller.email,
                        hintText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                40.verticalSpace,
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Expanded(
                      child: EdwardbTextField(
                        controller: controller.licenseNumber,
                        hintText: 'License Number',
                        
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the license number';
                          }
                          // Add date validation if needed
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          String date = await Utils.showDatePickerDialog(
                            context,
                          );
                          controller.date.text = date;
                        },
                        child: AbsorbPointer(
                          child: EdwardbTextField(
                            controller: controller.date,
                            hintText: 'Date',
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the date';
                              }
                              // Add date validation if needed
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                   
                    
                  ],
                ),

                100.verticalSpace,

                EdwardbButton(
                  label: 'Next',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Handle next button press
                      Get.to(() => TermCondition());
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
