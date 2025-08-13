import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EssentialsWidget extends StatefulWidget {
  final Map<String, dynamic> essentialsData;

  const EssentialsWidget({
    Key? key,
    required this.essentialsData,
  }) : super(key: key);

  @override
  State<EssentialsWidget> createState() => _EssentialsWidgetState();
}

class _EssentialsWidgetState extends State<EssentialsWidget> {
  Set<String> expandedCards = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildEssentialCard(
          'Transportation',
          'directions_bus',
          widget.essentialsData['transportation'] as Map<String, dynamic>,
        ),
        SizedBox(height: 2.h),
        _buildEssentialCard(
          'Currency & Money',
          'attach_money',
          widget.essentialsData['currency'] as Map<String, dynamic>,
        ),
        SizedBox(height: 2.h),
        _buildEssentialCard(
          'Safety Tips',
          'security',
          widget.essentialsData['safety'] as Map<String, dynamic>,
        ),
        SizedBox(height: 2.h),
        _buildEssentialCard(
          'Local Customs',
          'people',
          widget.essentialsData['customs'] as Map<String, dynamic>,
        ),
        SizedBox(height: 2.h),
        _buildEssentialCard(
          'Language & Communication',
          'translate',
          widget.essentialsData['language'] as Map<String, dynamic>,
        ),
      ],
    );
  }

  Widget _buildEssentialCard(
      String title, String iconName, Map<String, dynamic> data) {
    final isExpanded = expandedCards.contains(title);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedCards.remove(title);
                } else {
                  expandedCards.add(title);
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: iconName,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      title,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2)),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: _buildExpandedContent(data),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data['overview'] != null) ...[
          Text(
            data['overview'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),
        ],
        if (data['tips'] != null) ...[
          Text(
            'Key Tips:',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ...(data['tips'] as List)
              .cast<String>()
              .map((tip) => Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0.5.h),
                          width: 1.w,
                          height: 1.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            tip,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
        if (data['details'] != null) ...[
          SizedBox(height: 1.h),
          ...(data['details'] as Map<String, dynamic>)
              .entries
              .map((entry) => Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key}:',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            entry.value.toString(),
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
        if (data['emergency'] != null) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    data['emergency'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
