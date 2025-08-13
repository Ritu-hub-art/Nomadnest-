import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amenities_grid.dart';
import './widgets/host_stats_card.dart';
import './widgets/location_map_snippet.dart';
import './widgets/photo_carousel.dart';
import './widgets/reviews_section.dart';

class HostProfileDetail extends StatefulWidget {
  const HostProfileDetail({super.key});

  @override
  State<HostProfileDetail> createState() => _HostProfileDetailState();
}

class _HostProfileDetailState extends State<HostProfileDetail> {
  bool _isExpanded = false;
  bool _isLoading = true;

  // Mock host data
  final Map<String, dynamic> hostData = {
    "id": 1,
    "name": "Sarah Chen",
    "avatar":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
    "trustScore": 4.8,
    "isVerified": true,
    "hostingSince": "2019",
    "responseTime": "< 1 hour",
    "languages": ["English", "Mandarin", "Spanish"],
    "safetyRating": 4.9,
    "totalReviews": 127,
    "photos": [
      "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=800",
      "https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg?auto=compress&cs=tinysrgb&w=800",
      "https://images.pexels.com/photos/1571453/pexels-photo-1571453.jpeg?auto=compress&cs=tinysrgb&w=800",
      "https://images.pexels.com/photos/1080721/pexels-photo-1080721.jpeg?auto=compress&cs=tinysrgb&w=800",
    ],
    "about":
        """Welcome to my cozy downtown apartment! I'm a digital marketing professional who loves meeting travelers from around the world. My space is perfect for solo travelers or couples looking for an authentic local experience.

I've been hosting for over 4 years and have welcomed guests from 40+ countries. I'm passionate about sustainable travel and love sharing hidden gems around the city. When I'm not working, you'll find me exploring local coffee shops, hiking trails, or practicing yoga in the nearby park.

My apartment is located in the heart of the creative district, walking distance to amazing restaurants, art galleries, and public transportation. I'm always happy to share recommendations and help you discover the real essence of our beautiful city!""",
    "location": {
      "name": "Downtown Creative District",
      "approximateArea": "Within 0.5km radius",
      "latitude": 37.7749,
      "longitude": -122.4194,
    },
    "amenities": [
      {"name": "WiFi", "icon": "wifi", "available": true},
      {"name": "Kitchen", "icon": "kitchen", "available": true},
      {"name": "Laundry", "icon": "local_laundry_service", "available": true},
      {"name": "Parking", "icon": "local_parking", "available": false},
      {"name": "AC", "icon": "ac_unit", "available": true},
      {"name": "Workspace", "icon": "desk", "available": true},
      {"name": "TV", "icon": "tv", "available": true},
      {"name": "Gym", "icon": "fitness_center", "available": false},
      {"name": "Pool", "icon": "pool", "available": false},
    ],
    "reviews": [
      {
        "id": 1,
        "userName": "Marcus Johnson",
        "userAvatar":
            "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 5,
        "date": "2 weeks ago",
        "comment":
            "Sarah was an incredible host! Her place is exactly as described and the location is perfect. She gave me amazing local recommendations and was super responsive. Highly recommend!"
      },
      {
        "id": 2,
        "userName": "Elena Rodriguez",
        "userAvatar":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 5,
        "date": "1 month ago",
        "comment":
            "Stayed here for a week while working remotely. The workspace setup is fantastic and Sarah was so welcoming. The neighborhood has everything you need within walking distance."
      },
      {
        "id": 3,
        "userName": "David Kim",
        "userAvatar":
            "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4,
        "date": "2 months ago",
        "comment":
            "Great experience overall! The apartment is clean and comfortable. Sarah's local tips helped me discover some hidden gems. Only minor issue was the street noise at night, but nothing major."
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadHostData();
  }

  Future<void> _loadHostData() async {
    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _requestStay() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Stay request sent to ${hostData['name']}!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _messageHost() {
    Navigator.pushNamed(context, '/messaging-interface');
  }

  void _shareProfile() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile link copied to clipboard',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _reportProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Report Profile',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to report this profile? Our team will review it within 24 hours.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Profile reported. Thank you for keeping our community safe.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(4.w),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Report',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: _buildLoadingSkeleton(),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHostHeader(),
                SizedBox(height: 2.h),
                _buildStatsSection(),
                SizedBox(height: 3.h),
                _buildAboutSection(),
                SizedBox(height: 3.h),
                AmenitiesGrid(
                  amenities: (hostData['amenities'] as List)
                      .cast<Map<String, dynamic>>(),
                ),
                SizedBox(height: 3.h),
                ReviewsSection(
                  reviews: (hostData['reviews'] as List)
                      .cast<Map<String, dynamic>>(),
                  averageRating: hostData['trustScore'] as double,
                  totalReviews: hostData['totalReviews'] as int,
                ),
                SizedBox(height: 3.h),
                LocationMapSnippet(
                  locationName: hostData['location']['name'] as String,
                  approximateArea:
                      hostData['location']['approximateArea'] as String,
                  latitude: hostData['location']['latitude'] as double,
                  longitude: hostData['location']['longitude'] as double,
                ),
                SizedBox(height: 12.h), // Space for bottom buttons
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: [
        Container(
          height: 35.h,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 8.w,
                      backgroundColor: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 2.h,
                            width: 40.w,
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            height: 1.5.h,
                            width: 25.w,
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 20.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 35.h,
      pinned: true,
      backgroundColor: AppTheme.lightTheme.cardColor,
      leading: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 6.w,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: Colors.white,
              size: 6.w,
            ),
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _shareProfile();
                  break;
                case 'report':
                  _reportProfile();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Share Profile',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'flag',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Report Profile',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: PhotoCarousel(
          photos: (hostData['photos'] as List).cast<String>(),
        ),
      ),
    );
  }

  Widget _buildHostHeader() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 8.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
                child: CustomImageWidget(
                  imageUrl: hostData['avatar'] as String,
                  width: 16.w,
                  height: 16.w,
                  fit: BoxFit.cover,
                ),
              ),
              if (hostData['isVerified'] as bool)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.cardColor,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'verified',
                      color: Colors.white,
                      size: 3.w,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hostData['name'] as String,
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: Colors.amber,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      (hostData['trustScore'] as double).toStringAsFixed(1),
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Trust Score',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Hosting since ${hostData['hostingSince']} • ${hostData['totalReviews']} reviews',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          HostStatsCard(
            title: 'Experience',
            value:
                '${DateTime.now().year - int.parse(hostData['hostingSince'] as String)}+ years',
            iconName: 'timeline',
            iconColor: AppTheme.lightTheme.primaryColor,
          ),
          HostStatsCard(
            title: 'Response',
            value: hostData['responseTime'] as String,
            iconName: 'schedule',
            iconColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
          HostStatsCard(
            title: 'Languages',
            value: '${(hostData['languages'] as List).length}',
            iconName: 'language',
            iconColor: Colors.orange,
          ),
          HostStatsCard(
            title: 'Safety',
            value: (hostData['safetyRating'] as double).toStringAsFixed(1),
            iconName: 'security',
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    final aboutText = hostData['about'] as String;
    final shouldShowExpanded = aboutText.length > 200;
    final displayText = _isExpanded || !shouldShowExpanded
        ? aboutText
        : '${aboutText.substring(0, 200)}...';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About ${hostData['name']}',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              displayText,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            if (shouldShowExpanded) ...[
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Show less' : 'Read more',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: (hostData['languages'] as List).map<Widget>((language) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    language as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: _messageHost,
                icon: CustomIconWidget(
                  iconName: 'message',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
                label: Text(
                  'Message',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _requestStay,
                icon: CustomIconWidget(
                  iconName: 'home',
                  color: Colors.white,
                  size: 5.w,
                ),
                label: Text(
                  'Request Stay',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
