import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;

  const FilterChipsWidget({
    Key? key,
    required this.selectedFilters,
    required this.onFilterToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'label': 'All', 'value': 'all', 'icon': 'apps'},
      {'label': 'Food & Drink', 'value': 'food', 'icon': 'restaurant'},
      {'label': 'Outdoor', 'value': 'outdoor', 'icon': 'nature'},
      {'label': 'Culture', 'value': 'culture', 'icon': 'museum'},
      {'label': 'Nightlife', 'value': 'nightlife', 'icon': 'nightlife'},
      {'label': 'Sports', 'value': 'sports', 'icon': 'sports'},
      {'label': 'Work', 'value': 'work', 'icon': 'work'},
      {'label': 'Starting Soon', 'value': 'urgent', 'icon': 'schedule'},
    ];

    return Container(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilters.contains(filter['value']);
          final isAll = filter['value'] == 'all';
          final isUrgent = filter['value'] == 'urgent';

          return FilterChip(
            selected: isSelected,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: filter['icon'] as String,
                  color: isSelected
                      ? (isUrgent
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.primary)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  filter['label'] as String,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? (isUrgent
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.primary)
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (isSelected && !isAll)
                  Container(
                    margin: EdgeInsets.only(left: 1.w),
                    width: 1.5.w,
                    height: 1.5.w,
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            onSelected: (selected) => onFilterToggle(filter['value'] as String),
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            selectedColor: isUrgent
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.primaryContainer,
            side: BorderSide(
              color: isSelected
                  ? (isUrgent
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary)
                  : AppTheme.lightTheme.colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}
