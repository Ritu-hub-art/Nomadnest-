import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SafetyCompanionButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const SafetyCompanionButtonWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12.h,
      right: 5.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 14.w,
          height: 14.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.error,
                AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(14.w / 2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'security',
              color: Colors.white,
              size: 6.w,
            ),
          ),
        ),
      ),
    );
  }
}
