import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/screens/view/dashboard_screen/see_all_contract_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller/profile_controller.dart';
import '../../custom/custom_text/custom_text.dart';

class ActiveContractsSection extends StatelessWidget {
  const ActiveContractsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Column(
      children: [
        // Header Row
        Row(
          children: [
            Expanded(
              child: EdwardbText(
                'Active Contracts',
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const SeeAllContractScreen());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: EdwardbText(
                  'View All',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        24.verticalSpace,

        // Contracts Table
        Column(
          children: [
            // Table Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
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
                      'Start Date',
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

            12.verticalSpace,

            // Use Obx to rebuild when contractsList updates
            Obx(() {
              if (controller.controllerIsBusy.value) {
                return const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                );
              }

              if (controller.contractsList.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(20.w),
                  child: EdwardbText(
                    'No contracts found',
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: controller.contractsList
                      .take(10) // show only 4 here
                      .map((contract) {
                    final fullName =
                    '${contract.firstName ?? ''} ${contract.lastName ?? ''}'
                        .trim();

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildContractRow(
                        name: fullName.isEmpty ? 'N/A' : fullName,
                        refId: contract.contractId,
                        startDate: contract.date ?? 'N/A',
                        status: contract.status ?? '',
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildContractRow({
    required String name,
    required String refId,
    required String startDate,
    required String status,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: EdwardbText(
              name,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color(0xFF111827),
            ),
          ),
          Expanded(
            flex: 2,
            child: EdwardbText(
              refId,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          Expanded(
            flex: 2,
            child: EdwardbText(
              startDate,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color(0xFF111827),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: status.toLowerCase() == 'active'
                    ? const Color(0xFF10B981) // Green for active
                    : const Color(0xFFDC2626), // Red otherwise
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: EdwardbText(
                  status.toUpperCase(),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
