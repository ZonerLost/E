import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/screens/custom/custom_text/custom_text.dart';
import 'package:get/get.dart';

import '../../../../config/constant/colors.dart';
import '../../../../config/routes/routes_names.dart';
import '../../../../controllers/onboarding_process_controller/onboarding_process_controller.dart';
import '../../custom/custom_button/custom_button.dart';
import '../../custom/custom_text_from_field/custom_text_from_field.dart';

class PreferredServiceTypeScreen extends StatefulWidget {
  const PreferredServiceTypeScreen({super.key});

  @override
  State<PreferredServiceTypeScreen> createState() =>
      _PreferredServiceTypeScreenState();
}

class _PreferredServiceTypeScreenState
    extends State<PreferredServiceTypeScreen> {
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
                    'Preferred Service Type',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  16.verticalSpace,
                  FreelanceMarketText(
                    "Define your ideal service preferences to help us match you with the perfect client.",
                    fontSize: 14,
                    maxLines: 3,
                    color: kTextSecondaryColor,
                  ),
                  30.verticalSpace,

                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Service Title*',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,

                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Industry*',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,

                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Service Type*',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  12.verticalSpace,
                  Divider(),
                  12.verticalSpace,
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
                          hintText: 'State',
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
                    hintText: 'Service Nature*',
                    suffixIcon: Icons.arrow_drop_down,
                  ),

                  12.verticalSpace,
                  Divider(),
                  12.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Salary Expectations*',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,

                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Company Size',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  12.verticalSpace,
                  Divider(),
                  12.verticalSpace,
                  FreelanceMarketText(
                    'Other preferences',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  16.verticalSpace,

                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Category',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,

                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: 'Subcategory',
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                  16.verticalSpace,
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
              Get.toNamed(RouteName.availabilityScreen);
            },
          ),
        ],
      ),
    );
  }
}
