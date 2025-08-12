import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DataManagementWidget extends StatelessWidget {
  final Map<String, dynamic> accountData;
  final Function(String) onDataActionRequested;

  const DataManagementWidget({
    super.key,
    required this.accountData,
    required this.onDataActionRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'storage',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Data Management',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          _buildDataAction(
            context,
            'Download Personal Data',
            'Export all your personal data and activity',
            'download',
            accountData['dataExportRequested'] == true
                ? 'Requested'
                : 'Download',
            () => onDataActionRequested('export'),
          ),
          _buildDataAction(
            context,
            'Data Retention Preferences',
            'Control how long we keep your data',
            'settings',
            'Configure',
            () => _showDataRetentionDialog(context),
          ),
          _buildDataAction(
            context,
            'Account Deletion',
            'Permanently delete your account and data',
            'delete_forever',
            accountData['accountDeletionRequested'] == true
                ? 'Requested'
                : 'Delete',
            () => onDataActionRequested('delete'),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDataAction(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    String actionText,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onSurfaceVariant,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            actionText,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: isDestructive
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 2.w),
          CustomIconWidget(
            iconName: 'chevron_right',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showDataRetentionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Data Retention Preferences',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose how long we keep your data:',
              style: GoogleFonts.inter(fontSize: 16.sp),
            ),
            SizedBox(height: 2.h),
            _buildRetentionOption(context, 'Messages', '1 year'),
            _buildRetentionOption(context, 'Activity Logs', '6 months'),
            _buildRetentionOption(context, 'Location Data', '3 months'),
            _buildRetentionOption(context, 'Search History', '1 month'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save Preferences'),
          ),
        ],
      ),
    );
  }

  Widget _buildRetentionOption(
      BuildContext context, String type, String duration) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: GoogleFonts.inter(fontSize: 14.sp),
          ),
          Text(
            duration,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
