import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/screens/custom/custom_text_from_field/custom_text_from_field.dart';
import 'package:get/get.dart';
import '../../../../config/constant/colors.dart';
import '../../../../config/enum/service_type.dart';
import '../../../../config/routes/routes_names.dart';
import '../../../../controllers/onboarding_process_controller/onboarding_process_controller.dart';
import '../../custom/custom_button/custom_button.dart';
import '../../custom/custom_text/custom_text.dart';

class SkillsCompetenciesScreen extends StatefulWidget {
  const SkillsCompetenciesScreen({super.key});

  @override
  State<SkillsCompetenciesScreen> createState() =>
      _SkillsCompetenciesScreenState();
}

class _SkillsCompetenciesScreenState extends State<SkillsCompetenciesScreen> {
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
                    'Skills & Competencies',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  16.verticalSpace,
                  FreelanceMarketText(
                    "List your strengths and areas of expertise to stand out to potential employers.",
                    fontSize: 14,
                    maxLines: 3,
                    color: kTextSecondaryColor,
                  ),
                  30.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: "Add a skill (e.g Typing)",
                  ),
                  16.verticalSpace,
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 12.h,
                    children: onboardingProcessController.skillsList.map((
                      skill,
                    ) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FreelanceMarketText(
                              skill,
                              fontSize: 14,
                              color: kWhiteColor,
                            ),
                            4.horizontalSpace,
                            Icon(Icons.close, color: kWhiteColor),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  24.verticalSpace,

                  FreelanceMarketText(
                    'Recommended Skills',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),

                  12.verticalSpace,

                  Wrap(
                    spacing: 10.w,
                    runSpacing: 12.h,
                    children: onboardingProcessController.recommendedSkillsList
                        .map((skill) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(16.r),
                              border: BoxBorder.all(color: kPrimaryColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FreelanceMarketText(
                                  skill,
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                ),
                                4.horizontalSpace,
                                Icon(Icons.close, color: kPrimaryColor),
                              ],
                            ),
                          );
                        })
                        .toList(),
                  ),

                  24.verticalSpace,

                  FreelanceMarketText(
                    'Service offered',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),

                  8.verticalSpace,

                  FreelanceMarketText(
                    "Do your clients come to you, do you go to them, or both?",
                    fontSize: 14,
                    maxLines: 3,
                    color: kTextSecondaryColor,
                  ),
                  24.verticalSpace,
                  Divider(),
                  12.verticalSpace,
                  _inPersonOrOnline(),
                  26.verticalSpace,
                ],
              ),
            ),
          ),
          FreelanceMarketButton(
            label: 'Next',
            onPressed: () {
              Get.toNamed(RouteName.preferredServiceTypeScreen);
            },
          ),
        ],
      ),
    );
  }

  _inPersonOrOnline() {
    return Obx(() {
      final List<Map<String, dynamic>> serviceTypes = [
        {
          'title': 'In-person',
          'description':
              'I\'m on the go. My services are performed at the client\'s location.',
          'value': ServiceType.inPerson,
        },
        {
          'title': 'Online',
          'description': 'I\'m on the go. My services are performed online.',
          'value': ServiceType.online,
        },
      ];

      return Column(
        children: [
          ...List.generate(serviceTypes.length, (index) {
            final serviceTypeData = serviceTypes[index];
            final isSelected =
                onboardingProcessController.serviceType.value ==
                serviceTypeData['value'];

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    onboardingProcessController.serviceType.value =
                        serviceTypeData['value'];
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            onboardingProcessController.serviceType.value =
                                serviceTypeData['value'];
                          },
                          activeColor: kPrimaryColor,
                          checkColor: kWhiteColor,
                          side: BorderSide(
                            color: isSelected
                                ? kPrimaryColor
                                : kTextSecondaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FreelanceMarketText(
                              serviceTypeData['title'],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kBlackColor,
                            ),
                            8.verticalSpace,
                            FreelanceMarketText(
                              serviceTypeData['description'],
                              fontSize: 12,
                              color: kTextSecondaryColor,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < serviceTypes.length - 1) 16.verticalSpace,
              ],
            );
          }),
        ],
      );
    });
  }
}
