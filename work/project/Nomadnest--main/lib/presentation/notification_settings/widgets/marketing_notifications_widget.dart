import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MarketingNotificationsWidget extends StatefulWidget {
  final bool promotions;
  final bool featureAnnouncements;
  final bool travelTips;
  final Function(String, bool) onChanged;

  const MarketingNotificationsWidget({
    super.key,
    required this.promotions,
    required this.featureAnnouncements,
    required this.travelTips,
    required this.onChanged,
  });

  @override
  State<MarketingNotificationsWidget> createState() =>
      _MarketingNotificationsWidgetState();
}

class _MarketingNotificationsWidgetState
    extends State<MarketingNotificationsWidget> {
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
                          'Marketing',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Discover deals, tips, and new features',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondaryLight,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: widget.promotions ||
                        widget.featureAnnouncements ||
                        widget.travelTips,
                    onChanged: (value) {
                      widget.onChanged('promotions', value);
                      widget.onChanged('featureAnnouncements', value);
                      widget.onChanged('travelTips', value);
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
                'Promotions',
                'Special offers and discounts on accommodations',
                'promotions',
                widget.promotions,
                timing: 'Weekly digest',
              ),
              _buildNotificationItem(
                'Feature Announcements',
                'Learn about new app features and improvements',
                'featureAnnouncements',
                widget.featureAnnouncements,
                timing: 'Immediate',
              ),
              _buildNotificationItem(
                'Travel Tips',
                'Helpful guides and recommendations for travelers',
                'travelTips',
                widget.travelTips,
                timing: 'Daily digest',
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
    String? timing,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
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
                if (timing != null) ...[
                  SizedBox(height: 0.5.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      timing,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) => widget.onChanged(key, newValue),
          ),
        ],
      ),
    );
  }
}
