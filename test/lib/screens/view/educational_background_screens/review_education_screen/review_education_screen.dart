import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/assets/assets.dart';
import 'package:get/get.dart';

import '../../../../../config/constant/colors.dart';
import '../../../../../config/routes/routes_names.dart';
import '../../../../../controllers/onboarding_process_controller/onboarding_process_controller.dart';
import '../../../custom/custom_button/custom_button.dart';
import '../../../custom/custom_text/custom_text.dart';

class ReviewEducationScreen extends StatefulWidget {
  const ReviewEducationScreen({super.key});

  @override
  State<ReviewEducationScreen> createState() => _ReviewEducationScreenState();
}

class _ReviewEducationScreenState extends State<ReviewEducationScreen> {
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
                    'Review Education',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  16.verticalSpace,
                  FreelanceMarketText(
                    "Review and modify your academic background, including schools attended and degrees earned.",
                    fontSize: 14,
                    maxLines: 3,
                    color: kTextSecondaryColor,
                  ),
                  30.verticalSpace,
                  Obx(() {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          onboardingProcessController.educationList.length,
                      itemBuilder: (context, index) {
                        final education =
                            onboardingProcessController.educationList[index];
                        return _educationCard(education);
                      },
                    );
                  }),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                          color: kPrimaryColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: kWhiteColor, size: 16.sp),
                            4.horizontalSpace,
                            FreelanceMarketText(
                              'Add more',
                              color: kWhiteColor,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  24.verticalSpace,
                ],
              ),
            ),
          ),

          FreelanceMarketButton(
            label: 'Next',
            onPressed: () {
              Get.toNamed(RouteName.workExperienceScreen);
            },
          ),
        ],
      ),
    );
  }

  /// Component
  _educationCard(Education education) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: kTextSecondaryColor, width: 1),
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.educationIcon, width: 48.w),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FreelanceMarketText(
                  education.institution,
                  fontSize: 14,
                  maxLines: 2,
                  fontWeight: FontWeight.bold,
                ),
                4.verticalSpace,
                FreelanceMarketText(
                  education.degree,
                  fontSize: 12,
                  maxLines: 2,
                  color: kTextSecondaryColor,
                  overflow: TextOverflow.ellipsis,
                ),
                2.verticalSpace,
                FreelanceMarketText(
                  '${education.startDate} - ${education.endDate}',
                  maxLines: 1,
                  fontSize: 12,
                  color: kTextSecondaryColor,
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Edit Details':
                  break;
                case 'Delete':
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'Edit Details',
                child: FreelanceMarketText('Edit Details', fontSize: 14.sp),
              ),
              PopupMenuItem<String>(
                value: 'Delete',
                child: FreelanceMarketText(
                  'Delete',
                  fontSize: 12,
                  color: kRedColor,
                ),
              ),
            ],
            child: Icon(
              Icons.more_vert,
              size: 20.sp,
              color: kTextSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
