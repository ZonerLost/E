import 'package:edwardb/config/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/profile_controller/profile_controller.dart';
import '../../../model/contract_model.dart'; // Ensure this path is correct
import '../../custom/custom_text/custom_text.dart';

class SeeAllContractScreen extends StatefulWidget {
  const SeeAllContractScreen({super.key});

  @override
  State<SeeAllContractScreen> createState() => _SeeAllContractScreenState();
}

class _SeeAllContractScreenState extends State<SeeAllContractScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // STEP 1: Add state for the sort/filter dropdown
  String _selectedSortOption = 'Date (Latest)';
  final List<String> _sortOptions = const [
    'Date (Latest)',
    'Date (Oldest)',
    'Status Active',
    'Status Pending',
    'Status Due',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper function to safely parse date strings for sorting
  DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      // Return a very old date for null/empty dates to place them at the end
      return DateTime(1900);
    }
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      // Handle parsing errors if the format is unexpected
      print('Error parsing date: $e');
      return DateTime(1900);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // STEP 2: Place Search Bar and Dropdown in a Row
              Row(
                children: [
                  Expanded(child: _buildSearchBar()),
                  16.horizontalSpace,
                  _buildSortDropdown(),
                ],
              ),

              20.verticalSpace,

              _buildTableHeader(),
              12.verticalSpace,

              Expanded(
                child: Obx(() {
                  if (controller.controllerIsBusy.value) {
                    return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
                  }

                  // STEP 3: Chain the filtering and sorting logic
                  // Start with the full list
                  List<ContractModel> processedList = List.from(controller.contractsList);

                  // 3a. Apply search text filter
                  if (_searchQuery.isNotEmpty) {
                    processedList = processedList.where((contract) {
                      final contractId = contract.contractId.toLowerCase();
                      final fullName = '${contract.firstName ?? ''} ${contract.lastName ?? ''}'.trim().toLowerCase();
                      return fullName.contains(_searchQuery) || contractId.contains(_searchQuery);
                    }).toList();
                  }

                  // 3b. Apply dropdown sort/filter
                  switch (_selectedSortOption) {
                    case 'Date (Latest)':
                      processedList.sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));
                      break;
                    case 'Date (Oldest)':
                      processedList.sort((a, b) => _parseDate(a.date).compareTo(_parseDate(b.date)));
                      break;
                    case 'Status Active':
                      processedList = processedList.where((c) => c.status?.toLowerCase() == 'active').toList();
                      break;
                    case 'Status Pending':
                      processedList = processedList.where((c) => c.status?.toLowerCase() == 'pending').toList();
                      break;
                    case 'Status Due':
                      processedList = processedList.where((c) => c.status?.toLowerCase() == 'due').toList();
                      break;
                  }

                  if (processedList.isEmpty) {
                    return Center(
                      child: EdwardbText(
                        _searchQuery.isEmpty && _selectedSortOption == 'Date (Latest)'
                            ? 'No contracts found'
                            : 'No contracts match your criteria',
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: processedList.length,
                    itemBuilder: (context, index) {
                      final contract = processedList[index];
                      final fullName = '${contract.firstName ?? ''} ${contract.lastName ?? ''}'.trim();
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildContractRow(
                          name: fullName.isEmpty ? 'N/A' : fullName,
                          refId: contract.contractId,
                          // You might want to format the date for display here
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

  Widget _buildTableHeader() {
    // ... (This method is unchanged)
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(flex: 2, child: EdwardbText('Name', fontWeight: FontWeight.w600, fontSize: 14)),
          Expanded(flex: 2, child: EdwardbText('Ref ID', fontWeight: FontWeight.w600, fontSize: 14)),
          Expanded(flex: 2, child: EdwardbText('Start Date', fontWeight: FontWeight.w600, fontSize: 14)),
          Expanded(flex: 1, child: EdwardbText('Status', fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  // STEP 4: Create the Sort By Dropdown Widget
  Widget _buildSortDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      height: 58.h, // Match search bar height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: kTextSecondaryColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSortOption,
          icon: const Icon(Icons.keyboard_arrow_down, color: kTextSecondaryColor),
          onChanged: (String? newValue) {
            setState(() {
              _selectedSortOption = newValue!;
            });
          },
          items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: EdwardbText(
                value,
                fontSize: 16,
                color: kTextPrimaryColor,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  Widget _buildSearchBar() {
    // ... (This method is unchanged)
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kTextSecondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      ),
    );
  }

  Widget _buildContractRow({
    required String name,
    required String refId,
    required String startDate,
    required String status,
  }) {
    // ... (This method is unchanged)
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
            child: EdwardbText(name, fontWeight: FontWeight.w500, fontSize: 14, color: const Color(0xFF111827)),
          ),
          Expanded(
            flex: 2,
            child: EdwardbText(refId, fontWeight: FontWeight.w500, fontSize: 14, color: const Color(0xFF6B7280)),
          ),
          Expanded(
            flex: 2,
            child: EdwardbText(startDate, fontWeight: FontWeight.w500, fontSize: 14, color: const Color(0xFF111827)),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: status.toLowerCase() == 'active'
                    ? const Color(0xFF10B981) // Green for active
                    : status.toLowerCase() == 'due'
                    ? const Color(0xFFDC2626) // Red for due
                    : Colors.orange, // Orange for pending or other
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: EdwardbText(status.toUpperCase(), fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}