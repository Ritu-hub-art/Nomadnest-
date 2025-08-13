import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const MapFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<MapFilterBottomSheet> createState() => _MapFilterBottomSheetState();
}

class _MapFilterBottomSheetState extends State<MapFilterBottomSheet> {
  late Map<String, dynamic> _filters;
  double _distanceRadius = 10.0;
  int _safetyRating = 3;
  String _selectedActivity = 'All';
  bool _availableOnly = false;

  final List<String> _activityTypes = [
    'All',
    'Sightseeing',
    'Food & Drink',
    'Nightlife',
    'Adventure',
    'Culture',
    'Shopping',
    'Sports',
    'Relaxation',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _distanceRadius = _filters['distanceRadius'] ?? 10.0;
    _safetyRating = _filters['safetyRating'] ?? 3;
    _selectedActivity = _filters['activityType'] ?? 'All';
    _availableOnly = _filters['availableOnly'] ?? false;
  }

  void _applyFilters() {
    final updatedFilters = {
      'distanceRadius': _distanceRadius,
      'safetyRating': _safetyRating,
      'activityType': _selectedActivity,
      'availableOnly': _availableOnly,
    };
    widget.onFiltersChanged(updatedFilters);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _distanceRadius = 10.0;
      _safetyRating = 3;
      _selectedActivity = 'All';
      _availableOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Results',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Distance Radius
                  _buildSectionTitle('Distance Radius'),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Within ${_distanceRadius.toInt()} km',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Text(
                              '${_distanceRadius.toInt()} km',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Slider(
                          value: _distanceRadius,
                          min: 1.0,
                          max: 50.0,
                          divisions: 49,
                          onChanged: (value) {
                            setState(() {
                              _distanceRadius = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Safety Rating
                  _buildSectionTitle('Minimum Safety Rating'),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        final rating = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _safetyRating = rating;
                            });
                          },
                          child: Container(
                            width: 12.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: rating <= _safetyRating
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'star',
                                color: rating <= _safetyRating
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Activity Type
                  _buildSectionTitle('Activity Type'),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _activityTypes.map((activity) {
                        final isSelected = activity == _selectedActivity;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedActivity = activity;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme.outline,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              activity,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Availability Toggle
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Only',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Show only available hosts and hangouts',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _availableOnly,
                          onChanged: (value) {
                            setState(() {
                              _availableOnly = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: Text(
                  'Apply Filters',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
