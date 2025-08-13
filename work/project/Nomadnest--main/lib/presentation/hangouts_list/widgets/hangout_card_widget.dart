import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HangoutCardWidget extends StatelessWidget {
  final Map<String, dynamic> hangout;
  final VoidCallback onTap;
  final VoidCallback onJoinRequest;

  const HangoutCardWidget({
    Key? key,
    required this.hangout,
    required this.onTap,
    required this.onJoinRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeRemaining = _calculateTimeRemaining();
    final isUrgent = timeRemaining.contains('min') &&
        int.tryParse(timeRemaining.split(' ')[0]) != null &&
        int.parse(timeRemaining.split(' ')[0]) <= 30;

    return Dismissible(
      key: Key(hangout['id'].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'group_add',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              'Join Request',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        onJoinRequest();
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and urgency indicator
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CustomImageWidget(
                      imageUrl: hangout['image'] as String,
                      width: double.infinity,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isUrgent)
                    Positioned(
                      top: 2.h,
                      right: 3.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Starting Soon',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and activity type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            hangout['title'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            hangout['activityType'] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    // Description
                    Text(
                      hangout['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 2.h),

                    // Host info and stats
                    Row(
                      children: [
                        // Host avatar
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              NetworkImage(hangout['hostAvatar'] as String),
                        ),
                        SizedBox(width: 2.w),

                        // Host name
                        Expanded(
                          child: Text(
                            hangout['hostName'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Participants
                        CustomIconWidget(
                          iconName: 'group',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${hangout['participantCount']}/${hangout['maxParticipants']}',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),

                        SizedBox(width: 3.w),

                        // Distance
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          hangout['distance'] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    // Time remaining
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: isUrgent
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.secondary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          timeRemaining,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isUrgent
                                ? AppTheme.lightTheme.colorScheme.error
                                : null,
                            fontWeight: isUrgent ? FontWeight.w600 : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateTimeRemaining() {
    final startTime = DateTime.parse(hangout['startTime'] as String);
    final now = DateTime.now();
    final difference = startTime.difference(now);

    if (difference.isNegative) {
      return 'Started';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ${difference.inMinutes % 60}min';
    } else {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              context,
              'bookmark_border',
              'Save for Later',
              () => Navigator.pop(context),
            ),
            _buildContextMenuItem(
              context,
              'share',
              'Share Hangout',
              () => Navigator.pop(context),
            ),
            _buildContextMenuItem(
              context,
              'report',
              'Report',
              () => Navigator.pop(context),
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context,
    String iconName,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? AppTheme.lightTheme.colorScheme.error : null,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
