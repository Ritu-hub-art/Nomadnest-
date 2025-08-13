import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DataAnalyticsWidget extends StatelessWidget {
  final bool usageDataCollection;
  final bool personalizedRecommendations;
  final bool marketingCommunications;
  final Function(String, bool) onChanged;

  const DataAnalyticsWidget({
    super.key,
    required this.usageDataCollection,
    required this.personalizedRecommendations,
    required this.marketingCommunications,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data & Analytics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Control how your data is used to improve your experience',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 2.h),
            _buildSwitchTile(
              context,
              'Usage Data Collection',
              'Allow collection of app usage statistics to improve features',
              usageDataCollection,
              (value) => onChanged('usage', value),
            ),
            _buildSwitchTile(
              context,
              'Personalized Recommendations',
              'Use your activity to suggest relevant hosts and hangouts',
              personalizedRecommendations,
              (value) => onChanged('recommendations', value),
            ),
            _buildSwitchTile(
              context,
              'Marketing Communications',
              'Receive personalized offers and travel recommendations',
              marketingCommunications,
              (value) => onChanged('marketing', value),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Your privacy is important. We never sell your personal data to third parties.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
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
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
