import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/controllers/inspection_controller/inspection_controller.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:edwardb/screens/view/vehicle_inspection_screens/vehicle_inspection_selected_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VehicleInspectionContractListingScreen extends StatelessWidget {
  const VehicleInspectionContractListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: GestureDetector(
        child: Icon(Icons.arrow_circle_left_outlined, size: 30.sp),
        onTap: () => Get.back(),
      ),
      title: EdwardbText(
        'Vehicle Inspection',
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      // actions: [
      //   GestureDetector(
      //     onTap: () {
      //       // Handle menu tap
      //     },
      //     child: Padding(
      //       padding: EdgeInsets.only(right: 20.w),
      //       child: Icon(Icons.menu, size: 30.sp),
      //     ),
      //   ),
      // ],
    );
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                Icon(Icons.person_3_rounded, size: 30.sp),
                10.horizontalSpace,
                EdwardbText(
                  'Select Customer Contract',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ],
            ),

            24.verticalSpace,

            // Contracts List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contracts')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: EdwardbText(
                        'Error: ${snapshot.error}',
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64.sp,
                            color: Colors.grey[400],
                          ),
                          16.verticalSpace,
                          EdwardbText(
                            'No contracts found',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    );
                  }

                  final contracts = snapshot.data!.docs;

                  return Column(
                    children: [
                      // Table Header
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: EdwardbText(
                                'Name',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: EdwardbText(
                                'Ref ID',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: EdwardbText(
                                'Date',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: EdwardbText(
                                'Status',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Contracts List
                      Expanded(
                        child: ListView.separated(
                          itemCount: contracts.length,
                          separatorBuilder: (context, index) =>
                              10.verticalSpace,
                          itemBuilder: (context, index) {
                            final contract = contracts[index];
                            final data =
                                contract.data() as Map<String, dynamic>;

                            return _buildContractRow(
                              contractId: contract.id,
                              firstName: data['firstName'] ?? '',
                              lastName: data['lastName'] ?? '',
                              phoneNumber: data['phoneNumber'] ?? '',
                              date: data['date'] ?? '',
                              status: data['status'] ?? 'unknown',
                              imageURL: data['driverPhotoUrl'] ?? '',
                              isLast: index == contracts.length - 1,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractRow({
    required String contractId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String date,
    required String status,
    required String imageURL,
    required bool isLast,
  }) {
    return GestureDetector(
      onTap: () {
        _onContractSelected(imageURL, contractId, firstName, lastName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: EdwardbText(
                '$firstName $lastName',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: const Color(0xFF111827),
              ),
            ),
            Expanded(
              flex: 2,
              child: EdwardbText(
                contractId.length > 8
                    ? '${contractId.substring(0, 8)}...'
                    : contractId,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),

            Expanded(
              flex: 2,
              child: EdwardbText(
                date,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: const Color(0xFF111827),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: EdwardbText(
                    status,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'completed':
        return const Color(0xFF3B82F6);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Future<void> _onContractSelected(
    String imageURL,
    String contractId,
    String firstName,
    String lastName,
  ) async {
    final inspectionController = Get.put(InspectionController());
    inspectionController.setDoneScreenData(
      imageURL,
      contractId,
      '$firstName $lastName',
    );
    await Future.delayed(const Duration(milliseconds: 300));
    Get.to(
      () => VehicleInspectionSelectedScreen(
        imageURL: imageURL,
        contractId: contractId,
        name: '$firstName $lastName',
        date: DateTime.now().toString(),
      ),
    );
  }
}

// Keep your existing CustomBullet and TrianglePainter classes
class CustomBullet extends StatelessWidget {
  const CustomBullet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(24.w, 44.h), painter: TrianglePainter());
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kPrimaryColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, size.height / 2);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
