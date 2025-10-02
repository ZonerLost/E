import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelance_market/config/constant/colors.dart';
import 'package:freelance_market/screens/custom/custom_button/custom_button.dart';
import 'package:freelance_market/screens/custom/custom_text/custom_text.dart';
import 'package:get/get.dart';

class TimePickerSheet extends StatefulWidget {
  static void showSheet({
    String? selectedTime,
    Function(String)? onTimeSelected,
  }) {
    Get.bottomSheet(
      TimePickerSheet(
        selectedTime: selectedTime,
        onTimeSelected: onTimeSelected,
      ),
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
    );
  }

  final String? selectedTime;
  final Function(String)? onTimeSelected;

  const TimePickerSheet({super.key, this.selectedTime, this.onTimeSelected});

  @override
  State<TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<TimePickerSheet> {
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController amPmController;

  int selectedHour = 9;
  int selectedMinute = 00;
  int selectedAmPm = 0; // 0 for AM, 1 for PM

  final List<int> hours = List.generate(12, (index) => index + 1);
  final List<int> minutes = List.generate(60, (index) => index);
  final List<String> amPm = ['AM', 'PM'];

  @override
  void initState() {
    super.initState();

    // Parse existing time if provided
    if (widget.selectedTime != null && widget.selectedTime!.isNotEmpty) {
      _parseTime(widget.selectedTime!);
    }

    hourController = FixedExtentScrollController(
      initialItem: hours.indexOf(selectedHour),
    );
    minuteController = FixedExtentScrollController(initialItem: selectedMinute);
    amPmController = FixedExtentScrollController(initialItem: selectedAmPm);
  }

  void _parseTime(String timeString) {
    try {
      // Parse time like "8:30 AM"
      final parts = timeString.split(' ');
      if (parts.length == 2) {
        final timePart = parts[0].split(':');
        if (timePart.length == 2) {
          selectedHour = int.parse(timePart[0]);
          selectedMinute = int.parse(timePart[1]);
          selectedAmPm = parts[1].toUpperCase() == 'PM' ? 1 : 0;
        }
      }
    } catch (e) {
      // Use default values if parsing fails
      selectedHour = 8;
      selectedMinute = 30;
      selectedAmPm = 0;
    }
  }

  String _formatTime() {
    return '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')} ${amPm[selectedAmPm]}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        width: double.infinity,
        height: 0.6.sh,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          children: [
            // Top handle/divider
            Container(
              width: 80.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: kTextSecondaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            20.verticalSpace,

            // Header with title and cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FreelanceMarketText(
                  'Select Time',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: FreelanceMarketText(
                    'Cancel',
                    fontSize: 12,
                    color: kTextSecondaryColor,
                  ),
                ),
              ],
            ),

            40.verticalSpace,

            // Time picker wheels
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.2.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hour picker
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: hourController,
                        itemExtent: 40.h,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHour = hours[index];
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (index < 0 || index >= hours.length) return null;
                            final hour = hours[index];
                            final isSelected = hour == selectedHour;

                            return Container(
                              alignment: Alignment.center,
                              child: FreelanceMarketText(
                                hour.toString(),
                                fontSize: isSelected ? 24 : 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? kBlackColor
                                    : kTextSecondaryColor,
                              ),
                            );
                          },
                          childCount: hours.length,
                        ),
                      ),
                    ),

                    // Minute picker
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: minuteController,
                        itemExtent: 40.h,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedMinute = minutes[index];
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (index < 0 || index >= minutes.length)
                              return null;
                            final minute = minutes[index];
                            final isSelected = minute == selectedMinute;

                            return Container(
                              alignment: Alignment.center,
                              child: FreelanceMarketText(
                                minute.toString().padLeft(2, '0'),
                                fontSize: isSelected ? 24 : 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? kBlackColor
                                    : kTextSecondaryColor,
                              ),
                            );
                          },
                          childCount: minutes.length,
                        ),
                      ),
                    ),

                    // AM/PM picker
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: amPmController,
                        itemExtent: 40.h,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedAmPm = index;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (index < 0 || index >= amPm.length) return null;
                            final period = amPm[index];
                            final isSelected = index == selectedAmPm;

                            return Container(
                              alignment: Alignment.center,
                              child: FreelanceMarketText(
                                period,
                                fontSize: isSelected ? 20 : 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? kBlackColor
                                    : kTextSecondaryColor,
                              ),
                            );
                          },
                          childCount: amPm.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            30.verticalSpace,

            // Save button
            FreelanceMarketButton(
              label: 'Save',
              onPressed: () {
                final timeString = _formatTime();
                if (widget.onTimeSelected != null) {
                  widget.onTimeSelected!(timeString);
                }
                Get.back();
              },
            ),

            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    amPmController.dispose();
    super.dispose();
  }
}
