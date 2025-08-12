import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SafetyActivityItem extends StatelessWidget {
  final Map<String, dynamic> activity;

  const SafetyActivityItem({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String type = (activity['type'] as String?) ?? 'unknown';
    final DateTime timestamp =
        activity['timestamp'] as DateTime? ?? DateTime.now();
    final String location =
        (activity['location'] as String?) ?? 'Unknown location';
    final bool isEmergency = (activity['isEmergency'] as bool?) ?? false;

    Color getActivityColor() {
      switch (type) {
        case 'safe_checkin':
          return AppTheme.lightTheme.colorScheme.tertiary;
        case 'help_request':
          return AppTheme.lightTheme.colorScheme.error;
        case 'location_shared':
          return AppTheme.lightTheme.colorScheme.primary;
        default:
          return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      }
    }

    String getActivityIcon() {
      switch (type) {
        case 'safe_checkin':
          return 'check_circle';
        case 'help_request':
          return 'warning';
        case 'location_shared':
          return 'location_on';
        default:
          return 'info';
      }
    }

    String getActivityTitle() {
      switch (type) {
        case 'safe_checkin':
          return 'Safety Check-in';
        case 'help_request':
          return 'Help Requested';
        case 'location_shared':
          return 'Location Shared';
        default:
          return 'Safety Activity';
      }
    }

    String formatTimestamp(DateTime dateTime) {
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isEmergency
            ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.05)
            : AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEmergency
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: getActivityColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: getActivityIcon(),
                color: getActivityColor(),
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getActivityTitle(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            formatTimestamp(timestamp),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
