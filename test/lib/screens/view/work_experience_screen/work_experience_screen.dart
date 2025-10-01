import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/screens/custom/custom_text/custom_text.dart';
import 'package:get/get.dart';

import '../../../config/constant/colors.dart';
import '../../../config/routes/routes_names.dart';
import '../../../controllers/onboarding_process_controller/onboarding_process_controller.dart';
import '../../custom/custom_button/custom_button.dart';
import '../../custom/custom_text_from_field/custom_text_from_field.dart';

class WorkExperienceScreen extends StatefulWidget {
  const WorkExperienceScreen({super.key});

  @override
  State<WorkExperienceScreen> createState() => _WorkExperienceScreenState();
}

class _WorkExperienceScreenState extends State<WorkExperienceScreen> {
  final onboardingProcessController = Get.put(OnboardingProcessController());
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
                    'Work Experience',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  16.verticalSpace,
                  FreelanceMarketText(
                    "Highlight your previous job roles, responsibilities, and achievements with ease.",
                    fontSize: 14,
                    maxLines: 3,
                    color: kTextSecondaryColor,
                  ),
                  30.verticalSpace,
                  Row(
                    children: [
                      Icon(Icons.school, color: kPrimaryColor, size: 24.sp),
                      8.horizontalSpace,
                      FreelanceMarketText(
                        'Upload Document',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  _docUploadContainer(),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Company Name*',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Job Title*',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Job Type*',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Obx(() {
                        return Checkbox(
                          value: onboardingProcessController
                              .currentlyEnrolled
                              .value,
                          activeColor: kPrimaryColor,
                          onChanged: (value) => onboardingProcessController
                              .currentlyEnrolled
                              .toggle(),
                        );
                      }),
                      Expanded(
                        child: FreelanceMarketText(
                          'I am currently enrolled',
                          color: kTextSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Start Date',
                    suffixIcon: Icons.calendar_month,
                  ),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'End Date (or expected)',
                    suffixIcon: Icons.calendar_month,
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: FreelanceMarketTextField(
                          controller: TextEditingController(),
                          hintText: 'Country',
                          suffixIcon: Icons.arrow_drop_down,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: FreelanceMarketTextField(
                          controller: TextEditingController(),
                          hintText: 'Country',
                          suffixIcon: Icons.arrow_drop_down,
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'City',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Job Nature*',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Description',
                    maxLines: 6,
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ),

          FreelanceMarketButton(
            label: 'Next',
            onPressed: () {
              Get.toNamed(RouteName.skillsCompetenciesScreen);
            },
          ),
        ],
      ),
    );
  }

  /// Component

  _docUploadContainer() {
    return DottedBorder(
      options: RectDottedBorderOptions(
        dashPattern: [10, 5],
        strokeWidth: 2,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 24.w),
        color: kTextSecondaryColor,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Icon(
              Icons.upload_file_rounded,
              color: kTextSecondaryColor,
              size: 40.sp,
            ),
            8.verticalSpace,
            FreelanceMarketText(
              'Browse or Tap the files you want to upload from your phone',
              fontSize: 14,
              maxLines: 3,
              textAlign: TextAlign.center,
              color: kTextSecondaryColor,
            ),
            16.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(Icons.add, color: kWhiteColor, size: 40.sp),
            ),
          ],
        ),
      ),
    );
  }
}
