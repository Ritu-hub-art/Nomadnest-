import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationAccuracyWidget extends StatelessWidget {
  final String selectedAccuracy;
  final Function(String) onAccuracyChanged;

  const LocationAccuracyWidget({
    super.key,
    required this.selectedAccuracy,
    required this.onAccuracyChanged,
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
            Icon(Icons.my_location, size: 5.w, color: Colors.blue),
            SizedBox(width: 3.w),
            Text('Location Accuracy',
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
          ]),
          SizedBox(height: 1.h),
          Text('Choose how precise your location appears to others',
              style: GoogleFonts.inter(
                  fontSize: 12.sp, color: Colors.grey.shade600)),
          SizedBox(height: 3.h),
          _buildAccuracyOption(
              'exact',
              'Exact Location',
              'GPS precise location (~3-5m accuracy)',
              Icons.gps_fixed,
              Colors.red),
          SizedBox(height: 2.h),
          _buildAccuracyOption(
              'approximate',
              'Approximate Location',
              'General area (~300m radius)',
              Icons.location_searching,
              Colors.orange),
          SizedBox(height: 2.h),
          _buildAccuracyOption(
              'area_only',
              'Area Only',
              'Neighborhood level (~500m+ radius)',
              Icons.location_city,
              Colors.green),
        ]));
  }

  Widget _buildAccuracyOption(String value, String title, String description,
      IconData icon, Color color) {
    final isSelected = selectedAccuracy == value;

    return InkWell(
        onTap: () => onAccuracyChanged(value),
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
                  child: Icon(icon,
                      size: 5.w,
                      color: isSelected ? Colors.white : Colors.grey.shade600)),
              SizedBox(width: 3.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: GoogleFonts.inter(
                            fontSize: 14.sp, fontWeight: FontWeight.w600)),
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
