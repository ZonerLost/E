import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:edwardb/screens/view/dashboard_screen/active_contracts_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ActiveContracts extends StatefulWidget {
  const ActiveContracts({super.key});

  @override
  State<ActiveContracts> createState() => _ActiveContractsState();
}

class _ActiveContractsState extends State<ActiveContracts> {
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
        'Active Contracts ',
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Handle add contract tap
          },
          child: Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Icon(Icons.menu, size: 30.sp),
          ),
        ),
      ],
    );
  }

  _body() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ActiveContractsSection()],
          ),
        ),
      ),
    );
  }
}
