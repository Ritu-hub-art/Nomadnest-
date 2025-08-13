import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapLayerToggle extends StatelessWidget {
  final bool showHosts;
  final bool showHangouts;
  final bool showTravelers;
  final Function(String) onToggleLayer;

  const MapLayerToggle({
    super.key,
    required this.showHosts,
    required this.showHangouts,
    required this.showTravelers,
    required this.onToggleLayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.h, left: 4.w),
      child: Column(
        children: [
          _buildToggleButton(
            'Hosts',
            showHosts,
            AppTheme.lightTheme.primaryColor,
            'person',
            () => onToggleLayer('hosts'),
          ),
          SizedBox(height: 1.h),
          _buildToggleButton(
            'Hangouts',
            showHangouts,
            AppTheme.lightTheme.colorScheme.tertiary,
            'group',
            () => onToggleLayer('hangouts'),
          ),
          SizedBox(height: 1.h),
          _buildToggleButton(
            'Travelers',
            showTravelers,
            AppTheme.warningLight,
            'explore',
            () => onToggleLayer('travelers'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    bool isActive,
    Color activeColor,
    String iconName,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: isActive ? activeColor : AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? activeColor
                : AppTheme.lightTheme.colorScheme.outline,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isActive
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isActive
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
