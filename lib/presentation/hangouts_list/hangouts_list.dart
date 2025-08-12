import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/hangout_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/skeleton_card_widget.dart';

class HangoutsList extends StatefulWidget {
  const HangoutsList({Key? key}) : super(key: key);

  @override
  State<HangoutsList> createState() => _HangoutsListState();
}

class _HangoutsListState extends State<HangoutsList>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  String _searchQuery = '';
  List<String> _selectedFilters = ['all'];
  bool _isLoading = false;
  bool _isMapView = false;
  bool _isRefreshing = false;
  bool _hasMoreData = true;
  int _currentPage = 1;

  // Mock data for hangouts
  final List<Map<String, dynamic>> _allHangouts = [
    {
      "id": 1,
      "title": "Sunset Beach Volleyball & BBQ",
      "description":
          "Join us for an epic beach volleyball session followed by a delicious BBQ. Perfect for meeting new people and enjoying the sunset!",
      "activityType": "Outdoor",
      "image":
          "https://images.pexels.com/photos/1263348/pexels-photo-1263348.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hostName": "Sarah Chen",
      "hostAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "participantCount": 8,
      "maxParticipants": 12,
      "distance": "2.3 km",
      "startTime": "2025-08-11T18:30:00.000Z",
      "location": {"lat": 37.7749, "lng": -122.4194},
      "tags": ["beach", "volleyball", "bbq", "sunset"]
    },
    {
      "id": 2,
      "title": "Coffee & Code - Remote Work Session",
      "description":
          "Productive co-working session at a cozy café. Bring your laptop and let's get some work done together while networking.",
      "activityType": "Work",
      "image":
          "https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hostName": "Marcus Johnson",
      "hostAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "participantCount": 4,
      "maxParticipants": 8,
      "distance": "0.8 km",
      "startTime": "2025-08-11T17:30:00.000Z",
      "location": {"lat": 37.7849, "lng": -122.4094},
      "tags": ["coffee", "work", "networking", "laptop"]
    },
    {
      "id": 3,
      "title": "Night Market Food Tour",
      "description":
          "Explore the best street food in Chinatown! We'll visit 5 different stalls and try authentic local dishes together.",
      "activityType": "Food & Drink",
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hostName": "Li Wei",
      "hostAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "participantCount": 6,
      "maxParticipants": 10,
      "distance": "3.1 km",
      "startTime": "2025-08-11T19:00:00.000Z",
      "location": {"lat": 37.7949, "lng": -122.4294},
      "tags": ["food", "night market", "chinatown", "street food"]
    },
    {
      "id": 4,
      "title": "Museum Hop & Art Discussion",
      "description":
          "Visit the contemporary art museum and discuss our favorite pieces over coffee. Great for art enthusiasts and curious minds!",
      "activityType": "Culture",
      "image":
          "https://images.pexels.com/photos/1839919/pexels-photo-1839919.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hostName": "Emma Rodriguez",
      "hostAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "participantCount": 3,
      "maxParticipants": 6,
      "distance": "1.5 km",
      "startTime": "2025-08-12T14:00:00.000Z",
      "location": {"lat": 37.7649, "lng": -122.4394},
      "tags": ["museum", "art", "culture", "discussion"]
    },
    {
      "id": 5,
      "title": "Rooftop Bar Networking",
      "description":
          "Professional networking event at a trendy rooftop bar. Perfect for digital nomads and entrepreneurs to connect over cocktails.",
      "activityType": "Nightlife",
      "image":
          "https://images.pexels.com/photos/1267320/pexels-photo-1267320.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hostName": "David Park",
      "hostAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "participantCount": 12,
      "maxParticipants": 20,
      "distance": "2.7 km",
      "startTime": "2025-08-11T20:00:00.000Z",
      "location": {"lat": 37.7549, "lng": -122.4494},
      "tags": ["networking", "rooftop", "cocktails", "professionals"]
    },
    {
      "id": 6,
      "title": "Morning Yoga in the Park",
      "description":
          "Start your day with peaceful yoga session in Golden Gate Park. All levels welcome, mats provided!",
      "activityType": "Outdoor",
      "image":
          "https://images.pexels.com/photos/1051838/pexels-photo-1051838.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hostName": "Priya Sharma",
      "hostAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "participantCount": 7,
      "maxParticipants": 15,
      "distance": "4.2 km",
      "startTime": "2025-08-12T07:30:00.000Z",
      "location": {"lat": 37.7749, "lng": -122.4594},
      "tags": ["yoga", "morning", "park", "wellness"]
    }
  ];

  List<Map<String, dynamic>> _filteredHangouts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _filteredHangouts = List.from(_allHangouts);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _applyFilters();
        });
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (!_hasMoreData || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading more data
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentPage++;
          // In real app, this would fetch more data from API
          if (_currentPage >= 3) {
            _hasMoreData = false;
          }
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _currentPage = 1;
        _hasMoreData = true;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allHangouts);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((hangout) {
        final title = (hangout['title'] as String).toLowerCase();
        final description = (hangout['description'] as String).toLowerCase();
        final tags = (hangout['tags'] as List).join(' ').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            description.contains(query) ||
            tags.contains(query);
      }).toList();
    }

    // Apply category filters
    if (!_selectedFilters.contains('all')) {
      filtered = filtered.where((hangout) {
        final activityType = (hangout['activityType'] as String).toLowerCase();

        for (String filter in _selectedFilters) {
          switch (filter) {
            case 'food':
              if (activityType.contains('food') ||
                  activityType.contains('drink')) return true;
              break;
            case 'outdoor':
              if (activityType.contains('outdoor')) return true;
              break;
            case 'culture':
              if (activityType.contains('culture')) return true;
              break;
            case 'nightlife':
              if (activityType.contains('nightlife')) return true;
              break;
            case 'sports':
              if (activityType.contains('sports')) return true;
              break;
            case 'work':
              if (activityType.contains('work')) return true;
              break;
            case 'urgent':
              final startTime = DateTime.parse(hangout['startTime'] as String);
              final now = DateTime.now();
              final difference = startTime.difference(now);
              if (difference.inMinutes <= 60 && difference.inMinutes > 0)
                return true;
              break;
          }
        }
        return false;
      }).toList();
    }

    setState(() {
      _filteredHangouts = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _onFilterToggle(String filter) {
    setState(() {
      if (filter == 'all') {
        _selectedFilters = ['all'];
      } else {
        _selectedFilters.remove('all');
        if (_selectedFilters.contains(filter)) {
          _selectedFilters.remove(filter);
        } else {
          _selectedFilters.add(filter);
        }

        if (_selectedFilters.isEmpty) {
          _selectedFilters = ['all'];
        }
      }
    });
    _applyFilters();
  }

  void _onClearSearch() {
    setState(() {
      _searchQuery = '';
    });
    _applyFilters();
  }

  void _toggleMapView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  void _onHangoutTap(Map<String, dynamic> hangout) {
    // Navigate to hangout detail screen
    Navigator.pushNamed(context, AppRoutes.hangoutDetail);
  }

  void _onJoinRequest(Map<String, dynamic> hangout) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Join request sent for "${hangout['title']}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      ),
    );
  }

  void _onCreateHangout() {
    Navigator.pushNamed(context, AppRoutes.hangoutDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Hangouts',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleMapView,
            icon: CustomIconWidget(
              iconName: _isMapView ? 'list' : 'map',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: _isMapView ? 'List View' : 'Map View',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/user-profile');
            },
            icon: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Nearby'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: _isMapView ? _buildMapView() : _buildListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onCreateHangout,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Create Hangout',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildNearbyTab(),
        _buildFollowingTab(),
      ],
    );
  }

  Widget _buildNearbyTab() {
    return Column(
      children: [
        SearchBarWidget(
          searchQuery: _searchQuery,
          onSearchChanged: _onSearchChanged,
          onClearSearch: _onClearSearch,
        ),
        FilterChipsWidget(
          selectedFilters: _selectedFilters,
          onFilterToggle: _onFilterToggle,
        ),
        Expanded(
          child: _isLoading && _filteredHangouts.isEmpty
              ? _buildSkeletonList()
              : _filteredHangouts.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            _filteredHangouts.length + (_hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= _filteredHangouts.length) {
                            return _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : const SizedBox.shrink();
                          }

                          final hangout = _filteredHangouts[index];
                          return HangoutCardWidget(
                            hangout: hangout,
                            onTap: () => _onHangoutTap(hangout),
                            onJoinRequest: () => _onJoinRequest(hangout),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildFollowingTab() {
    return Column(
      children: [
        SearchBarWidget(
          searchQuery: _searchQuery,
          onSearchChanged: _onSearchChanged,
          onClearSearch: _onClearSearch,
        ),
        Expanded(
          child: EmptyStateWidget(
            title: 'No Following Yet',
            subtitle:
                'Start following other travelers to see their hangouts here',
            buttonText: 'Discover Travelers',
            iconName: 'people',
            onButtonPressed: () {
              Navigator.pushNamed(context, '/discover-travelers');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const SkeletonCardWidget(),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty) {
      return EmptyStateWidget(
        title: 'No Results Found',
        subtitle: 'Try adjusting your search or filters to find hangouts',
        buttonText: 'Clear Filters',
        iconName: 'search_off',
        onButtonPressed: () {
          setState(() {
            _searchQuery = '';
            _selectedFilters = ['all'];
          });
          _applyFilters();
        },
      );
    }

    return EmptyStateWidget(
      title: 'No Hangouts Nearby',
      subtitle:
          'Be the first to create a hangout in your area and start connecting with fellow travelers',
      buttonText: 'Create First Hangout',
      iconName: 'location_on',
      onButtonPressed: _onCreateHangout,
    );
  }

  Widget _buildMapView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'map',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 64,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Interactive Map View',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Map integration with clustering markers\nwould be implemented here',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Map controls
          Positioned(
            top: 2.h,
            left: 4.w,
            right: 4.w,
            child: SearchBarWidget(
              searchQuery: _searchQuery,
              onSearchChanged: _onSearchChanged,
              onClearSearch: _onClearSearch,
            ),
          ),

          Positioned(
            top: 12.h,
            left: 0,
            right: 0,
            child: FilterChipsWidget(
              selectedFilters: _selectedFilters,
              onFilterToggle: _onFilterToggle,
            ),
          ),
        ],
      ),
    );
  }
}
