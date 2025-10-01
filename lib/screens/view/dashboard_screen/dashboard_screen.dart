import 'dart:math';

import 'package:edwardb/config/assets/assets.dart';
import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/controllers/profile_controller/profile_controller.dart';
import 'package:edwardb/screens/view/vehicle_inspection_screens/vehicle_inspection_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../custom/custom_text/custom_text.dart';
import '../new_rental_contract_screens/new_rental_contract_welcome_screen.dart';
import 'active_contracts_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final profile = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  _appBar() {
    return AppBar(
      title: Obx(() {
        return EdwardbText(
          'Hello ${profile.profile.value.username} 👋',
          fontWeight: FontWeight.bold,
          fontSize: 28,
        );
      }),
      actions: [
        Obx(() {
          return CircleAvatar(
            backgroundColor: kWhiteColor,
            backgroundImage: NetworkImage(profile.profile.value.avatarUrl),
            radius: 24.r,
          );
        }),
        20.horizontalSpace,
      ],
    );
  }

  _body() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EdwardbText(
                  'Overview Stats',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                16.verticalSpace,
                overviewStatsCards(),
                50.verticalSpace,
                EdwardbText(
                  'Quick Actions',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                16.verticalSpace,
                quickAction(),

                50.verticalSpace,
                ActiveContractsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// Component to display overview stats cards
  ///
  overviewStatsCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EdwardbText(
                  'Contracts This Month',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: const Color(0xFF374151),
                ),
                EdwardbText(
                  '${Random().nextInt(10) + 1}',
                  fontWeight: FontWeight.w500,
                  fontSize: 38,
                  color: const Color(0xFF111827),
                ),
              ],
            ),
          ),
        ),

        23.horizontalSpace,

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EdwardbText(
                  'Contracts This Month',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: const Color(0xFFD1D5DB),
                ),
                EdwardbText(
                  '${Random().nextInt(10) + 1}',
                  fontWeight: FontWeight.w500,
                  fontSize: 38,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),

        23.horizontalSpace,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EdwardbText(
                  'Contracts This Month',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.white,
                ),
                EdwardbText(
                  '${Random().nextInt(10) + 1}',
                  fontWeight: FontWeight.w500,
                  fontSize: 38,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///
  /// Component to display quick action buttons
  ///
  quickAction() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => const NewRentalContractWelcomeScreen());
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFF5F5F5)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 50.h),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.rentalContractImage,
                      width: 70.w,
                      height: 70.h,
                    ),
                    40.verticalSpace,
                    EdwardbText(
                      'Start New Rental Contract',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => const VehicleInspectionWelcomeScreen());
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFF5F5F5)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 50.h),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.vehicleInspection,
                      width: 70.w,
                      height: 70.h,
                    ),
                    40.verticalSpace,
                    EdwardbText(
                      'Vehicle Inspection',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
