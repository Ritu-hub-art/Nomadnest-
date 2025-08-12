import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LocationSharingWidget extends StatelessWidget {
  final bool locationSharingHosts;
  final bool locationSharingHangouts;
  final bool locationSharingEmergency;
  final Function(String, bool) onChanged;
  final VoidCallback onClearHistory;
  final VoidCallback onExportHistory;

  const LocationSharingWidget({
    super.key,
    required this.locationSharingHosts,
    required this.locationSharingHangouts,
    required this.locationSharingEmergency,
    required this.onChanged,
    required this.onClearHistory,
    required this.onExportHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Sharing',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Control when and with whom your location is shared',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 2.h),

            // Real-time sharing options
            _buildSwitchTile(
              context,
              'Share with Hosts',
              'Allow hosts to see your location during stays',
              locationSharingHosts,
              (value) => onChanged('hosts', value),
            ),

            _buildSwitchTile(
              context,
              'Share in Hangouts',
              'Show location to hangout participants',
              locationSharingHangouts,
              (value) => onChanged('hangouts', value),
            ),

            _buildSwitchTile(
              context,
              'Emergency Contacts',
              'Share location with emergency contacts for safety',
              locationSharingEmergency,
              (value) => onChanged('emergency', value),
            ),

            SizedBox(height: 2.h),
            Divider(color: AppTheme.borderLight),
            SizedBox(height: 2.h),

            // Location history management
            Text(
              'Location History Management',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onExportHistory,
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Export'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.5.h, horizontal: 3.w),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onClearHistory,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorLight,
                      padding: EdgeInsets.symmetric(
                          vertical: 1.5.h, horizontal: 3.w),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
