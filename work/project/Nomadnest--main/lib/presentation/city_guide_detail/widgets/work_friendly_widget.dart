import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class WorkFriendlyWidget extends StatelessWidget {
  final List<Map<String, dynamic>> workSpaces;

  const WorkFriendlyWidget({
    Key? key,
    required this.workSpaces,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: workSpaces
          .map((space) => _buildWorkSpaceCard(context, space))
          .toList(),
    );
  }

  Widget _buildWorkSpaceCard(BuildContext context, Map<String, dynamic> space) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImageWidget(
                  imageUrl: space['image'] as String,
                  width: double.infinity,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 2.w,
                right: 2.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'star',
                        color: Colors.amber,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        space['rating'].toString(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 2.w,
                left: 2.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    space['type'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        space['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (space['price'] != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          space['price'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  space['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureItem(
                        'WiFi Quality',
                        '${space['wifiQuality']}%',
                        'wifi',
                        _getWifiColor(space['wifiQuality'] as int),
                      ),
                    ),
                    Expanded(
                      child: _buildFeatureItem(
                        'Noise Level',
                        space['noiseLevel'] as String,
                        'volume_down',
                        _getNoiseColor(space['noiseLevel'] as String),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureItem(
                        'Power Outlets',
                        space['powerOutlets'] as String,
                        'power',
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: _buildFeatureItem(
                        'Seating',
                        space['seating'] as String,
                        'chair',
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        space['address'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      space['hours'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
                if (space['amenities'] != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'Amenities:',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: (space['amenities'] as List)
                        .cast<String>()
                        .map((amenity) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                amenity,
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ))
                        .toList(),
                  ),
                ],
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewLocation(context, space),
                        icon: CustomIconWidget(
                          iconName: 'map',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        label: Text('Location'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _saveWorkspace(context, space),
                        icon: CustomIconWidget(
                          iconName: 'bookmark_border',
                          color: Colors.white,
                          size: 16,
                        ),
                        label: Text('Save'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      String label, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 20,
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getWifiColor(int quality) {
    if (quality >= 80) return AppTheme.lightTheme.colorScheme.tertiary;
    if (quality >= 60) return Colors.orange;
    return AppTheme.lightTheme.colorScheme.error;
  }

  Color _getNoiseColor(String level) {
    switch (level.toLowerCase()) {
      case 'quiet':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'moderate':
        return Colors.orange;
      case 'loud':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  void _viewLocation(BuildContext context, Map<String, dynamic> space) {
    Navigator.pushNamed(context, '/interactive-map');
  }

  void _saveWorkspace(BuildContext context, Map<String, dynamic> space) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${space['name']} saved to your work-friendly places'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
