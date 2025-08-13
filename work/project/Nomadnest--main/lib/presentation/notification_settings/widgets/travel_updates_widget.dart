import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TravelUpdatesWidget extends StatefulWidget {
  final bool hostResponses;
  final bool hangoutInvitations;
  final bool safetyAlerts;
  final Map<String, Map<String, bool>> deliveryMethods;
  final Function(String, bool) onChanged;
  final Function(String, String, bool) onDeliveryMethodChanged;

  const TravelUpdatesWidget({
    super.key,
    required this.hostResponses,
    required this.hangoutInvitations,
    required this.safetyAlerts,
    required this.deliveryMethods,
    required this.onChanged,
    required this.onDeliveryMethodChanged,
  });

  @override
  State<TravelUpdatesWidget> createState() => _TravelUpdatesWidgetState();
}

class _TravelUpdatesWidgetState extends State<TravelUpdatesWidget> {
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
                          'Travel Updates',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Stay informed about your travel activities',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondaryLight,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: widget.hostResponses ||
                        widget.hangoutInvitations ||
                        widget.safetyAlerts,
                    onChanged: (value) {
                      widget.onChanged('hostResponses', value);
                      widget.onChanged('hangoutInvitations', value);
                      widget.onChanged('safetyAlerts', value);
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
                'Host Responses',
                'Get notified when hosts respond to your requests',
                'hostResponses',
                widget.hostResponses,
              ),
              _buildNotificationItem(
                'Hangout Invitations',
                'Receive invitations to join hangouts',
                'hangoutInvitations',
                widget.hangoutInvitations,
              ),
              _buildNotificationItem(
                'Safety Alerts',
                'Important safety and security notifications',
                'safetyAlerts',
                widget.safetyAlerts,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
      String title, String subtitle, String key, bool value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: (newValue) => widget.onChanged(key, newValue),
              ),
            ],
          ),
          if (value && widget.deliveryMethods.containsKey(key)) ...[
            SizedBox(height: 1.h),
            _buildDeliveryMethods(key),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliveryMethods(String notificationKey) {
    final methods = widget.deliveryMethods[notificationKey]!;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Methods',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              _buildMethodChip('Push', Icons.notifications, methods['push']!,
                  (value) {
                widget.onDeliveryMethodChanged(notificationKey, 'push', value);
              }),
              SizedBox(width: 2.w),
              _buildMethodChip('Email', Icons.email, methods['email']!,
                  (value) {
                widget.onDeliveryMethodChanged(notificationKey, 'email', value);
              }),
              SizedBox(width: 2.w),
              _buildMethodChip('SMS', Icons.sms, methods['sms']!, (value) {
                widget.onDeliveryMethodChanged(notificationKey, 'sms', value);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodChip(
      String label, IconData icon, bool isSelected, Function(bool) onChanged) {
    return FilterChip(
      selected: isSelected,
      onSelected: onChanged,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          SizedBox(width: 1.w),
          Text(label),
        ],
      ),
      selectedColor: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.lightTheme.primaryColor,
    );
  }
}
