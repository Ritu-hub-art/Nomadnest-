import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LocationPermissionWidget extends StatelessWidget {
  final VoidCallback onRequestPermission;

  const LocationPermissionWidget({
    super.key,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.shade200,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.location_on,
              size: 64,
              color: Colors.blue.shade400,
            ),
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            'Location Access Required',
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Description
          Text(
            'NomadNest needs access to your location to:',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 3.h),

          // Benefits List
          _buildBenefitItem(
            icon: Icons.search_outlined,
            title: 'Find nearby venues',
            description:
                'Discover restaurants, cafes, and hangout spots around you',
          ),

          SizedBox(height: 2.h),

          _buildBenefitItem(
            icon: Icons.navigation_outlined,
            title: 'Get directions & ETA',
            description: 'Calculate routes and travel time to chosen venues',
          ),

          SizedBox(height: 2.h),

          _buildBenefitItem(
            icon: Icons.share_location_outlined,
            title: 'Share live location',
            description: 'Let friends know where you are during hangouts',
          ),

          SizedBox(height: 4.h),

          // Privacy Note
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  color: Colors.amber.shade700,
                  size: 20.sp,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Your location is only shared when you choose to enable live sharing',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.amber.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Action Buttons
          Column(
            children: [
              // Allow Location Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRequestPermission,
                  icon: Icon(Icons.location_on, size: 20.sp),
                  label: Text(
                    'Allow Location Access',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Continue Without Location Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Continue Without Location',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade600,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
