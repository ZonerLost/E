import 'package:edwardb/config/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../custom/custom_text/custom_text.dart';

class SeeAllContractScreen extends StatefulWidget {
  const SeeAllContractScreen({super.key});

  @override
  State<SeeAllContractScreen> createState() => _SeeAllContractScreenState();
}

class _SeeAllContractScreenState extends State<SeeAllContractScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
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
            children: [
              // Search Bar
              _buildSearchBar(),

              20.verticalSpace,

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

              // StreamBuilder for all contracts
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
                          'Error loading contracts',
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: EdwardbText(
                          'No contracts found',
                          fontSize: 14,
                          color: const Color(0xFF6B7280),
                        ),
                      );
                    }

                    // Filter documents based on search query
                    final filteredDocs = _filterContracts(snapshot.data!.docs);

                    if (filteredDocs.isEmpty) {
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

                    return ListView.builder(
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        final doc = filteredDocs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final contractId = doc.id;

                        // Extract data from document
                        final firstName = data['firstName'] ?? '';
                        final lastName = data['lastName'] ?? '';
                        final fullName = '$firstName $lastName'.trim();
                        final date = data['date'] ?? '';
                        final status = data['status'] ?? '';

                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildContractRow(
                            name: fullName.isEmpty ? 'N/A' : fullName,
                            refId: contractId,
                            startDate: date.isEmpty ? 'N/A' : date,
                            status: status,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextFormField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase().trim();
        });
      },
      keyboardType: TextInputType.text,
      style: GoogleFonts.inter(color: kTextPrimaryColor, fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: 'Search by name or ref ID...',
        labelText: 'Search by name or ref ID...',
        hintStyle: GoogleFonts.inter(
          color: kTextSecondaryColor,
          fontSize: 20.sp,
        ),
        labelStyle: GoogleFonts.inter(
          color: kTextSecondaryColor,
          fontSize: 20.sp,
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kRedColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: kRedColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      ),
    );
  }

  List<QueryDocumentSnapshot> _filterContracts(
    List<QueryDocumentSnapshot> docs,
  ) {
    if (_searchQuery.isEmpty) {
      return docs;
    }

    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final contractId = doc.id.toLowerCase();

      // Get name
      final firstName = data['firstName'] ?? '';
      final lastName = data['lastName'] ?? '';
      final fullName = '$firstName $lastName'.trim().toLowerCase();

      // Check if search query matches name or contract ID
      return fullName.contains(_searchQuery) ||
          contractId.contains(_searchQuery);
    }).toList();
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
