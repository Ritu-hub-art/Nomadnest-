import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EatDrinkWidget extends StatelessWidget {
  final List<Map<String, dynamic>> restaurants;

  const EatDrinkWidget({
    Key? key,
    required this.restaurants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: restaurants
          .map((restaurant) => _buildRestaurantCard(context, restaurant))
          .toList(),
    );
  }

  Widget _buildRestaurantCard(
      BuildContext context, Map<String, dynamic> restaurant) {
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
                  imageUrl: restaurant['image'] as String,
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
                        restaurant['rating'].toString(),
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
                    color:
                        _getPriceRangeColor(restaurant['priceRange'] as String),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    restaurant['priceRange'] as String,
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
                        restaurant['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        restaurant['cuisine'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  restaurant['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                        restaurant['address'] as String,
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
                      restaurant['hours'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    Spacer(),
                    if (restaurant['distance'] != null) ...[
                      CustomIconWidget(
                        iconName: 'directions_walk',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        restaurant['distance'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
                if (restaurant['specialties'] != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'Must Try:',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: (restaurant['specialties'] as List)
                        .cast<String>()
                        .map((specialty) => Container(
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
                                specialty,
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
                        onPressed: () => _viewLocation(context, restaurant),
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
                        onPressed: () => _saveRestaurant(context, restaurant),
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

  Color _getPriceRangeColor(String priceRange) {
    switch (priceRange) {
      case '\$':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case '\$\$':
        return Colors.orange;
      case '\$\$\$':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  void _viewLocation(BuildContext context, Map<String, dynamic> restaurant) {
    Navigator.pushNamed(context, '/interactive-map');
  }

  void _saveRestaurant(BuildContext context, Map<String, dynamic> restaurant) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${restaurant['name']} saved to your favorites'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
