import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatsRowWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;

  const StatsRowWidget({
    Key? key,
    required this.userProfile,
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Trips',
              (userProfile["tripsCount"] as int?) ?? 0,
              'flight_takeoff',
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildStatItem(
              'Hosted',
              (userProfile["hostedCount"] as int?) ?? 0,
              'home',
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildStatItem(
              'Reviews',
              (userProfile["reviewsCount"] as int?) ?? 0,
              'star',
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildStatItem(
              'Rating',
              double.parse(((userProfile["rating"] as double?) ?? 0.0)
                  .toStringAsFixed(1)),
              'grade',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, dynamic value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value.toString(),
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
