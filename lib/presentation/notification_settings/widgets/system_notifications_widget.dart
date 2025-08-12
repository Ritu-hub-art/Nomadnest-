import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SystemNotificationsWidget extends StatefulWidget {
  final bool securityAlerts;
  final bool appUpdates;
  final bool maintenanceNotices;
  final Function(String, bool) onChanged;

  const SystemNotificationsWidget({
    super.key,
    required this.securityAlerts,
    required this.appUpdates,
    required this.maintenanceNotices,
    required this.onChanged,
  });

  @override
  State<SystemNotificationsWidget> createState() =>
      _SystemNotificationsWidgetState();
}

class _SystemNotificationsWidgetState extends State<SystemNotificationsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Important app and account notifications',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondaryLight,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: widget.securityAlerts ||
                        widget.appUpdates ||
                        widget.maintenanceNotices,
                    onChanged: (value) {
                      widget.onChanged('securityAlerts', value);
                      widget.onChanged('appUpdates', value);
                      widget.onChanged('maintenanceNotices', value);
                    },
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.textSecondaryLight,
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              SizedBox(height: 2.h),
              Divider(color: AppTheme.borderLight),
              SizedBox(height: 2.h),
              _buildNotificationItem(
                'Security Alerts',
                'Important security notifications and login attempts',
                'securityAlerts',
                widget.securityAlerts,
                isRequired: true,
                priority: 'High',
              ),
              _buildNotificationItem(
                'App Updates',
                'Notifications about new app versions and features',
                'appUpdates',
                widget.appUpdates,
                priority: 'Medium',
              ),
              _buildNotificationItem(
                'Maintenance Notices',
                'Scheduled maintenance and service interruptions',
                'maintenanceNotices',
                widget.maintenanceNotices,
                priority: 'Low',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String subtitle,
    String key,
    bool value, {
    bool isRequired = false,
    String? priority,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (isRequired) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.5.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'REQUIRED',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                ),
                if (priority != null) ...[
                  SizedBox(height: 0.5.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(priority).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getPriorityIcon(priority),
                          size: 12,
                          color: _getPriorityColor(priority),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '$priority Priority',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: _getPriorityColor(priority),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: isRequired
                ? null
                : (newValue) => widget.onChanged(key, newValue),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.errorLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.warning_outlined;
      case 'low':
        return Icons.info_outline;
      default:
        return Icons.circle;
    }
  }
}
