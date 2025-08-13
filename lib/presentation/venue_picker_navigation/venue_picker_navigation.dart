import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import '../venue_picker_navigation/widgets/venue_search_bar_widget.dart';
import '../venue_picker_navigation/widgets/recent_venues_widget.dart';
import '../venue_picker_navigation/widgets/venue_map_view_widget.dart';
import '../venue_picker_navigation/widgets/venue_details_bottom_sheet_widget.dart';
import '../venue_picker_navigation/widgets/navigation_panel_widget.dart';
import '../venue_picker_navigation/widgets/location_permission_widget.dart';
import '../../services/venue_service.dart';
import '../../services/location_service.dart';
import '../../widgets/custom_error_widget.dart';

class VenuePickerNavigation extends StatefulWidget {
  const VenuePickerNavigation({super.key});

  @override
  State<VenuePickerNavigation> createState() => _VenuePickerNavigationState();
}

class _VenuePickerNavigationState extends State<VenuePickerNavigation>
    with TickerProviderStateMixin {
  late TabController _tabController;
  GoogleMapController? _mapController;

  // State variables
  Position? _currentPosition;
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _recentVenues = [];
  Map<String, dynamic>? _selectedVenue;
  Map<String, dynamic>? _selectedVenueDetails;
  bool _isLoading = false;
  bool _hasLocationPermission = false;
  String? _error;
  Set<Marker> _mapMarkers = {};

  // Navigation state
  bool _showNavigationPanel = false;
  Map<String, dynamic>? _navigationRoute;
  String _navigationMode = 'walking';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeLocation();
    _loadRecentVenues();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      final hasPermission =
          await LocationService.instance.requestLocationPermission();
      setState(() => _hasLocationPermission = hasPermission);

      if (hasPermission) {
        final position = await LocationService.instance.getCurrentLocation();
        if (position != null && mounted) {
          setState(() => _currentPosition = position);
          _performSearch(); // Search nearby venues
        }
      }
    } catch (error) {
      setState(() => _error = 'Location access failed: $error');
    }
  }

  Future<void> _loadRecentVenues() async {
    try {
      final venues = await VenueService.instance.getRecentVenues(limit: 5);
      if (mounted) {
        setState(() => _recentVenues = venues);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Failed to load recent venues: $error');
      }
    }
  }

  Future<void> _performSearch() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await VenueService.instance.searchVenues(
          query: _searchQuery, userLocation: _currentPosition, radius: 5000);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _updateMapMarkers();
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Search failed: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _updateMapMarkers() {
    final markers = <Marker>{};

    // Add current location marker
    if (_currentPosition != null) {
      markers.add(Marker(
          markerId: const MarkerId('current_location'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location')));
    }

    // Add venue markers
    for (int i = 0; i < _searchResults.length; i++) {
      final venue = _searchResults[i];
      final location = venue['geometry']['location'];

      markers.add(Marker(
          markerId: MarkerId('venue_$i'),
          position: LatLng(location['lat'], location['lng']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
              title: venue['name'], snippet: venue['formatted_address']),
          onTap: () => _selectVenue(venue)));
    }

    setState(() => _mapMarkers = markers);
  }

  Future<void> _selectVenue(Map<String, dynamic> venue) async {
    setState(() {
      _selectedVenue = venue;
      _isLoading = true;
    });

    try {
      // Get detailed venue information
      final details =
          await VenueService.instance.getVenueDetails(venue['place_id']);
      if (mounted) {
        setState(() => _selectedVenueDetails = details);

        // Save to search history
        await VenueService.instance.saveToSearchHistory(venue);

        // Show venue details bottom sheet
        _showVenueDetailsBottomSheet();
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Failed to get venue details: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showVenueDetailsBottomSheet() {
    if (_selectedVenueDetails == null) return;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => VenueDetailsBottomSheetWidget(
            venue: _selectedVenueDetails!,
            onSelectVenue: _confirmVenueSelection,
            onNavigate: _startNavigation));
  }

  Future<void> _confirmVenueSelection() async {
    if (_selectedVenue == null) return;

    try {
      // Get hangout ID from navigation arguments
      final hangoutId =
          ModalRoute.of(context)?.settings.arguments as String? ?? '';

      if (hangoutId.isNotEmpty) {
        await VenueService.instance.setHangoutVenue(hangoutId, _selectedVenue!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Venue selected successfully!')));
          Navigator.pop(context, _selectedVenue);
        }
      } else {
        throw Exception('No hangout ID provided');
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Failed to select venue: $error');
      }
    }
  }

  Future<void> _startNavigation() async {
    if (_selectedVenue == null || _currentPosition == null) return;

    setState(() {
      _showNavigationPanel = true;
      _isLoading = true;
    });

    try {
      final venue = _selectedVenue!;
      final location = venue['geometry']['location'];

      final route = await VenueService.instance.calculateRoute(
          originLat: _currentPosition!.latitude,
          originLng: _currentPosition!.longitude,
          destLat: location['lat'],
          destLng: location['lng'],
          mode: _navigationMode);

      if (mounted) {
        setState(() => _navigationRoute = route);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Navigation failed: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchQueryChanged(String query) {
    setState(() => _searchQuery = query);

    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchQuery == query && mounted) {
        _performSearch();
      }
    });
  }

  void _onNavigationModeChanged(String mode) {
    setState(() => _navigationMode = mode);
    if (_showNavigationPanel) {
      _startNavigation();
    }
  }

  Widget _buildPermissionDeniedView() {
    return Center(
        child:
            LocationPermissionWidget(onRequestPermission: _initializeLocation));
  }

  Widget _buildSearchTab() {
    return Column(children: [
      // Search Bar
      VenueSearchBarWidget(
          query: _searchQuery,
          onQueryChanged: _onSearchQueryChanged,
          isLoading: _isLoading),

      // Recent Venues Section
      if (_recentVenues.isNotEmpty)
        RecentVenuesWidget(
            venues: _recentVenues, onVenueSelected: _selectVenue),

      // Search Results
      Expanded(
          child: _searchResults.isEmpty
              ? Center(
                  child: Text(
                      _searchQuery.isEmpty
                          ? 'Search for venues or places'
                          : 'No venues found',
                      style: GoogleFonts.inter(
                          fontSize: 16.sp, color: Colors.grey[600])))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemBuilder: (context, index) {
                    final venue = _searchResults[index];
                    return Card(
                        margin: EdgeInsets.only(bottom: 2.h),
                        child: ListTile(
                            title: Text(venue['name'],
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600)),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(venue['formatted_address'],
                                      style:
                                          GoogleFonts.inter(fontSize: 14.sp)),
                                  if (venue['distance'] != null)
                                    Text(
                                        '${venue['distance'].toStringAsFixed(1)} km away',
                                        style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600])),
                                ]),
                            leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(Icons.place, color: Colors.blue)),
                            trailing: venue['rating'] != null
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 16),
                                        SizedBox(width: 1.w),
                                        Text(venue['rating'].toString(),
                                            style: GoogleFonts.inter(
                                                fontSize: 14.sp)),
                                      ])
                                : null,
                            onTap: () => _selectVenue(venue)));
                  })),
    ]);
  }

  Widget _buildMapTab() {
    return VenueMapViewWidget(
        currentPosition: _currentPosition,
        markers: _mapMarkers,
        onMapCreated: (controller) => _mapController = controller,
        onMarkerTapped: _selectVenue);
  }

  Widget _buildNavigationTab() {
    return NavigationPanelWidget(
        currentPosition: _currentPosition,
        selectedVenue: _selectedVenue,
        navigationRoute: _navigationRoute,
        navigationMode: _navigationMode,
        onModeChanged: _onNavigationModeChanged,
        onStartNavigation: _startNavigation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context)),
            title: Text('Venue Picker & Navigation',
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600)),
            bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: 'Search'),
                  Tab(text: 'Map'),
                  Tab(text: 'Navigate'),
                ])),
        body: _error != null
            ? CustomErrorWidget()
            : !_hasLocationPermission
                ? _buildPermissionDeniedView()
                : TabBarView(controller: _tabController, children: [
                    _buildSearchTab(),
                    _buildMapTab(),
                    _buildNavigationTab(),
                  ]));
  }
}
