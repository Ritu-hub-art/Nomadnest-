import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final bool isOwnProfile;
  final VoidCallback? onPrivacyPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onSafetyPressed;
  final VoidCallback? onAccountPressed;
  final VoidCallback? onLogoutPressed;

  const SettingsSectionWidget({
    Key? key,
    required this.isOwnProfile,
    this.onPrivacyPressed,
    this.onNotificationPressed,
    this.onSafetyPressed,
    this.onAccountPressed,
    this.onLogoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isOwnProfile) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Settings',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.w), // 16px spacing
          _buildSettingItem(
            'Privacy Controls',
            'Manage your privacy settings',
            'privacy_tip',
            onPrivacyPressed,
          ),
          _buildSettingItem(
            'Notifications',
            'Configure notification preferences',
            'notifications',
            onNotificationPressed,
          ),
          _buildSettingItem(
            'Safety Settings',
            'Emergency contacts and safety features',
            'security',
            onSafetyPressed,
          ),
          _buildSettingItem(
            'Account Management',
            'Manage your account details',
            'account_circle',
            () => Navigator.pushNamed(context, AppRoutes.profileSettings),
          ),
          _buildSettingItem(
            'Logout',
            'Sign out of your account',
            'logout',
            onLogoutPressed,
            isDestructive: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    String iconName,
    VoidCallback? onPressed, {
    bool isDestructive = false,
    bool isLast = false,
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight:
            11.w, // Minimum 44px touch target (11.w ≈ 44px on most devices)
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 3.w, horizontal: 2.w), // 12px vertical, 8px horizontal
          margin:
              EdgeInsets.only(bottom: isLast ? 0 : 2.w), // 8px bottom margin
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 11.w,
                height: 11.w,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isDestructive
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 4.w), // 16px spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        height: 1.3,
                        color: isDestructive
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.w), // 4px spacing
                    Text(
                      subtitle,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        height: 1.2,
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w), // 8px spacing
              Container(
                padding:
                    EdgeInsets.all(2.w), // 8px padding for better touch target
                child: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.outline,
                  size: 4.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}