import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/about_settings_widget.dart';
import './widgets/account_settings_widget.dart';
import './widgets/language_currency_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/privacy_safety_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // User settings state
  Map<String, dynamic> _userSettings = {
    'email': 'sarah.chen@nomadnest.com',
    'phone': '+1 (555) 123-4567',
    'phoneVerified': true,
    'emailVerified': true,
    'twoFactorEnabled': false,
    'pushNotifications': true,
    'emailNotifications': true,
    'smsNotifications': false,
    'messageNotifications': true,
    'hangoutNotifications': true,
    'safetyNotifications': true,
    'profileVisibility': 'public',
    'locationSharing': 'friends',
    'showOnlineStatus': true,
    'allowDirectMessages': true,
    'language': 'English',
    'currency': 'USD',
    'darkMode': false,
    'hapticFeedback': true,
  };

  final List<Map<String, dynamic>> _blockedUsers = [
    {
      'id': '1',
      'name': 'John Doe',
      'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop',
      'blockedDate': '2 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 8.w,
                    backgroundImage: const NetworkImage(
                      'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sarah Chen',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            CustomIconWidget(
                              iconName: 'verified',
                              color: Colors.green.shade600,
                              size: 20,
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          _userSettings['email'],
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to edit profile
                      Navigator.pushNamed(context, AppRoutes.userProfile);
                    },
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Settings Menu Items
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  _buildSettingsMenuItem(
                    context,
                    'Privacy Controls',
                    'Manage your privacy and visibility settings',
                    'privacy_tip',
                    () => _showPrivacyControlsSection(),
                  ),
                  _buildSettingsMenuDivider(context),
                  _buildSettingsMenuItem(
                    context,
                    'Notifications',
                    'Configure notification preferences',
                    'notifications',
                    () => _showNotificationSection(),
                  ),
                  _buildSettingsMenuDivider(context),
                  _buildSettingsMenuItem(
                    context,
                    'Safety Settings',
                    'Emergency contacts and safety features',
                    'shield',
                    () =>
                        Navigator.pushNamed(context, AppRoutes.safetySettings),
                  ),
                  _buildSettingsMenuDivider(context),
                  _buildSettingsMenuItem(
                    context,
                    'Account Management',
                    'Account security and data management',
                    'account_circle',
                    () => Navigator.pushNamed(
                        context, AppRoutes.accountManagement),
                  ),
                  _buildSettingsMenuDivider(context),
                  _buildSettingsMenuItem(
                    context,
                    'Logout',
                    'Sign out of your account',
                    'logout',
                    _showLogoutConfirmation,
                    isDestructive: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Additional Settings Sections (shown when expanded)
            if (_showPrivacySection) ...[
              PrivacySafetyWidget(
                userSettings: _userSettings,
                blockedUsers: _blockedUsers,
                onSettingChanged: (key, value) {
                  setState(() {
                    _userSettings[key] = value;
                  });
                  _showSuccessToast('Privacy settings updated');
                },
                onUnblockUser: (userId) {
                  setState(() {
                    _blockedUsers.removeWhere((user) => user['id'] == userId);
                  });
                  _showSuccessToast('User unblocked');
                },
              ),
              SizedBox(height: 2.h),
            ],

            if (_showNotificationsSection) ...[
              NotificationSettingsWidget(
                userSettings: _userSettings,
                onSettingChanged: (key, value) {
                  setState(() {
                    _userSettings[key] = value;
                  });
                  _showSuccessToast('Notification preferences saved');
                },
              ),
              SizedBox(height: 2.h),
            ],

            // Account Settings Section
            AccountSettingsWidget(
              userSettings: _userSettings,
              onSettingChanged: (key, value) {
                setState(() {
                  _userSettings[key] = value;
                });
                _showSuccessToast('Account settings updated');
              },
            ),

            SizedBox(height: 2.h),

            // Language & Currency Section
            LanguageCurrencyWidget(
              userSettings: _userSettings,
              onSettingChanged: (key, value) {
                setState(() {
                  _userSettings[key] = value;
                });
                _showSuccessToast('Language & currency updated');
              },
            ),

            SizedBox(height: 2.h),

            // About Section
            AboutSettingsWidget(),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  // State variables for expandable sections
  bool _showPrivacySection = false;
  bool _showNotificationsSection = false;

  Widget _buildSettingsMenuItem(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
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
      trailing: const CustomIconWidget(
        iconName: 'chevron_right',
        size: 20,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      minTileHeight: 6.h,
    );
  }

  Widget _buildSettingsMenuDivider(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      indent: 4.w,
      endIndent: 4.w,
    );
  }

  void _showPrivacyControlsSection() {
    setState(() {
      _showPrivacySection = !_showPrivacySection;
      _showNotificationsSection = false; // Close other sections
    });
  }

  void _showNotificationSection() {
    setState(() {
      _showNotificationsSection = !_showNotificationsSection;
      _showPrivacySection = false; // Close other sections
    });
  }

  void _showSuccessToast(String message) {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _showLogoutConfirmation() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Log Out',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Log Out',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // Simulate logout process
    Fluttertoast.showToast(
      msg: "Logged out successfully",
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );

    // Navigate to login screen and clear navigation stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }
}