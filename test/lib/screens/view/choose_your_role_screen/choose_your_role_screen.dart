import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/constant/colors.dart';
import 'package:freelance_market/screens/custom/custom_button/custom_button.dart';
import 'package:freelance_market/screens/custom/custom_text/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/routes_names.dart';

class ChooseYourRoleScreen extends StatefulWidget {
  const ChooseYourRoleScreen({super.key});

  @override
  State<ChooseYourRoleScreen> createState() => _ChooseYourRoleScreenState();
}

class _ChooseYourRoleScreenState extends State<ChooseYourRoleScreen> {
  RxString selectedRole = 'offer'.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: _body()));
  }

  _body() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FreelanceMarketText(
            'Get started as..',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          16.verticalSpace,
          FreelanceMarketText(
            "Choose whether you’re seeking to looking for job opportunities or hire talent for your office.",
            fontSize: 14,
            maxLines: 3,
            color: kTextSecondaryColor,
          ),

          40.verticalSpace,

          Obx(() {
            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => selectedRole.value = 'offer',
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: selectedRole.value == 'offer'
                              ? kPrimaryColor
                              : kTextSecondaryColor,
                          width: selectedRole.value == 'offer' ? 2.w : 1.w,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Check mark for selected state
                          if (selectedRole.value == 'offer')
                            Positioned(
                              top: 12.h,
                              right: 12.w,
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2E5BFF),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                              ),
                            ),

                          // Content
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon
                                  Container(
                                    width: 48.w,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor.withAlpha(20),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.person_search,
                                      color: kPrimaryColor,
                                      size: 24.sp,
                                    ),
                                  ),

                                  16.verticalSpace,

                                  // Title
                                  FreelanceMarketText(
                                    'Offer a Service',
                                    fontSize: 14,

                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                16.horizontalSpace,

                Expanded(
                  child: GestureDetector(
                    onTap: () => selectedRole.value = 'find',
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: selectedRole.value == 'find'
                              ? kPrimaryColor
                              : kTextSecondaryColor,
                          width: selectedRole.value == 'find' ? 2.w : 1.w,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Check mark for selected state
                          if (selectedRole.value == 'find')
                            Positioned(
                              top: 12.h,
                              right: 12.w,
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2E5BFF),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                              ),
                            ),

                          // Content
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon
                                  Container(
                                    width: 48.w,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.work_outline,
                                      color: Colors.black,
                                      size: 24.sp,
                                    ),
                                  ),

                                  16.verticalSpace,

                                  // Title
                                  FreelanceMarketText(
                                    'Find a Service',
                                    fontSize: 14,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),

          const Spacer(),

          FreelanceMarketButton(
            label: 'Done',
            onPressed: () {
              Get.offAllNamed(RouteName.contactDetailsScreen);
            },
          ),
        ],
      ),
    );
  }
}
