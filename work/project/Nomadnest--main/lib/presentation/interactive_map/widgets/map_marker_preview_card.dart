import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapMarkerPreviewCard extends StatelessWidget {
  final Map<String, dynamic> markerData;
  final VoidCallback onViewDetails;
  final VoidCallback onClose;

  const MapMarkerPreviewCard({
    super.key,
    required this.markerData,
    required this.onViewDetails,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final String type = markerData['type'] ?? 'host';
    final String name = markerData['name'] ?? 'Unknown';
    final String location = markerData['location'] ?? 'Unknown Location';
    final double rating = (markerData['rating'] ?? 0.0).toDouble();
    final String imageUrl = markerData['imageUrl'] ?? '';
    final String description = markerData['description'] ?? '';
    final bool isAvailable = markerData['isAvailable'] ?? true;

    return Positioned(
      bottom: 12.h,
      left: 4.w,
      right: 4.w,
      child: Container(
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
            // Header with close button
            Padding(
              padding: EdgeInsets.only(top: 2.w, right: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                    ),
                    child: imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomImageWidget(
                              imageUrl: imageUrl,
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: CustomIconWidget(
                              iconName: _getTypeIcon(type),
                              color: _getTypeColor(type),
                              size: 24,
                            ),
                          ),
                  ),

                  SizedBox(width: 3.w),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type badge and availability
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color:
                                    _getTypeColor(type).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                type.toUpperCase(),
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: _getTypeColor(type),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            if (type == 'host' || type == 'hangout')
                              Container(
                                width: 2.w,
                                height: 2.w,
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? AppTheme.successLight
                                      : AppTheme.errorLight,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 1.h),

                        // Name
                        Text(
                          name,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 0.5.h),

                        // Location
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                location,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 0.5.h),

                        // Rating
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: AppTheme.warningLight,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              rating.toStringAsFixed(1),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '•',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              isAvailable ? 'Available' : 'Busy',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isAvailable
                                    ? AppTheme.successLight
                                    : AppTheme.errorLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        if (description.isNotEmpty) ...[
                          SizedBox(height: 1.h),
                          Text(
                            description,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action button
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: ElevatedButton(
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getTypeColor(type),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                child: Text(
                  'View Details',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'host':
        return 'person';
      case 'hangout':
        return 'group';
      case 'traveler':
        return 'explore';
      default:
        return 'place';
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'host':
        return AppTheme.lightTheme.primaryColor;
      case 'hangout':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'traveler':
        return AppTheme.warningLight;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }
}
