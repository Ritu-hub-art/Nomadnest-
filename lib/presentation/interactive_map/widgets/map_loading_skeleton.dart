import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MapLoadingSkeleton extends StatefulWidget {
  const MapLoadingSkeleton({super.key});

  @override
  State<MapLoadingSkeleton> createState() => _MapLoadingSkeletonState();
}

class _MapLoadingSkeletonState extends State<MapLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Background pattern
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.05),
                ],
              ),
            ),
          ),

          // Skeleton markers
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: [
                  // Host markers
                  _buildSkeletonMarker(
                    top: 25.h,
                    left: 20.w,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                  _buildSkeletonMarker(
                    top: 35.h,
                    right: 25.w,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                  _buildSkeletonMarker(
                    top: 45.h,
                    left: 15.w,
                    color: AppTheme.lightTheme.primaryColor,
                  ),

                  // Hangout markers
                  _buildSkeletonMarker(
                    top: 30.h,
                    left: 40.w,
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                  _buildSkeletonMarker(
                    top: 50.h,
                    right: 20.w,
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),

                  // Traveler markers
                  _buildSkeletonMarker(
                    top: 40.h,
                    right: 35.w,
                    color: AppTheme.warningLight,
                  ),
                  _buildSkeletonMarker(
                    top: 55.h,
                    left: 30.w,
                    color: AppTheme.warningLight,
                  ),
                ],
              );
            },
          ),

          // Loading indicator
          Center(
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 8.w,
                    height: 8.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading map data...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonMarker({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
