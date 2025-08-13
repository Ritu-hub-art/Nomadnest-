import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationSharingWidget extends StatelessWidget {
  final Map<String, dynamic> safetySettings;
  final Function(String, dynamic) onSettingChanged;

  const LocationSharingWidget({
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
                  iconName: 'location_on',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Sharing',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Share location with trusted contacts',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: safetySettings['locationSharingEnabled'] ?? false,
                  onChanged: (value) =>
                      onSettingChanged('locationSharingEnabled', value),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          if (safetySettings['locationSharingEnabled'] == true) ...[
            Divider(
              height: 1,
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
            _buildLocationOption(
              context,
              'Precision Level',
              safetySettings['locationPrecision'] ?? 'exact',
              () => _showPrecisionPicker(context),
            ),
            _buildLocationOption(
              context,
              'Duration Limits',
              safetySettings['durationLimits'] ?? 'No limit',
              () => _showDurationPicker(context),
            ),
            _buildSwitchOption(
              context,
              'Trusted Contacts Only',
              'Only share with verified contacts',
              'trustedContactsOnly',
              safetySettings['trustedContactsOnly'] ?? true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationOption(
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

  void _showPrecisionPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Location Precision',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'exact',
            'approximate',
            'city_level',
          ]
              .map((precision) => ListTile(
                    title: Text(precision.replaceAll('_', ' ').toUpperCase()),
                    leading: Radio<String>(
                      value: precision,
                      groupValue: safetySettings['locationPrecision'],
                      onChanged: (value) {
                        onSettingChanged('locationPrecision', value);
                        Navigator.pop(context);
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showDurationPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Duration Limits',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'No limit',
            '1 hour',
            '6 hours',
            '12 hours',
            '24 hours',
          ]
              .map((duration) => ListTile(
                    title: Text(duration),
                    leading: Radio<String>(
                      value: duration,
                      groupValue: safetySettings['durationLimits'],
                      onChanged: (value) {
                        onSettingChanged('durationLimits', value);
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
