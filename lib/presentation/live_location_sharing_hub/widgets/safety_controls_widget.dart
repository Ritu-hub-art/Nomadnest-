import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class SafetyControlsWidget extends StatefulWidget {
  const SafetyControlsWidget({super.key});

  @override
  State<SafetyControlsWidget> createState() => _SafetyControlsWidgetState();
}

class _SafetyControlsWidgetState extends State<SafetyControlsWidget> {
  bool _autoStopEnabled = true;
  int _autoStopDuration = 2; // hours
  bool _panicModeEnabled = true;
  bool _trustedContactsEnabled = false;

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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, size: 5.w, color: Colors.red),
              SizedBox(width: 3.w),
              Text(
                'Safety Controls',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          Text(
            'Safety features and automatic controls',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),

          SizedBox(height: 3.h),

          // Auto-stop after inactivity
          _buildSafetyOption(
            title: 'Auto-stop sharing',
            description:
                'Automatically stop after ${_autoStopDuration}h of inactivity',
            icon: Icons.timer_off,
            isEnabled: _autoStopEnabled,
            onToggle: (value) {
              setState(() {
                _autoStopEnabled = value;
              });
            },
            trailing: _autoStopEnabled
                ? DropdownButton<int>(
                    value: _autoStopDuration,
                    underline: Container(),
                    items: [1, 2, 4, 8].map((hours) {
                      return DropdownMenuItem(
                        value: hours,
                        child: Text(
                          '${hours}h',
                          style: GoogleFonts.inter(fontSize: 12.sp),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _autoStopDuration = value;
                        });
                      }
                    },
                  )
                : null,
          ),

          SizedBox(height: 2.h),

          // Panic mode integration
          _buildSafetyOption(
            title: 'Panic mode integration',
            description: 'Quick access to emergency features while sharing',
            icon: Icons.emergency,
            isEnabled: _panicModeEnabled,
            onToggle: (value) {
              setState(() {
                _panicModeEnabled = value;
              });
            },
          ),

          SizedBox(height: 2.h),

          // Trusted contacts
          _buildSafetyOption(
            title: 'Notify trusted contacts',
            description:
                'Send location sharing notifications to emergency contacts',
            icon: Icons.contact_phone,
            isEnabled: _trustedContactsEnabled,
            onToggle: (value) {
              setState(() {
                _trustedContactsEnabled = value;
              });
            },
            trailing: _trustedContactsEnabled
                ? TextButton(
                    onPressed: () {
                      // Navigate to manage trusted contacts
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Manage trusted contacts feature coming soon',
                            style: GoogleFonts.inter(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Manage',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : null,
          ),

          SizedBox(height: 3.h),

          // Emergency action
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.warning, color: Colors.red, size: 6.w),
                SizedBox(height: 1.h),
                Text(
                  'Emergency Stop',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade800,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Immediately stop all location sharing and clear history',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: Colors.red.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showEmergencyStopDialog(context),
                    icon: const Icon(Icons.stop, color: Colors.white),
                    label: Text(
                      'Emergency Stop',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyOption({
    required String title,
    required String description,
    required IconData icon,
    required bool isEnabled,
    required Function(bool) onToggle,
    Widget? trailing,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnabled ? Colors.blue.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 5.w,
            color: isEnabled ? Colors.blue : Colors.grey.shade500,
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
                    color:
                        isEnabled ? Colors.blue.shade800 : Colors.grey.shade700,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color:
                        isEnabled ? Colors.blue.shade600 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null && isEnabled)
            trailing
          else
            Switch(
              value: isEnabled,
              onChanged: onToggle,
              activeColor: Colors.blue,
            ),
        ],
      ),
    );
  }

  void _showEmergencyStopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 6.w),
            SizedBox(width: 2.w),
            Text(
              'Emergency Stop',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          'This will immediately:\n\n'
          '• Stop all location sharing\n'
          '• Clear location history\n'
          '• Remove you from all hangouts\n\n'
          'This action cannot be undone.',
          style: GoogleFonts.inter(fontSize: 12.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle emergency stop
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Emergency stop activated',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Emergency Stop',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
