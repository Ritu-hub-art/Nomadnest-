import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/logo_widget.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final bool isOwnProfile;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCameraPressed;

  const ProfileHeaderWidget({
    Key? key,
    required this.userProfile,
    required this.isOwnProfile,
    this.onEditPressed,
    this.onCameraPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        children: [
          // NomadNest Logo at the top
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: const LogoWidget(
              width: 120,
              height: 60,
            ),
          ),
          _buildProfileImage(),
          SizedBox(height: 3.h),
          _buildUserInfo(),
          if (isOwnProfile) ...[
            SizedBox(height: 2.h),
            _buildEditButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: (userProfile["avatar"] as String?) ??
                  "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg",
              width: 25.w,
              height: 25.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (isOwnProfile)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onCameraPressed,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow
                          .withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 4.w,
                ),
              ),
            ),
          ),
        if ((userProfile["isVerified"] as bool?) == true)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.cardColor,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 3.w,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          (userProfile["name"] as String?) ?? "Unknown User",
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        if (userProfile["location"] != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                userProfile["location"] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        SizedBox(height: 1.h),
        if (userProfile["bio"] != null)
          Text(
            userProfile["bio"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onEditPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text('Edit Profile'),
          ],
        ),
      ),
    );
  }
}
