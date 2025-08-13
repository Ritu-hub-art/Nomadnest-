import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProfileVisibilityWidget extends StatelessWidget {
  final String selectedValue;
  final Function(String) onChanged;

  const ProfileVisibilityWidget({
    super.key,
    required this.selectedValue,
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
              'Profile Visibility',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Control who can see your profile and personal information',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 2.h),

            // Public Option
            RadioListTile<String>(
              value: 'public',
              groupValue: selectedValue,
              onChanged: (value) => onChanged(value!),
              title: const Text('Public'),
              subtitle: const Text('Anyone can view your profile'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),

            // Friends Only Option
            RadioListTile<String>(
              value: 'friends',
              groupValue: selectedValue,
              onChanged: (value) => onChanged(value!),
              title: const Text('Friends Only'),
              subtitle:
                  const Text('Only your connections can see your profile'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),

            // Private Option
            RadioListTile<String>(
              value: 'private',
              groupValue: selectedValue,
              onChanged: (value) => onChanged(value!),
              title: const Text('Private'),
              subtitle:
                  const Text('Profile is hidden from search and discovery'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
