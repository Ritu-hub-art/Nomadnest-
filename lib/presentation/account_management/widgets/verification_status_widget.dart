import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class VerificationStatusWidget extends StatelessWidget {
  final Map<String, dynamic> accountData;
  final Function(String, dynamic) onVerificationChanged;

  const VerificationStatusWidget({
    super.key,
    required this.accountData,
    required this.onVerificationChanged,
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
                Text(
                  'Verification Status',
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
          _buildVerificationItem(
            context,
            'Identity Documents',
            accountData['identityVerified'] == true,
            'identityVerified',
          ),
          _buildVerificationItem(
            context,
            'Phone Number',
            accountData['phoneVerified'] == true,
            'phoneVerified',
          ),
          _buildVerificationItem(
            context,
            'Email Address',
            accountData['emailVerified'] == true,
            'emailVerified',
          ),
          _buildSocialMediaLinks(context),
        ],
      ),
    );
  }

  Widget _buildVerificationItem(
    BuildContext context,
    String title,
    bool isVerified,
    String key,
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
        isVerified ? 'Verified' : 'Not verified',
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: isVerified
              ? Colors.green.shade600
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isVerified
          ? null
          : TextButton(
              onPressed: () => _handleVerification(key),
              child: Text(
                'Verify',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
    );
  }

  Widget _buildSocialMediaLinks(BuildContext context) {
    final linkedServices =
        List<String>.from(accountData['socialMediaLinked'] ?? []);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      leading: CustomIconWidget(
        iconName: linkedServices.isNotEmpty ? 'link' : 'link_off',
        color: linkedServices.isNotEmpty
            ? Colors.green.shade600
            : Theme.of(context).colorScheme.outline,
        size: 24,
      ),
      title: Text(
        'Social Media Connections',
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        linkedServices.isEmpty
            ? 'No connections'
            : '${linkedServices.length} service(s) connected',
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: linkedServices.isNotEmpty
              ? Colors.green.shade600
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const CustomIconWidget(
        iconName: 'chevron_right',
        size: 20,
      ),
      onTap: () => _showSocialMediaDialog(context),
    );
  }

  void _handleVerification(String type) {
    onVerificationChanged(type, true);
  }

  void _showSocialMediaDialog(BuildContext context) {
    final availableServices = ['Google', 'Facebook', 'Apple', 'Twitter'];
    final linkedServices =
        List<String>.from(accountData['socialMediaLinked'] ?? []);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Social Media Connections',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableServices.map((service) {
            final isLinked = linkedServices.contains(service);
            return CheckboxListTile(
              title: Text(service),
              value: isLinked,
              onChanged: (value) {
                if (value == true && !linkedServices.contains(service)) {
                  linkedServices.add(service);
                } else if (value == false) {
                  linkedServices.remove(service);
                }
                onVerificationChanged('socialMediaLinked', linkedServices);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
