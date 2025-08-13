import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class PermissionStatusWidget extends StatelessWidget {
  final bool hasLocationPermission;
  final VoidCallback onRequestPermission;

  const PermissionStatusWidget({
    super.key,
    required this.hasLocationPermission,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: hasLocationPermission
            ? Colors.green.shade50
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasLocationPermission
              ? Colors.green.shade200
              : Colors.orange.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasLocationPermission ? Icons.check_circle : Icons.warning,
                size: 5.w,
                color: hasLocationPermission ? Colors.green : Colors.orange,
              ),
              SizedBox(width: 3.w),
              Text(
                'Permission Status',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: hasLocationPermission
                      ? Colors.green.shade800
                      : Colors.orange.shade800,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          if (hasLocationPermission)
            _buildPermissionItem(
                'Location', true, 'Precise location access granted')
          else
            Column(
              children: [
                _buildPermissionItem(
                    'Location', false, 'Location permission required'),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRequestPermission,
                    icon: const Icon(Icons.location_on, color: Colors.white),
                    label: Text(
                      'Grant Location Permission',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          SizedBox(height: 2.h),

          // Additional permission info
          _buildPermissionItem(
            'Background Refresh',
            true,
            'Allows location updates when app is minimized',
          ),

          SizedBox(height: 1.h),

          _buildPermissionItem(
            'Notifications',
            true,
            'Location sharing status notifications',
          ),

          if (hasLocationPermission) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 4.w),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'All permissions are correctly configured. You can start sharing your location.',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPermissionItem(String title, bool granted, String description) {
    return Row(
      children: [
        Icon(
          granted ? Icons.check_circle : Icons.cancel,
          size: 4.w,
          color: granted ? Colors.green : Colors.red,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        if (!granted)
          TextButton(
            onPressed: onRequestPermission,
            child: Text(
              'Enable',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ),
      ],
    );
  }
}
