import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final Function() onCopy;
  final Function() onDelete;
  final Function() onReport;
  final Function() onReply;

  const MessageContextMenuWidget({
    Key? key,
    required this.message,
    required this.isMe,
    required this.onCopy,
    required this.onDelete,
    required this.onReport,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            icon: 'reply',
            label: 'Reply',
            onTap: () {
              Navigator.pop(context);
              onReply();
            },
          ),
          if (message['type'] == 'text')
            _buildMenuItem(
              icon: 'content_copy',
              label: 'Copy',
              onTap: () {
                Navigator.pop(context);
                onCopy();
              },
            ),
          if (isMe)
            _buildMenuItem(
              icon: 'delete',
              label: 'Delete',
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
              isDestructive: true,
            ),
          if (!isMe)
            _buildMenuItem(
              icon: 'report',
              label: 'Report',
              onTap: () {
                Navigator.pop(context);
                onReport();
              },
              isDestructive: true,
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 20.sp,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isDestructive
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
