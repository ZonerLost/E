import 'dart:io';
import 'dart:typed_data';

import 'package:edwardb/config/routes/routes_names.dart';
import 'package:edwardb/config/utils/utils.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:edwardb/services/pdf_archive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DoneScreen extends StatefulWidget {
  final String contractId;
  final String name;
  final String? imageUrl;
  final Map<String, dynamic> contractData;
  final Map<String, String> localImagePaths;
  final Map<String, Uint8List> signatureBytes;
  final Map<String, bool> agreementStatuses;

  const DoneScreen({
    super.key,
    required this.contractId,
    required this.name,
    required this.imageUrl,
    required this.contractData,
    required this.localImagePaths,
    required this.signatureBytes,
    required this.agreementStatuses,
  });

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  bool _isSavingPdf = false;

  Future<void> _savePdf() async {
    if (_isSavingPdf) return;
    setState(() => _isSavingPdf = true);
    try {
      final pdfFile = await PdfArchiveService.instance.saveContractPdf(
        topFolderName: 'xplore contracts',
        username: widget.name,
        contractId: widget.contractId,
        contractData: widget.contractData,
        imageFilePaths: widget.localImagePaths,
        imageBytes: widget.signatureBytes,
        agreementStatuses: widget.agreementStatuses,
      );
      Utils.showSuccessSnackbar(
        'Saved',
        'PDF stored locally at ${pdfFile.path}',
      );
    } catch (error) {
      Utils.showErrorSnackbar('Error', 'Failed to save PDF: $error');
    } finally {
      if (!mounted) return;
      setState(() => _isSavingPdf = false);
    }
  }

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
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: EdwardbButton(
                onPressed: _savePdf,
                label: _isSavingPdf ? 'Saving PDF...' : 'Save as PDF',
              ),
            ),
            16.verticalSpace,
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
