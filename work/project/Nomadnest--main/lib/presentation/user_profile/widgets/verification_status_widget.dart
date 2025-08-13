import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VerificationStatusWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final bool isOwnProfile;
  final VoidCallback? onVerifyPressed;

  const VerificationStatusWidget({
    Key? key,
    required this.userProfile,
    required this.isOwnProfile,
    this.onVerifyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isVerified = (userProfile["isVerified"] as bool?) ?? false;
    final verificationLevel =
        (userProfile["verificationLevel"] as String?) ?? "none";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
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
                iconName: 'verified_user',
                color: isVerified
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.secondary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Verification Status',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildVerificationCard(isVerified, verificationLevel),
          if (isOwnProfile && !isVerified) ...[
            SizedBox(height: 2.h),
            _buildVerifyButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildVerificationCard(bool isVerified, String verificationLevel) {
    Color statusColor;
    String statusText;
    String statusDescription;
    String iconName;

    if (isVerified) {
      statusColor = AppTheme.lightTheme.colorScheme.tertiary;
      statusText = 'Verified';
      statusDescription = 'Your identity has been verified';
      iconName = 'check_circle';
    } else {
      statusColor = AppTheme.lightTheme.colorScheme.secondary;
      statusText = 'Not Verified';
      statusDescription = 'Complete verification to build trust';
      iconName = 'pending';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: statusColor,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  statusDescription,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onVerifyPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'verified_user',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text('Start Verification'),
          ],
        ),
      ),
    );
  }
}
