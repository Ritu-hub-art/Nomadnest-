import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PrivacySafetyControlsWidget extends StatelessWidget {
  final Map<String, dynamic> safetySettings;
  final Function(String, dynamic) onSettingChanged;

  const PrivacySafetyControlsWidget({
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
                  iconName: 'privacy_tip',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Privacy & Safety',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Profile visibility and safety controls',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          _buildPrivacyOption(
            context,
            'Profile Visibility',
            safetySettings['profileVisibility'] ?? 'trusted_only',
            () => _showVisibilityPicker(context),
          ),
          _buildPrivacyOption(
            context,
            'Meeting Location Preference',
            safetySettings['meetingLocationPreference'] ?? 'public_places',
            () => _showLocationPreferencePicker(context),
          ),
          _buildSwitchOption(
            context,
            'Safety Rating Display',
            'Show safety rating on profile',
            'safetyRatingVisible',
            safetySettings['safetyRatingVisible'] ?? true,
          ),
          _buildSwitchOption(
            context,
            'Safety Buddy Assignment',
            'Enable safety buddy for trips',
            'safetyBuddyEnabled',
            safetySettings['safetyBuddyEnabled'] ?? true,
          ),
          _buildSwitchOption(
            context,
            'Automated Safety Tips',
            'Receive tips based on destination',
            'automatedSafetyTips',
            safetySettings['automatedSafetyTips'] ?? true,
          ),
          _buildSwitchOption(
            context,
            'Local Emergency Services',
            'Integration with local emergency services',
            'localEmergencyServices',
            safetySettings['localEmergencyServices'] ?? true,
          ),
          _buildSwitchOption(
            context,
            'Biometric Authentication',
            'Require biometrics for sensitive changes',
            'biometricAuth',
            safetySettings['biometricAuth'] ?? true,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption(
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
        value.replaceAll('_', ' ').toUpperCase(),
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

  void _showVisibilityPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Profile Visibility',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'public',
            'friends_only',
            'trusted_only',
            'private',
          ]
              .map((visibility) => ListTile(
                    title: Text(visibility.replaceAll('_', ' ').toUpperCase()),
                    leading: Radio<String>(
                      value: visibility,
                      groupValue: safetySettings['profileVisibility'],
                      onChanged: (value) {
                        onSettingChanged('profileVisibility', value);
                        Navigator.pop(context);
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showLocationPreferencePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Meeting Location Preference',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'public_places',
            'verified_venues',
            'group_settings',
            'no_preference',
          ]
              .map((preference) => ListTile(
                    title: Text(preference.replaceAll('_', ' ').toUpperCase()),
                    leading: Radio<String>(
                      value: preference,
                      groupValue: safetySettings['meetingLocationPreference'],
                      onChanged: (value) {
                        onSettingChanged('meetingLocationPreference', value);
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
