import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SafetyCompanionWidget extends StatelessWidget {
  final Map<String, dynamic> safetySettings;
  final Function(String, dynamic) onSettingChanged;

  const SafetyCompanionWidget({
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
                  iconName: 'shield',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Safety Companion',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Persistent safety button configuration',
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
          _buildSwitchOption(
            context,
            'Safety Button',
            'Show persistent safety button',
            'safetyButtonEnabled',
            safetySettings['safetyButtonEnabled'] ?? true,
          ),
          _buildSwitchOption(
            context,
            'Emergency Services Integration',
            'Direct connection to local emergency services',
            'emergencyServicesIntegration',
            safetySettings['emergencyServicesIntegration'] ?? true,
          ),
          _buildSwitchOption(
            context,
            'Panic Mode',
            'Quick activation methods for emergencies',
            'panicModeEnabled',
            safetySettings['panicModeEnabled'] ?? true,
          ),
          _buildActivationOption(
            context,
            'Panic Mode Activation',
            safetySettings['panicModeActivation'] ?? 'Triple tap',
            () => _showActivationPicker(context),
          ),
        ],
      ),
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

  Widget _buildActivationOption(
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

  void _showActivationPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Panic Mode Activation',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Triple tap',
            'Long press',
            'Volume button combo',
            'Voice command',
          ]
              .map((method) => ListTile(
                    title: Text(method),
                    leading: Radio<String>(
                      value: method,
                      groupValue: safetySettings['panicModeActivation'],
                      onChanged: (value) {
                        onSettingChanged('panicModeActivation', value);
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
