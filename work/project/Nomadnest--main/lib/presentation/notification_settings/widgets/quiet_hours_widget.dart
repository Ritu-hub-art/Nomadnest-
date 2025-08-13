import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuietHoursWidget extends StatefulWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<String> selectedDays;
  final Function({TimeOfDay? start, TimeOfDay? end, List<String>? days})
      onChanged;

  const QuietHoursWidget({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.selectedDays,
    required this.onChanged,
  });

  @override
  State<QuietHoursWidget> createState() => _QuietHoursWidgetState();
}

class _QuietHoursWidgetState extends State<QuietHoursWidget> {
  final List<String> _allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? widget.startTime : widget.endTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onChanged(
        start: isStartTime ? picked : null,
        end: !isStartTime ? picked : null,
      );
    }
  }

  void _toggleDay(String day) {
    final List<String> newDays = List.from(widget.selectedDays);
    if (newDays.contains(day)) {
      newDays.remove(day);
    } else {
      newDays.add(day);
    }
    widget.onChanged(days: newDays);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiet Hours',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Set notification-free periods for peaceful rest',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 3.h),

            // Time Selection
            Row(
              children: [
                Expanded(
                  child: _buildTimeSelector(
                    'Start Time',
                    widget.startTime,
                    () => _selectTime(context, true),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildTimeSelector(
                    'End Time',
                    widget.endTime,
                    () => _selectTime(context, false),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Day Selection
            Text(
              'Active Days',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Select which days quiet hours apply',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 2.h),

            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _allDays.map((day) {
                final isSelected = widget.selectedDays.contains(day);
                return FilterChip(
                  selected: isSelected,
                  onSelected: (_) => _toggleDay(day),
                  label: Text(day.substring(0, 3)),
                  selectedColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.lightTheme.primaryColor,
                );
              }).toList(),
            ),

            SizedBox(height: 3.h),

            // Quick Selection Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.onChanged(days: [
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday'
                    ]),
                    child: const Text('Weekdays'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        widget.onChanged(days: ['Saturday', 'Sunday']),
                    child: const Text('Weekends'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.onChanged(days: _allDays),
                    child: const Text('All Days'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Summary
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.bedtime,
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      widget.selectedDays.isNotEmpty
                          ? 'Quiet from ${_formatTimeOfDay(widget.startTime)} to ${_formatTimeOfDay(widget.endTime)} on ${widget.selectedDays.length} day${widget.selectedDays.length > 1 ? 's' : ''}'
                          : 'No quiet hours set',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
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

  Widget _buildTimeSelector(String label, TimeOfDay time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTimeOfDay(time),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Icon(
                  Icons.access_time,
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
