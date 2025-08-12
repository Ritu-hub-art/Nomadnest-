import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class HangoutDetail extends StatefulWidget {
  const HangoutDetail({Key? key}) : super(key: key);

  @override
  State<HangoutDetail> createState() => _HangoutDetailState();
}

class _HangoutDetailState extends State<HangoutDetail> {
  bool _isJoined = false;
  bool _isBookmarked = false;
  bool _isLoading = false;

  // Mock hangout data - In real app, this would come from arguments or API
  final Map<String, dynamic> _hangoutData = {
    "id": 1,
    "title": "Sunset Beach Volleyball & BBQ",
    "description":
        "Join us for an epic beach volleyball session followed by a delicious BBQ. Perfect for meeting new people and enjoying the sunset! We'll start with some warm-up games, then play a few competitive matches. After working up an appetite, we'll fire up the grill for some amazing food. All skill levels are welcome - it's all about having fun and making connections with fellow travelers.",
    "activityType": "Outdoor",
    "image":
        "https://images.pexels.com/photos/1263348/pexels-photo-1263348.jpeg?auto=compress&cs=tinysrgb&w=800",
    "hostName": "Sarah Chen",
    "hostAvatar":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
    "hostBio":
        "Digital nomad and beach volleyball enthusiast. I love bringing people together for active and fun experiences!",
    "participantCount": 8,
    "maxParticipants": 12,
    "distance": "2.3 km",
    "startTime": "2025-08-11T18:30:00.000Z",
    "endTime": "2025-08-11T22:00:00.000Z",
    "location": {
      "name": "Santa Monica Beach",
      "address": "Santa Monica Beach, CA 90401",
      "lat": 37.7749,
      "lng": -122.4194
    },
    "tags": ["beach", "volleyball", "bbq", "sunset"],
    "price": 15.00,
    "priceIncludes": ["Equipment rental", "BBQ food", "Drinks"],
    "whatToBring": ["Sunscreen", "Comfortable clothes", "Water bottle"],
    "meetingPoint": "Volleyball courts near Pier 3",
    "cancellationPolicy": "Free cancellation up to 2 hours before start time",
    "participants": [
      {
        "name": "Alex Kim",
        "avatar":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
        "isHost": false
      },
      {
        "name": "Maria Rodriguez",
        "avatar":
            "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
        "isHost": false
      },
      {
        "name": "David Park",
        "avatar":
            "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
        "isHost": false
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    final startTime = DateTime.parse(_hangoutData['startTime'] as String);
    final endTime = DateTime.parse(_hangoutData['endTime'] as String);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Hero Image with App Bar
          SliverAppBar(
            expandedHeight: 30.h,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.lightTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CustomImageWidget(
                    imageUrl: _hangoutData['image'] as String,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                },
                icon: CustomIconWidget(
                  iconName: _isBookmarked ? 'bookmark' : 'bookmark_border',
                  color: Colors.white,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Share functionality
                },
                icon: const CustomIconWidget(
                  iconName: 'share',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Activity Type
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _hangoutData['title'] as String,
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _hangoutData['activityType'] as String,
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Host Info
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.hostProfileDetail);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                              _hangoutData['hostAvatar'] as String),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hosted by ${_hangoutData['hostName']}',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _hangoutData['hostBio'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        CustomIconWidget(
                          iconName: 'chevron_right',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Quick Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'participants',
                          '${_hangoutData['participantCount']}/${_hangoutData['maxParticipants']}',
                          'Participants',
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildStatCard(
                          'location_on',
                          _hangoutData['distance'] as String,
                          'Distance',
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildStatCard(
                          'schedule',
                          '${_formatTime(startTime)} - ${_formatTime(endTime)}',
                          'Duration',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Description
                  Text(
                    'About this hangout',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _hangoutData['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 4.h),

                  // Location
                  Text(
                    'Location',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.interactiveMap);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'location_on',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (_hangoutData['location'] as Map)['name']
                                      as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  (_hangoutData['location'] as Map)['address']
                                      as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'chevron_right',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Participants
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Participants (${_hangoutData['participantCount']})',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.userProfile);
                        },
                        child: Text('View All'),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 8.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (_hangoutData['participants'] as List).length,
                      itemBuilder: (context, index) {
                        final participant =
                            (_hangoutData['participants'] as List)[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.userProfile);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 3.w),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(
                                      participant['avatar'] as String),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  participant['name'] as String,
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10.h), // Extra space for buttons
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Message Host Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.messagingInterface);
                  },
                  icon: const CustomIconWidget(
                    iconName: 'message',
                    color: null,
                    size: 20,
                  ),
                  label: const Text('Message Host'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              // Join Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleJoinToggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isJoined
                        ? AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest
                        : AppTheme.lightTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _isJoined
                              ? 'Leave Hangout'
                              : 'Join Hangout - \$${_hangoutData['price']}',
                          style: TextStyle(
                            color: _isJoined
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String iconName, String value, String label) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12
        ? hour - 12
        : hour == 0
            ? 12
            : hour;
    return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _handleJoinToggle() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isJoined = !_isJoined;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isJoined
                ? 'Successfully joined the hangout!'
                : 'You have left the hangout',
          ),
          backgroundColor: _isJoined
              ? AppTheme.lightTheme.colorScheme.tertiary
              : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        ),
      );
    }
  }
}
