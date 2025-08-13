import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/featured_host_card_widget.dart';
import './widgets/happening_now_card_widget.dart';
import './widgets/hero_welcome_widget.dart';
import './widgets/quick_access_tile_widget.dart';
import './widgets/safety_companion_button_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  // Mock data for the dashboard
  final Map<String, dynamic> _userInfo = {
    "name": "Alex Chen",
    "location": "Barcelona, Spain",
    "weather": "24°C Sunny",
  };

  final List<Map<String, dynamic>> _happeningNow = [
    {
      "id": 1,
      "title": "Coffee & Co-working Session",
      "description":
          "Join us for a productive morning at a local café with great WiFi and amazing coffee. Perfect for digital nomads!",
      "hostName": "Maria Rodriguez",
      "hostImage":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
      "location": "Café Central, Gothic Quarter",
      "time": "10:30 AM",
      "participants": 4,
      "maxParticipants": 8,
    },
    {
      "id": 2,
      "title": "Evening Tapas Tour",
      "description":
          "Discover the best local tapas spots with fellow travelers. Experience authentic Spanish cuisine and culture.",
      "hostName": "Carlos Mendez",
      "hostImage":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "location": "El Born District",
      "time": "7:00 PM",
      "participants": 6,
      "maxParticipants": 10,
    },
    {
      "id": 3,
      "title": "Beach Volleyball Game",
      "description":
          "Fun beach volleyball session at Barceloneta Beach. All skill levels welcome! Bring your energy and sunscreen.",
      "hostName": "Sophie Laurent",
      "hostImage":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "location": "Barceloneta Beach",
      "time": "4:00 PM",
      "participants": 8,
      "maxParticipants": 12,
    },
  ];

  final List<Map<String, dynamic>> _featuredHosts = [
    {
      "id": 1,
      "name": "Isabella Martinez",
      "location": "Gràcia, Barcelona",
      "bio":
          "Local artist and travel enthusiast. Love sharing Barcelona's hidden gems with fellow adventurers.",
      "profileImage":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.9,
      "reviewCount": 127,
      "hostingYears": 3,
      "isOnline": true,
    },
    {
      "id": 2,
      "name": "David Thompson",
      "location": "Eixample, Barcelona",
      "bio":
          "Digital nomad and photographer. My place is perfect for remote workers with high-speed internet and quiet workspace.",
      "profileImage":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.8,
      "reviewCount": 89,
      "hostingYears": 2,
      "isOnline": false,
    },
    {
      "id": 3,
      "name": "Elena Popov",
      "location": "Poble Sec, Barcelona",
      "bio":
          "Yoga instructor and wellness coach. Offering a peaceful space near Montjuïc Park for mindful travelers.",
      "profileImage":
          "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 5.0,
      "reviewCount": 156,
      "hostingYears": 4,
      "isOnline": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different screens based on tab selection
    switch (index) {
      case 0:
        // Already on Home Dashboard
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.interactiveMap);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.hangoutsList);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.cityGuideDetail);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.userProfile);
        break;
    }
  }

  void _navigateToQuickAccess(String feature) {
    switch (feature) {
      case 'Find Host':
        Navigator.pushNamed(context, AppRoutes.hostProfileDetail);
        break;
      case 'Join Hangout':
        Navigator.pushNamed(context, AppRoutes.hangoutsList);
        break;
      case 'City Guides':
        Navigator.pushNamed(context, AppRoutes.cityGuideDetail);
        break;
      case 'Top Travelers':
        Navigator.pushNamed(context, AppRoutes.userProfile);
        break;
    }
  }

  void _joinHangout(Map<String, dynamic> hangout) {
    Navigator.pushNamed(context, AppRoutes.hangoutDetail);
  }

  void _viewHostProfile(Map<String, dynamic> host) {
    Navigator.pushNamed(context, AppRoutes.hostProfileDetail);
  }

  void _openSafetyCompanion() {
    Navigator.pushNamed(context, AppRoutes.safetyCompanion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.lightTheme.primaryColor,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 0,
                  floating: true,
                  pinned: false,
                  backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: 2.h),
                      // Hero Welcome Section
                      HeroWelcomeWidget(
                        userName: _userInfo['name'] as String,
                        currentLocation: _userInfo['location'] as String,
                        weatherInfo: _userInfo['weather'] as String,
                      ),
                      SizedBox(height: 4.h),

                      // Quick Access Tiles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuickAccessTileWidget(
                            title: 'Find Host',
                            description: 'Discover verified local hosts',
                            iconName: 'home',
                            backgroundColor: const Color(0xFF6366F1),
                            onTap: () => _navigateToQuickAccess('Find Host'),
                          ),
                          QuickAccessTileWidget(
                            title: 'Join Hangout',
                            description: 'Connect with travelers',
                            iconName: 'group',
                            backgroundColor: const Color(0xFF10B981),
                            onTap: () => _navigateToQuickAccess('Join Hangout'),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuickAccessTileWidget(
                            title: 'City Guides',
                            description: 'Explore local insights',
                            iconName: 'map',
                            backgroundColor: const Color(0xFFF59E0B),
                            onTap: () => _navigateToQuickAccess('City Guides'),
                          ),
                          QuickAccessTileWidget(
                            title: 'Top Travelers',
                            description: 'Meet fellow nomads',
                            iconName: 'star',
                            backgroundColor: const Color(0xFFEF4444),
                            onTap: () =>
                                _navigateToQuickAccess('Top Travelers'),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),

                      // Happening Now Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Happening Now',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/hangouts-list'),
                            child: Text(
                              'View All',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // Happening Now Cards
                      ...(_happeningNow
                          .take(2)
                          .map((hangout) => HappeningNowCardWidget(
                                hangout: hangout,
                                onJoin: () => _joinHangout(hangout),
                              ))
                          .toList()),

                      SizedBox(height: 4.h),

                      // Featured Hosts Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Featured Hosts',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                                context, '/host-profile-detail'),
                            child: Text(
                              'View All',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // Featured Hosts Carousel
                      SizedBox(
                        height: 35.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: _featuredHosts.length,
                          itemBuilder: (context, index) {
                            return FeaturedHostCardWidget(
                              host: _featuredHosts[index],
                              onTap: () =>
                                  _viewHostProfile(_featuredHosts[index]),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                          height: 15.h), // Extra space for bottom navigation
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // Safety Companion Floating Button
          SafetyCompanionButtonWidget(
            onTap: _openSafetyCompanion,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.cardColor,
          selectedItemColor: AppTheme.lightTheme.primaryColor,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          selectedLabelStyle:
              AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
          ),
          unselectedLabelStyle:
              AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 10.sp,
          ),
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'home',
                color: _selectedIndex == 0
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'map',
                    color: _selectedIndex == 1
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'group',
                    color: _selectedIndex == 2
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(0.5.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(1.5.w),
                      ),
                      child: Text(
                        '3',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Hangouts',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'book',
                color: _selectedIndex == 3
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              label: 'Guides',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _selectedIndex == 4
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
