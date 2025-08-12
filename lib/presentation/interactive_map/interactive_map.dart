import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/current_location_button.dart';
import './widgets/map_empty_state.dart';
import './widgets/map_filter_bottom_sheet.dart';
import './widgets/map_layer_toggle.dart';
import './widgets/map_loading_skeleton.dart';
import './widgets/map_marker_preview_card.dart';
import './widgets/map_search_bar.dart';

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _showHosts = true;
  bool _showHangouts = true;
  bool _showTravelers = true;
  bool _isLocationLoading = false;
  bool _showEmptyState = false;
  bool _isListView = false;

  Map<String, dynamic>? _selectedMarker;
  int _currentNavIndex = 1;

  Map<String, dynamic> _currentFilters = {
    'distanceRadius': 10.0,
    'safetyRating': 3,
    'activityType': 'All',
    'availableOnly': false,
  };

  // Mock data for map markers
  final List<Map<String, dynamic>> _mockHosts = [
    {
      'id': '1',
      'type': 'host',
      'name': 'Sarah Chen',
      'location': 'Downtown, New York',
      'latitude': 40.7589,
      'longitude': -73.9851,
      'rating': 4.8,
      'imageUrl':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop',
      'description':
          'Cozy apartment in the heart of Manhattan. Perfect for digital nomads!',
      'isAvailable': true,
      'safetyRating': 5,
      'hostingHistory': 47,
    },
    {
      'id': '2',
      'type': 'host',
      'name': 'Marcus Rodriguez',
      'location': 'Brooklyn Heights, NY',
      'latitude': 40.6962,
      'longitude': -73.9961,
      'rating': 4.6,
      'imageUrl':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
      'description':
          'Spacious loft with amazing city views. Great for remote work.',
      'isAvailable': false,
      'safetyRating': 4,
      'hostingHistory': 23,
    },
    {
      'id': '3',
      'type': 'host',
      'name': 'Emma Thompson',
      'location': 'SoHo, New York',
      'latitude': 40.7230,
      'longitude': -74.0030,
      'rating': 4.9,
      'imageUrl':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop',
      'description': 'Artistic studio apartment in trendy SoHo neighborhood.',
      'isAvailable': true,
      'safetyRating': 5,
      'hostingHistory': 62,
    },
  ];

  final List<Map<String, dynamic>> _mockHangouts = [
    {
      'id': '1',
      'type': 'hangout',
      'name': 'Central Park Photography Walk',
      'location': 'Central Park, NY',
      'latitude': 40.7829,
      'longitude': -73.9654,
      'rating': 4.7,
      'imageUrl':
          'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=400&fit=crop',
      'description':
          'Join us for a scenic photography walk through Central Park!',
      'isAvailable': true,
      'participants': 8,
      'maxParticipants': 15,
      'activityType': 'Photography',
      'startTime': '2025-08-12T10:00:00Z',
    },
    {
      'id': '2',
      'type': 'hangout',
      'name': 'Food Tour in Chinatown',
      'location': 'Chinatown, NY',
      'latitude': 40.7158,
      'longitude': -73.9970,
      'rating': 4.5,
      'imageUrl':
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=400&fit=crop',
      'description':
          'Explore authentic Chinese cuisine with fellow food lovers.',
      'isAvailable': true,
      'participants': 6,
      'maxParticipants': 12,
      'activityType': 'Food & Drink',
      'startTime': '2025-08-12T18:00:00Z',
    },
    {
      'id': '3',
      'type': 'hangout',
      'name': 'Brooklyn Bridge Sunset',
      'location': 'Brooklyn Bridge, NY',
      'latitude': 40.7061,
      'longitude': -73.9969,
      'rating': 4.8,
      'imageUrl':
          'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=400&h=400&fit=crop',
      'description': 'Watch the sunset from the iconic Brooklyn Bridge.',
      'isAvailable': false,
      'participants': 20,
      'maxParticipants': 20,
      'activityType': 'Sightseeing',
      'startTime': '2025-08-12T19:30:00Z',
    },
  ];

  final List<Map<String, dynamic>> _mockTravelers = [
    {
      'id': '1',
      'type': 'traveler',
      'name': 'Alex Kim',
      'location': 'Times Square, NY',
      'latitude': 40.7580,
      'longitude': -73.9855,
      'rating': 4.6,
      'imageUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop',
      'description':
          'Digital nomad exploring NYC. Looking for co-working buddies!',
      'isAvailable': true,
      'travelStyle': 'Digital Nomad',
      'interests': ['Technology', 'Photography', 'Food'],
    },
    {
      'id': '2',
      'type': 'traveler',
      'name': 'Luna Martinez',
      'location': 'Greenwich Village, NY',
      'latitude': 40.7335,
      'longitude': -74.0027,
      'rating': 4.4,
      'imageUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop',
      'description':
          'Solo traveler interested in art galleries and local culture.',
      'isAvailable': true,
      'travelStyle': 'Cultural Explorer',
      'interests': ['Art', 'Culture', 'Museums'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Simulate map loading
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onToggleLayer(String layer) {
    setState(() {
      switch (layer) {
        case 'hosts':
          _showHosts = !_showHosts;
          break;
        case 'hangouts':
          _showHangouts = !_showHangouts;
          break;
        case 'travelers':
          _showTravelers = !_showTravelers;
          break;
      }
      _checkEmptyState();
    });
  }

  void _onSearch(String query) {
    // Simulate search functionality
    if (kDebugMode) {
      print('Searching for: $query');
    }
    // In a real app, this would filter markers based on location search
    _checkEmptyState();
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MapFilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersChanged: _onFiltersChanged,
      ),
    );
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _checkEmptyState();
    });
  }

  void _checkEmptyState() {
    final hasVisibleMarkers = (_showHosts && _getFilteredHosts().isNotEmpty) ||
        (_showHangouts && _getFilteredHangouts().isNotEmpty) ||
        (_showTravelers && _getFilteredTravelers().isNotEmpty);

    setState(() {
      _showEmptyState = !hasVisibleMarkers;
    });
  }

  List<Map<String, dynamic>> _getFilteredHosts() {
    return _mockHosts.where((host) {
      if (_currentFilters['availableOnly'] == true && !host['isAvailable']) {
        return false;
      }
      if (host['safetyRating'] < _currentFilters['safetyRating']) {
        return false;
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _getFilteredHangouts() {
    return _mockHangouts.where((hangout) {
      if (_currentFilters['availableOnly'] == true && !hangout['isAvailable']) {
        return false;
      }
      if (_currentFilters['activityType'] != 'All' &&
          hangout['activityType'] != _currentFilters['activityType']) {
        return false;
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _getFilteredTravelers() {
    return _mockTravelers.where((traveler) {
      if (_currentFilters['availableOnly'] == true &&
          !traveler['isAvailable']) {
        return false;
      }
      return true;
    }).toList();
  }

  void _onMarkerTap(Map<String, dynamic> marker) {
    setState(() {
      _selectedMarker = marker;
    });
  }

  void _onClosePreview() {
    setState(() {
      _selectedMarker = null;
    });
  }

  void _onViewDetails() {
    if (_selectedMarker != null) {
      final String type = _selectedMarker!['type'];
      switch (type) {
        case 'host':
          Navigator.pushNamed(context, AppRoutes.hostProfileDetail);
          break;
        case 'hangout':
          Navigator.pushNamed(context, AppRoutes.hangoutDetail);
          break;
        case 'traveler':
          Navigator.pushNamed(context, AppRoutes.userProfile);
          break;
      }
    }
  }

  Future<void> _onCurrentLocationPressed() async {
    setState(() {
      _isLocationLoading = true;
    });

    // Simulate getting current location
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLocationLoading = false;
      });

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Centered on your location'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: 25.h,
            left: 4.w,
            right: 4.w,
          ),
        ),
      );
    }
  }

  void _onExpandSearch() {
    // Simulate expanding search area
    setState(() {
      _showEmptyState = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Search area expanded'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 25.h,
          left: 4.w,
          right: 4.w,
        ),
      ),
    );
  }

  void _onAdjustFilters() {
    _onFilterTap();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
        break;
      case 1:
        // Already on Map
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.messagingInterface);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.hangoutsList);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.userProfile);
        break;
    }
  }

  void _onToggleView() {
    setState(() {
      _isListView = !_isListView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Interactive Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isListView ? Icons.map : Icons.list),
            onPressed: _onToggleView,
            tooltip: _isListView ? 'Map View' : 'List View',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            if (_isListView) _buildListView() else _buildMapContent(),

            // Marker preview card
            if (_selectedMarker != null)
              MapMarkerPreviewCard(
                markerData: _selectedMarker!,
                onViewDetails: _onViewDetails,
                onClose: _onClosePreview,
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentNavIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildMapContent() {
    return Stack(
      children: [
        // Map container
        if (_isLoading)
          const MapLoadingSkeleton()
        else if (_showEmptyState)
          MapEmptyState(
            message:
                'Try expanding your search area or adjusting your filters to find more results.',
            onExpandSearch: _onExpandSearch,
            onAdjustFilters: _onAdjustFilters,
          )
        else
          _buildMapView(),

        // Search bar
        if (!_isLoading)
          MapSearchBar(
            onSearch: _onSearch,
            onFilterTap: _onFilterTap,
          ),

        // Layer toggle buttons
        if (!_isLoading && !_showEmptyState)
          MapLayerToggle(
            showHosts: _showHosts,
            showHangouts: _showHangouts,
            showTravelers: _showTravelers,
            onToggleLayer: _onToggleLayer,
          ),

        // Current location button
        if (!_isLoading && !_showEmptyState)
          CurrentLocationButton(
            onPressed: _onCurrentLocationPressed,
            isLoading: _isLocationLoading,
          ),
      ],
    );
  }

  Widget _buildListView() {
    final allItems = [
      ..._getFilteredHosts(),
      ..._getFilteredHangouts(),
      ..._getFilteredTravelers(),
    ];

    if (allItems.isEmpty) {
      return MapEmptyState(
        message: 'No items match your current filters.',
        onExpandSearch: _onExpandSearch,
        onAdjustFilters: _onAdjustFilters,
      );
    }

    return Column(
      children: [
        // Search bar for list view
        MapSearchBar(
          onSearch: _onSearch,
          onFilterTap: _onFilterTap,
        ),

        // Layer toggles
        MapLayerToggle(
          showHosts: _showHosts,
          showHangouts: _showHangouts,
          showTravelers: _showTravelers,
          onToggleLayer: _onToggleLayer,
        ),

        // List content
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              final item = allItems[index];
              return _buildListItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(Map<String, dynamic> item) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item['imageUrl']),
          onBackgroundImageError: (exception, stackTrace) {
            // Handle image loading errors gracefully
          },
        ),
        title: Text(item['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['location']),
            if (item['rating'] != null)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 1.w),
                  Text('${item['rating']}'),
                ],
              ),
          ],
        ),
        trailing: Icon(
          _getMarkerIconData(item['type']),
          color: _getMarkerColor(item['type']),
        ),
        onTap: () => _onMarkerTap(item),
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.lightTheme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Map background pattern
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/no-image.jpg'),
                fit: BoxFit.cover,
                opacity: 0.1,
                onError: (exception, stackTrace) {
                  // Handle missing asset gracefully
                },
              ),
            ),
          ),

          // Render markers
          ..._buildMarkers(),
        ],
      ),
    );
  }

  List<Widget> _buildMarkers() {
    final List<Widget> markers = [];

    // Add host markers
    if (_showHosts) {
      for (final host in _getFilteredHosts()) {
        markers.add(_buildMarker(host, AppTheme.lightTheme.primaryColor));
      }
    }

    // Add hangout markers
    if (_showHangouts) {
      for (final hangout in _getFilteredHangouts()) {
        markers.add(
            _buildMarker(hangout, AppTheme.lightTheme.colorScheme.tertiary));
      }
    }

    // Add traveler markers
    if (_showTravelers) {
      for (final traveler in _getFilteredTravelers()) {
        markers.add(_buildMarker(traveler, AppTheme.warningLight));
      }
    }

    return markers;
  }

  Widget _buildMarker(Map<String, dynamic> markerData, Color color) {
    // Calculate position based on mock coordinates
    final double normalizedLat = (markerData['latitude'] - 40.7000) / 0.1000;
    final double normalizedLng = (markerData['longitude'] + 74.0000) / 0.1000;

    final double top = 20.h + (normalizedLat * 40.h);
    final double left = 10.w + (normalizedLng * 70.w);

    return Positioned(
      top: top.clamp(15.h, 70.h),
      left: left.clamp(5.w, 85.w),
      child: GestureDetector(
        onTap: () => _onMarkerTap(markerData),
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: _getMarkerIcon(markerData['type']),
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  String _getMarkerIcon(String type) {
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

  IconData _getMarkerIconData(String type) {
    switch (type.toLowerCase()) {
      case 'host':
        return Icons.person;
      case 'hangout':
        return Icons.group;
      case 'traveler':
        return Icons.explore;
      default:
        return Icons.place;
    }
  }

  Color _getMarkerColor(String type) {
    switch (type.toLowerCase()) {
      case 'host':
        return AppTheme.lightTheme.primaryColor;
      case 'hangout':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'traveler':
        return AppTheme.warningLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
