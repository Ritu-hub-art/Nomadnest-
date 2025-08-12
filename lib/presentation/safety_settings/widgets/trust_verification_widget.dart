import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TrustVerificationWidget extends StatelessWidget {
  final Map<String, dynamic> safetySettings;
  final Function(String, dynamic) onSettingChanged;

  const TrustVerificationWidget({
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
                  iconName: 'verified',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trust & Verification',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Current verification status',
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
          _buildVerificationItem(
            context,
            'Identity Documents',
            safetySettings['identityVerified'] == true
                ? 'Verified'
                : 'Not verified',
            safetySettings['identityVerified'] == true,
            () => _handleVerification('identityVerified'),
          ),
          _buildVerificationItem(
            context,
            'Phone Verification',
            safetySettings['phoneVerified'] == true
                ? 'Verified'
                : 'Not verified',
            safetySettings['phoneVerified'] == true,
            () => _handleVerification('phoneVerified'),
          ),
          _buildVerificationItem(
            context,
            'Social Media Linking',
            safetySettings['socialMediaLinked'] == true
                ? 'Connected'
                : 'Not connected',
            safetySettings['socialMediaLinked'] == true,
            () => _handleVerification('socialMediaLinked'),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationItem(
    BuildContext context,
    String title,
    String status,
    bool isVerified,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      leading: CustomIconWidget(
        iconName: isVerified ? 'check_circle' : 'radio_button_unchecked',
        color: isVerified
            ? Colors.green.shade600
            : Theme.of(context).colorScheme.outline,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: isVerified
              ? Colors.green.shade600
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: isVerified ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: isVerified
          ? null
          : TextButton(
              onPressed: onTap,
              child: Text(
                'Verify',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
      onTap: isVerified ? null : onTap,
    );
  }

  void _handleVerification(String verificationType) {
    // Implementation for verification process
    onSettingChanged(verificationType, true);
  }
}
