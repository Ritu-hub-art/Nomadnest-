import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementsWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;

  const AchievementsWidget({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final achievements = (userProfile["achievements"] as List?) ?? [];

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
                iconName: 'emoji_events',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Achievements',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          achievements.isEmpty
              ? _buildEmptyState()
              : _buildAchievementsList(achievements),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'emoji_events',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No achievements yet',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start traveling to earn badges!',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(List achievements) {
    return Wrap(
      spacing: 3.w,
      runSpacing: 2.h,
      children: achievements.map<Widget>((achievement) {
        final achievementMap = achievement as Map<String, dynamic>;
        return _buildAchievementBadge(achievementMap);
      }).toList(),
    );
  }

  Widget _buildAchievementBadge(Map<String, dynamic> achievement) {
    final isUnlocked = (achievement["unlocked"] as bool?) ?? false;

    return Container(
      width: 20.w,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
              border: Border.all(
                color: isUnlocked
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 2,
              ),
            ),
            child: CustomIconWidget(
              iconName: (achievement["icon"] as String?) ?? 'star',
              color: isUnlocked
                  ? AppTheme.lightTheme.colorScheme.onTertiary
                  : AppTheme.lightTheme.colorScheme.outline,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            (achievement["title"] as String?) ?? "Achievement",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isUnlocked
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (achievement["progress"] != null)
            Container(
              margin: EdgeInsets.only(top: 0.5.h),
              width: 15.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: ((achievement["progress"] as double?) ?? 0.0)
                    .clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
