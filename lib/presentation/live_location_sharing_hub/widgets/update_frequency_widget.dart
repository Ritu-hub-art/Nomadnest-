import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateFrequencyWidget extends StatelessWidget {
  final int selectedFrequency;
  final Function(int) onFrequencyChanged;

  const UpdateFrequencyWidget({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.update, size: 5.w, color: Colors.orange),
            SizedBox(width: 3.w),
            Text('Update Frequency',
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
          ]),

          SizedBox(height: 1.h),

          Text('How often to send location updates (affects battery)',
              style: GoogleFonts.inter(
                  fontSize: 12.sp, color: Colors.grey.shade600)),

          SizedBox(height: 3.h),

          _buildFrequencyOption(
              5,
              'High (5 seconds)',
              'Most accurate, higher battery usage',
              Icons.battery_2_bar,
              Colors.red,
              'High'),

          SizedBox(height: 2.h),

          _buildFrequencyOption(
              10,
              'Standard (10 seconds)',
              'Balanced accuracy and battery',
              Icons.battery_4_bar,
              Colors.orange,
              'Medium'),

          SizedBox(height: 2.h),

          _buildFrequencyOption(
              30,
              'Low (30 seconds)',
              'Basic tracking, saves battery',
              Icons.battery_6_bar,
              Colors.green,
              'Low'),

          SizedBox(height: 3.h),

          // Adaptive mode toggle
          Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200)),
              child: Row(children: [
                Icon(Icons.auto_awesome, color: Colors.blue, size: 5.w),
                SizedBox(width: 3.w),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Adaptive Updates',
                          style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade800)),
                      Text(
                          'Automatically adjusts based on movement and screen state',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp, color: Colors.blue.shade600)),
                    ])),
                Switch(
                    value: true,
                    onChanged: (value) {
                      // Handle adaptive mode toggle
                    },
                    activeColor: Colors.blue),
              ])),
        ]));
  }

  Widget _buildFrequencyOption(int value, String title, String description,
      IconData batteryIcon, Color color, String batteryLevel) {
    final isSelected = selectedFrequency == value;

    return InkWell(
        onTap: () => onFrequencyChanged(value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: isSelected ? color.withAlpha(26) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isSelected ? color : Colors.grey.shade300,
                    width: isSelected ? 2 : 1)),
            child: Row(children: [
              Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                      color: isSelected ? color : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(batteryIcon,
                      size: 5.w,
                      color: isSelected ? Colors.white : Colors.grey.shade600)),
              SizedBox(width: 3.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Text(title,
                          style: GoogleFonts.inter(
                              fontSize: 14.sp, fontWeight: FontWeight.w600)),
                      SizedBox(width: 2.w),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                              color: color.withAlpha(51),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(batteryLevel,
                              style: GoogleFonts.inter(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600))),
                    ]),
                    SizedBox(height: 0.5.h),
                    Text(description,
                        style: GoogleFonts.inter(
                            fontSize: 11.sp, color: Colors.grey.shade600)),
                  ])),
              if (isSelected)
                Icon(Icons.check_circle, color: color, size: 5.w)
              else
                Icon(Icons.radio_button_unchecked,
                    color: Colors.grey.shade400, size: 5.w),
            ])));
  }
}
