import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class NotificationSettingsWidget extends StatelessWidget {
  final Map<String, dynamic> userSettings;
  final Function(String, dynamic) onSettingChanged;

  const NotificationSettingsWidget({
    super.key,
    required this.userSettings,
    required this.onSettingChanged,
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
          // Section header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Notifications',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            thickness: 1,
            height: 1,
          ),

          // Push notifications
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'notifications_active',
              size: 24,
            ),
            title: Text(
              'Push Notifications',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Get notifications on your device',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: userSettings['pushNotifications'],
              onChanged: (value) {
                onSettingChanged('pushNotifications', value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            minTileHeight: 6.h,
          ),

          // Email notifications
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'mail_outline',
              size: 24,
            ),
            title: Text(
              'Email Notifications',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Receive updates via email',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: userSettings['emailNotifications'],
              onChanged: (value) {
                onSettingChanged('emailNotifications', value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            minTileHeight: 6.h,
          ),

          // SMS notifications
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'sms',
              size: 24,
            ),
            title: Text(
              'SMS Notifications',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Get text messages for important updates',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: userSettings['smsNotifications'],
              onChanged: (value) {
                onSettingChanged('smsNotifications', value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            minTileHeight: 6.h,
          ),

          // Section divider
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Text(
              'Notification Types',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // Message notifications
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'message',
              size: 24,
            ),
            title: Text(
              'Messages',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'New messages and replies',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: userSettings['messageNotifications'],
              onChanged: (value) {
                onSettingChanged('messageNotifications', value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            minTileHeight: 6.h,
          ),

          // Hangout notifications
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'event',
              size: 24,
            ),
            title: Text(
              'Hangouts & Events',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'New hangouts and event updates',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: userSettings['hangoutNotifications'],
              onChanged: (value) {
                onSettingChanged('hangoutNotifications', value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            minTileHeight: 6.h,
          ),

          // Safety notifications
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'security',
              size: 24,
            ),
            title: Text(
              'Safety & Security',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Security alerts and safety reminders',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: userSettings['safetyNotifications'],
              onChanged: (value) {
                onSettingChanged('safetyNotifications', value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            minTileHeight: 6.h,
          ),

          // Do Not Disturb
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'do_not_disturb',
              size: 24,
            ),
            title: Text(
              'Do Not Disturb',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Set quiet hours for notifications',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showDoNotDisturbDialog(context),
            minTileHeight: 6.h,
          ),
        ],
      ),
    );
  }

  void _showDoNotDisturbDialog(BuildContext context) {
    TimeOfDay startTime = const TimeOfDay(hour: 22, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 8, minute: 0);
    bool isEnabled = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Do Not Disturb',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(
                  'Enable Do Not Disturb',
                  style: GoogleFonts.inter(fontSize: 16.sp),
                ),
                value: isEnabled,
                onChanged: (value) => setState(() => isEnabled = value),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              if (isEnabled) ...[
                SizedBox(height: 2.h),
                ListTile(
                  title: Text(
                    'Start Time',
                    style: GoogleFonts.inter(fontSize: 16.sp),
                  ),
                  subtitle: Text(
                    startTime.format(context),
                    style: GoogleFonts.inter(fontSize: 14.sp),
                  ),
                  trailing: const CustomIconWidget(
                    iconName: 'access_time',
                    size: 20,
                  ),
                  onTap: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (time != null) {
                      setState(() => startTime = time);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    'End Time',
                    style: GoogleFonts.inter(fontSize: 16.sp),
                  ),
                  subtitle: Text(
                    endTime.format(context),
                    style: GoogleFonts.inter(fontSize: 14.sp),
                  ),
                  trailing: const CustomIconWidget(
                    iconName: 'access_time',
                    size: 20,
                  ),
                  onTap: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (time != null) {
                      setState(() => endTime = time);
                    }
                  },
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Save do not disturb settings
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
