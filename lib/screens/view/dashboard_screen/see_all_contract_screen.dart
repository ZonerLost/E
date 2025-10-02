import 'package:edwardb/config/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/profile_controller/profile_controller.dart';
import '../../../model/contract_model.dart';
import '../../custom/custom_text/custom_text.dart';

class SeeAllContractScreen extends StatefulWidget {
  const SeeAllContractScreen({super.key});

  @override
  State<SeeAllContractScreen> createState() => _SeeAllContractScreenState();
}

class _SeeAllContractScreenState extends State<SeeAllContractScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // STEP 2: The filter function now accepts a List of your Contract model
  List<ContractModel> _filterContracts(List<ContractModel> contracts) {
    if (_searchQuery.isEmpty) {
      return contracts;
    }

    return contracts.where((contract) {
      final contractId = contract.contractId.toLowerCase();
      final fullName =
      '${contract.firstName ?? ''} ${contract.lastName ?? ''}'
          .trim()
          .toLowerCase();

      // Check if search query matches name or contract ID
      return fullName.contains(_searchQuery) ||
          contractId.contains(_searchQuery);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // STEP 3: Get the instance of your ProfileController here
    final controller = Get.find<ProfileController>();

    return Scaffold(appBar: _appBar(), body: _body(controller));
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        child: Icon(Icons.arrow_circle_left_outlined, size: 30.sp),
        onTap: () => Get.back(),
      ),
      title: EdwardbText(
        'Active Contracts',
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
    );
  }

  // Pass the controller to the body method
  _body(ProfileController controller) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar (no changes needed here)
              _buildSearchBar(),

              20.verticalSpace,

              // Table Header (no changes needed here)
              _buildTableHeader(),

              12.verticalSpace,

              // STEP 4: Replace StreamBuilder with Obx to listen to the controller
              Expanded(
                child: Obx(() {
                  // Handle Loading State from controller
                  if (controller.controllerIsBusy.value) {
                    return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
                  }

                  // Filter the list from the controller using your search query
                  final filteredList = _filterContracts(controller.contractsList);

                  // Handle Empty State (after filtering)
                  if (filteredList.isEmpty) {
                    return Center(
                      child: EdwardbText(
                        _searchQuery.isEmpty
                            ? 'No contracts found'
                            : 'No contracts match your search',
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                      ),
                    );
                  }

                  // Use ListView.builder with the filtered list from the controller
                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final contract = filteredList[index];
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
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Extracted the static header into its own method for clarity
  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: EdwardbText('Name', fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Expanded(
            flex: 2,
            child: EdwardbText('Ref ID', fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Expanded(
            flex: 2,
            child: EdwardbText('Start Date', fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Expanded(
            flex: 1,
            child: EdwardbText('Status', fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    // This widget remains unchanged. It correctly updates the local _searchQuery
    // using setState, which triggers a rebuild and re-filtering inside the Obx.
    return TextFormField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase().trim();
        });
      },
      style: GoogleFonts.inter(color: kTextPrimaryColor, fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: 'Search by name or ref ID...',
        prefixIcon: Icon(Icons.search, color: kTextSecondaryColor, size: 24.w),
        suffixIcon: _searchQuery.isNotEmpty
            ? GestureDetector(
          onTap: () {
            _searchController.clear();
            setState(() {
              _searchQuery = '';
            });
          },
          child: Icon(Icons.clear, color: kTextSecondaryColor),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kTextSecondaryColor),
        ),
        // ... other decoration properties ...
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildContractRow({
    required String name,
    required String refId,
    required String startDate,
    required String status,
  }) {
    // This widget remains unchanged.
    return Container(
      // ... same as your original code ...
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
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: status.toLowerCase() == 'active'
                    ? const Color(0xFF10B981) // Green for active
                    : const Color(0xFFDC2626), // Red for other statuses
                borderRadius: BorderRadius.circular(16.r),
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