import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/screens/custom/custom_text/custom_text.dart';
import 'package:get/get.dart';
import '../../../../config/constant/colors.dart';
import '../../../../controllers/onboarding_process_controller/onboarding_process_controller.dart';
import '../../custom/custom_button/custom_button.dart';
import 'time_picke_sheet.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  final onboardingProcessController = Get.put(OnboardingProcessController());

  final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: _body()));
  }

  _body() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FreelanceMarketText(
                    'Working Hours',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  8.verticalSpace,
                  FreelanceMarketText(
                    "When can clients book with you?",
                    fontSize: 14,
                  ),
                  35.verticalSpace,

                  // Working hours list
                  ...List.generate(weekDays.length, (index) {
                    return Column(
                      children: [
                        _buildWorkingHourRow(weekDays[index], index),
                        20.verticalSpace,
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          FreelanceMarketButton(label: 'Continue', onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildWorkingHourRow(String day, int index) {
    return Row(
      children: [
        // Day name
        Expanded(flex: 2, child: FreelanceMarketText(day, fontSize: 16)),

        // Time range or OFF button
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              TimePickerSheet.showSheet(
                selectedTime: '09:00 am',
                onTimeSelected: (selectedTime) {
                  log('Selected time: $selectedTime');
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Time range container
                if (index != 1)
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: kTextSecondaryColor,
                          width: 1,
                        ),
                      ),
                      child: FreelanceMarketText(
                        '00:00 - 00:00',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // OFF button for Tuesday
                if (index == 1)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: kTextSecondaryColor, width: 1),
                    ),
                    child: FreelanceMarketText(
                      'OFF',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kBlackColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
