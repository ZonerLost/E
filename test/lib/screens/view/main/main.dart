import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/assets/assets.dart';
import 'package:freelance_market/config/constant/colors.dart';
import 'package:get/get.dart';

class FreelanceSideMain extends StatefulWidget {
  const FreelanceSideMain({super.key});

  @override
  State<FreelanceSideMain> createState() => _FreelanceSideMainState();
}

class _FreelanceSideMainState extends State<FreelanceSideMain> {
  RxInt currentIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(bottomNavigationBar: _bottomNavigationBar()),
    );
  }

  _bottomNavigationBar() {
    return Obx(() {
      return Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex.value,
          onTap: (int index) => currentIndex.value = index,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(AppAssets.homeNavIcon),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppAssets.jobNavIcon),
              label: 'Job',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppAssets.inboxNavIcon),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppAssets.calenderNavIcon),
              label: 'Calender',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppAssets.profileNavIcon),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
