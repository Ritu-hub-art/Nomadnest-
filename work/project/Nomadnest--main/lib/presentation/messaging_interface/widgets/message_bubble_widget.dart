import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final VoidCallback? onLongPress;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isMe,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageType = message['type'] as String? ?? 'text';
    final timestamp = message['timestamp'] as DateTime;
    final isRead = message['isRead'] as bool? ?? false;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              CircleAvatar(
                radius: 2.5.w,
                child: CustomImageWidget(
                  imageUrl: message['senderAvatar'] as String? ?? '',
                  width: 5.w,
                  height: 5.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 2.w),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 70.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.w),
                        topRight: Radius.circular(4.w),
                        bottomLeft:
                            isMe ? Radius.circular(4.w) : Radius.circular(1.w),
                        bottomRight:
                            isMe ? Radius.circular(1.w) : Radius.circular(4.w),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildMessageContent(messageType),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(timestamp),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontSize: 10.sp,
                        ),
                      ),
                      if (isMe) ...[
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: isRead ? 'done_all' : 'done',
                          color: isRead
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 12.sp,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (isMe) SizedBox(width: 2.w),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(String messageType) {
    switch (messageType) {
      case 'text':
        return Text(
          message['content'] as String,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color:
                isMe ? Colors.white : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        );
      case 'image':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: CustomImageWidget(
                imageUrl: message['imageUrl'] as String,
                width: 50.w,
                height: 30.h,
                fit: BoxFit.cover,
              ),
            ),
            if (message['caption'] != null &&
                (message['caption'] as String).isNotEmpty) ...[
              SizedBox(height: 1.h),
              Text(
                message['caption'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isMe
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ],
        );
      case 'location':
        return Container(
          width: 50.w,
          height: 20.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.w),
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.primaryColor,
                size: 24.sp,
              ),
              SizedBox(height: 1.h),
              Text(
                'Location Shared',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: isMe
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                message['locationName'] as String? ?? 'Unknown Location',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case 'safety_checkin':
        return Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'verified_user',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 16.sp,
              ),
              SizedBox(width: 2.w),
              Text(
                'Safety Check-in: I\'m Safe',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      default:
        return Text(
          message['content'] as String? ?? '',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color:
                isMe ? Colors.white : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        );
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
