import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AutomaticCheckinWidget extends StatelessWidget {
  final Map<String, dynamic> safetySettings;
  final Function(String, dynamic) onSettingChanged;

  const AutomaticCheckinWidget({
    super.key,
    required this.safetySettings,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Automatic Check-ins',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Scheduled safety check-ins',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: safetySettings['autoCheckinEnabled'] ?? false,
                  onChanged: (value) =>
                      onSettingChanged('autoCheckinEnabled', value),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          if (safetySettings['autoCheckinEnabled'] == true) ...[
            Divider(
              height: 1,
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
            _buildCheckinOption(
              context,
              'Check-in Interval',
              safetySettings['checkinInterval'] ?? '2 hours',
              () => _showIntervalPicker(context),
            ),
            _buildSwitchOption(
              context,
              'Location Triggers',
              'Alert when leaving safe areas',
              'locationTriggers',
              safetySettings['locationTriggers'] ?? false,
            ),
            _buildSwitchOption(
              context,
              'Missed Check-in Alerts',
              'Notify contacts if check-in is missed',
              'missedCheckinAlerts',
              safetySettings['missedCheckinAlerts'] ?? true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckinOption(
      BuildContext context, String title, String value, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const CustomIconWidget(
        iconName: 'chevron_right',
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchOption(BuildContext context, String title, String subtitle,
      String key, bool value) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: (newValue) => onSettingChanged(key, newValue),
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showIntervalPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Check-in Interval',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            '30 minutes',
            '1 hour',
            '2 hours',
            '4 hours',
            '6 hours',
          ]
              .map((interval) => ListTile(
                    title: Text(interval),
                    leading: Radio<String>(
                      value: interval,
                      groupValue: safetySettings['checkinInterval'],
                      onChanged: (value) {
                        onSettingChanged('checkinInterval', value);
                        Navigator.pop(context);
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
