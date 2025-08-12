import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class AboutSettingsWidget extends StatelessWidget {
  const AboutSettingsWidget({super.key});

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
                  iconName: 'info',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'About',
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

          // App version
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'phone_android',
              size: 24,
            ),
            title: Text(
              'App Version',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Version 1.0.0 (Build 100)',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            minTileHeight: 6.h,
          ),

          // Terms of service
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'description',
              size: 24,
            ),
            title: Text(
              'Terms of Service',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Read our terms and conditions',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showTermsDialog(context),
            minTileHeight: 6.h,
          ),

          // Privacy policy
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'privacy_tip',
              size: 24,
            ),
            title: Text(
              'Privacy Policy',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'How we handle your data',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showPrivacyDialog(context),
            minTileHeight: 6.h,
          ),

          // Community guidelines
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'group',
              size: 24,
            ),
            title: Text(
              'Community Guidelines',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Rules for a safe community',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showGuidelinesDialog(context),
            minTileHeight: 6.h,
          ),

          // Help center
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'help_center',
              size: 24,
            ),
            title: Text(
              'Help Center',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'FAQs and support articles',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showHelpCenterDialog(context),
            minTileHeight: 6.h,
          ),

          // Contact us
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'contact_support',
              size: 24,
            ),
            title: Text(
              'Contact Us',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Get in touch with our team',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showContactDialog(context),
            minTileHeight: 6.h,
          ),

          // Rate app
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'star_rate',
              size: 24,
            ),
            title: Text(
              'Rate NomadNest',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Love the app? Leave us a review!',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showRateAppDialog(context),
            minTileHeight: 6.h,
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Terms of Service',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 60.h,
          child: SingleChildScrollView(
            child: Text(
              '''Welcome to NomadNest!

These Terms of Service ("Terms") govern your use of the NomadNest mobile application and services.

1. ACCEPTANCE OF TERMS
By using NomadNest, you agree to be bound by these Terms. If you do not agree, please do not use our services.

2. DESCRIPTION OF SERVICE
NomadNest connects digital nomads worldwide, facilitating accommodation sharing, meetups, and community building.

3. USER ACCOUNTS
You must create an account to use our services. You are responsible for maintaining account security and all activities under your account.

4. USER CONDUCT
You agree to:
- Provide accurate information
- Respect other users
- Follow community guidelines
- Not engage in illegal activities

5. PRIVACY
Your privacy is important to us. Please review our Privacy Policy for information about how we collect and use your data.

6. SAFETY
While we provide safety features, you are responsible for your personal safety when meeting other users or staying in shared accommodations.

7. INTELLECTUAL PROPERTY
The NomadNest app and content are protected by copyright and other intellectual property laws.

8. LIMITATION OF LIABILITY
NomadNest is not liable for any damages arising from your use of the service, interactions with other users, or accommodations found through our platform.

9. CHANGES TO TERMS
We may update these Terms from time to time. Continued use of the service constitutes acceptance of updated Terms.

10. CONTACT
For questions about these Terms, contact us at legal@nomadnest.com.

Last updated: December 11, 2024''',
              style: GoogleFonts.inter(fontSize: 14.sp),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 60.h,
          child: SingleChildScrollView(
            child: Text(
              '''NomadNest Privacy Policy

This Privacy Policy describes how we collect, use, and protect your personal information when you use NomadNest.

INFORMATION WE COLLECT
- Account information (name, email, profile photo)
- Location data (when you choose to share)
- Messages and communications
- Usage data and analytics
- Device information

HOW WE USE YOUR INFORMATION
- Provide and improve our services
- Connect you with other users
- Send notifications and updates
- Ensure platform safety and security
- Comply with legal obligations

INFORMATION SHARING
We do not sell your personal information. We may share data:
- With other users (as you choose)
- With service providers
- For legal compliance
- In case of business transfer

YOUR PRIVACY CONTROLS
You can:
- Control profile visibility
- Manage location sharing
- Adjust notification preferences
- Delete your account

DATA SECURITY
We implement appropriate security measures to protect your data, including encryption and secure servers.

DATA RETENTION
We retain your data as long as your account is active or as needed for legal purposes.

CHILDREN'S PRIVACY
Our service is not intended for users under 13 years old.

INTERNATIONAL TRANSFERS
Your data may be transferred to servers in different countries with appropriate safeguards.

CONTACT US
For privacy questions, email privacy@nomadnest.com.

Last updated: December 11, 2024''',
              style: GoogleFonts.inter(fontSize: 14.sp),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGuidelinesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Community Guidelines',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 50.h,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our community guidelines help ensure NomadNest remains a safe, welcoming space for all digital nomads.',
                  style: GoogleFonts.inter(fontSize: 14.sp),
                ),
                SizedBox(height: 2.h),
                _buildGuidelineItem('Be Respectful',
                    'Treat all community members with respect and kindness.'),
                _buildGuidelineItem('Stay Safe',
                    'Meet in public places and trust your instincts.'),
                _buildGuidelineItem('Be Honest',
                    'Provide accurate information in your profile and listings.'),
                _buildGuidelineItem('Communicate Clearly',
                    'Be responsive and clear in your communications.'),
                _buildGuidelineItem('Follow Local Laws',
                    'Respect local laws and customs wherever you are.'),
                _buildGuidelineItem('Report Issues',
                    'Report any inappropriate behavior or safety concerns.'),
                _buildGuidelineItem('Protect Privacy',
                    'Respect others\' privacy and personal information.'),
                _buildGuidelineItem('No Discrimination',
                    'We don\'t tolerate discrimination of any kind.'),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            description,
            style: GoogleFonts.inter(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  void _showHelpCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Help Center',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'help',
                size: 24,
              ),
              title: Text(
                'Frequently Asked Questions',
                style: GoogleFonts.inter(fontSize: 16.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to FAQ
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'security',
                size: 24,
              ),
              title: Text(
                'Safety Tips',
                style: GoogleFonts.inter(fontSize: 16.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to safety tips
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'school',
                size: 24,
              ),
              title: Text(
                'How to Use NomadNest',
                style: GoogleFonts.inter(fontSize: 16.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to tutorials
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Contact Us',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'email',
                size: 24,
              ),
              title: Text(
                'Email Support',
                style: GoogleFonts.inter(fontSize: 16.sp),
              ),
              subtitle: Text(
                'support@nomadnest.com',
                style: GoogleFonts.inter(fontSize: 14.sp),
              ),
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'chat',
                size: 24,
              ),
              title: Text(
                'Live Chat',
                style: GoogleFonts.inter(fontSize: 16.sp),
              ),
              subtitle: Text(
                'Available 24/7',
                style: GoogleFonts.inter(fontSize: 14.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Open live chat
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'bug_report',
                size: 24,
              ),
              title: Text(
                'Report a Bug',
                style: GoogleFonts.inter(fontSize: 16.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Open bug report form
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRateAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Rate NomadNest',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How would you rate your experience with NomadNest?',
              style: GoogleFonts.inter(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                  (index) => GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // Handle rating
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: CustomIconWidget(
                            iconName: 'star',
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Maybe Later',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
