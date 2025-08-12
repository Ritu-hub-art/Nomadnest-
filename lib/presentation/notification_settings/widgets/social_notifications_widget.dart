import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SocialNotificationsWidget extends StatefulWidget {
  final bool newFollowers;
  final bool profileViews;
  final bool friendRequests;
  final Map<String, Map<String, bool>> deliveryMethods;
  final Function(String, bool) onChanged;
  final Function(String, String, bool) onDeliveryMethodChanged;

  const SocialNotificationsWidget({
    super.key,
    required this.newFollowers,
    required this.profileViews,
    required this.friendRequests,
    required this.deliveryMethods,
    required this.onChanged,
    required this.onDeliveryMethodChanged,
  });

  @override
  State<SocialNotificationsWidget> createState() =>
      _SocialNotificationsWidgetState();
}

class _SocialNotificationsWidgetState extends State<SocialNotificationsWidget> {
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
                          'Social',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Connect and engage with other travelers',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondaryLight,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: widget.newFollowers ||
                        widget.profileViews ||
                        widget.friendRequests,
                    onChanged: (value) {
                      widget.onChanged('newFollowers', value);
                      widget.onChanged('profileViews', value);
                      widget.onChanged('friendRequests', value);
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
                'New Followers',
                'When someone follows your profile',
                'newFollowers',
                widget.newFollowers,
              ),
              _buildNotificationItem(
                'Profile Views',
                'When someone views your profile',
                'profileViews',
                widget.profileViews,
              ),
              _buildNotificationItem(
                'Friend Requests',
                'When someone sends you a friend request',
                'friendRequests',
                widget.friendRequests,
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
