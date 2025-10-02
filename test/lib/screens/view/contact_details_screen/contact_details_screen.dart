import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/constant/colors.dart';
import 'package:freelance_market/screens/custom/custom_button/custom_button.dart';
import 'package:freelance_market/screens/custom/custom_text/custom_text.dart';
import 'package:freelance_market/screens/custom/custom_text_from_field/custom_text_from_field.dart';
import 'package:get/get.dart';

import '../../../../config/routes/routes_names.dart';

class ContactDetailsScreen extends StatefulWidget {
  const ContactDetailsScreen({super.key});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
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
                    'Contact Details',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  16.verticalSpace,
                  FreelanceMarketText(
                    "Please provide your contact details so we can reach out to you.",
                    fontSize: 14,
                    maxLines: 3,
                    color: kTextSecondaryColor,
                  ),
                  24.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: "Bio*",
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: FreelanceMarketTextField(
                          controller: TextEditingController(),
                          hintText: "Country",
                          suffixIcon: Icons.arrow_drop_down,
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: FreelanceMarketTextField(
                          controller: TextEditingController(),
                          hintText: "State",
                          suffixIcon: Icons.arrow_drop_down,
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: FreelanceMarketTextField(
                          controller: TextEditingController(),
                          hintText: "City",
                          suffixIcon: Icons.arrow_drop_down,
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: FreelanceMarketTextField(
                          controller: TextEditingController(),
                          hintText: "Zip Code",
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: "6391 Elgin St. Celina, Delaware",
                  ),
                  16.verticalSpace,
                  FreelanceMarketTextField(
                    controller: TextEditingController(),
                    hintText: "Phone Number",
                  ),
                  24.verticalSpace, // Add some space before button
                ],
              ),
            ),
          ),
          FreelanceMarketButton(
            label: 'Next',
            onPressed: () {
              Get.toNamed(RouteName.educationalBackgroundScreen);
            },
          ),
        ],
      ),
    );
  }
}
