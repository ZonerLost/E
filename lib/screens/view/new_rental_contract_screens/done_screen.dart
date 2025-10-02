import 'dart:io';

import 'package:edwardb/config/routes/routes_names.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DoneScreen extends StatefulWidget {
  final String contractId;
  final String name;
  final String? imageUrl;

  const DoneScreen({
    super.key,
    required this.contractId,
    required this.name,
    required this.imageUrl,
  });

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  _appBar() {
    return AppBar(
      title: EdwardbText(
        'Start New Rental Contract',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: Colors.black,
      ),
    );
  }

  _body() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Information Saved Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[700],
                    size: 20.sp,
                  ),
                ),
                16.horizontalSpace,
                EdwardbText(
                  'Customer Information Saved',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ],
            ),

            40.verticalSpace,

            // Customer Card
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: FileImage(File(widget.imageUrl!)),
                    backgroundColor: Colors.grey[300],
                  ),
                  20.horizontalSpace,
                  // Customer Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          EdwardbText('File Name : ', fontSize: 14),
                          EdwardbText(
                            widget.name,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          EdwardbText('Ref # ', fontSize: 14),
                          EdwardbText(
                            widget.contractId,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            50.verticalSpace,

            // Spacer to push content to center
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EdwardbText(
                    'Customer Information Saved Successfully',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    textAlign: TextAlign.center,
                  ),
                  20.verticalSpace,
                  EdwardbText(
                    'Customer information has been successfully added to google drive from where it can be accessed for viewing or editing',
                    fontSize: 14,

                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            50.verticalSpace,
            // Done Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: EdwardbButton(
                onPressed: () {
                  Get.offAndToNamed(RouteName.dashboardScreen);
                },
                label: 'Done',
              ),
            ),

            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
