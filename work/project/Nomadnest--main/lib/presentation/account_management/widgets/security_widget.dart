import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SecurityWidget extends StatelessWidget {
  final Map<String, dynamic> accountData;
  final List<Map<String, dynamic>> activeSessions;
  final Function(String, dynamic) onSecurityChanged;
  final Function(String) onSessionLogout;

  const SecurityWidget({
    super.key,
    required this.accountData,
    required this.activeSessions,
    required this.onSecurityChanged,
    required this.onSessionLogout,
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
                  iconName: 'security',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Security',
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
          _buildSecurityOption(
            context,
            'Two-Factor Authentication',
            'Add an extra layer of security',
            'twoFactorEnabled',
            accountData['twoFactorEnabled'] ?? false,
          ),
          _buildSessionsSection(context),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context,
    String title,
    String subtitle,
    String key,
    bool value,
  ) {
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
        onChanged: (newValue) {
          if (newValue) {
            _showTwoFactorSetupDialog(context);
          } else {
            onSecurityChanged(key, newValue);
          }
        },
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSessionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(4.w),
          child: Text(
            'Active Sessions',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...activeSessions.map((session) => _buildSessionTile(context, session)),
      ],
    );
  }

  Widget _buildSessionTile(BuildContext context, Map<String, dynamic> session) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName:
                session['device'].toString().toLowerCase().contains('iphone')
                    ? 'phone_iphone'
                    : 'laptop_mac',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        session['device'],
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (session['current'] == true)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Current',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  session['location'],
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Last active: ${session['lastActive']}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (session['current'] != true)
            TextButton(
              onPressed: () => _showLogoutConfirmation(context, session),
              child: Text(
                'Logout',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showTwoFactorSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Enable Two-Factor Authentication',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose your 2FA method:'),
            SizedBox(height: 2.h),
            ListTile(
              leading: const CustomIconWidget(iconName: 'sms', size: 24),
              title: const Text('SMS'),
              subtitle: const Text('Receive codes via text message'),
              onTap: () {
                Navigator.pop(context);
                onSecurityChanged('twoFactorEnabled', true);
              },
            ),
            ListTile(
              leading: const CustomIconWidget(iconName: 'apps', size: 24),
              title: const Text('Authenticator App'),
              subtitle: const Text('Use Google Authenticator or similar'),
              onTap: () {
                Navigator.pop(context);
                onSecurityChanged('twoFactorEnabled', true);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(
      BuildContext context, Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Session'),
        content:
            Text('Are you sure you want to logout from ${session['device']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onSessionLogout(session['id']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
