import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/hangout_service.dart';
import '../../services/location_service.dart';
import '../../services/supabase_service.dart';
import './widgets/live_member_list_widget.dart';
import './widgets/map_controls_widget.dart';
import './widgets/member_info_bottom_sheet_widget.dart';
import './widgets/venue_info_widget.dart';

class InteractiveHangoutMap extends StatefulWidget {
  const InteractiveHangoutMap({super.key});

  @override
  State<InteractiveHangoutMap> createState() => _InteractiveHangoutMapState();
}

class _InteractiveHangoutMapState extends State<InteractiveHangoutMap>
    with TickerProviderStateMixin {
  final LocationService _locationService = LocationService.instance;
  final HangoutService _hangoutService = HangoutService.instance;

  GoogleMapController? _mapController;
  RealtimeChannel? _locationSubscription;
  Timer? _locationRefreshTimer;

  late AnimationController _pulseController;
  late AnimationController _markerController;

  // Data
  String? _hangoutId;
  Map<String, dynamic>? _hangoutDetails;
  List<Map<String, dynamic>> _liveMembers = [];
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  // State
  bool _isLoading = true;
  String? _error;
  bool _showMembersList = true;
  String _mapType = 'normal';
  String _memberFilter = 'all';

  // UI
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _markerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _markerController.dispose();
    _locationSubscription?.unsubscribe();
    _locationRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null && _hangoutId != args) {
      _hangoutId = args;
      _loadHangoutData();
    }
  }

  Future<void> _loadHangoutData() async {
    if (_hangoutId == null) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load hangout details
      final details = await _hangoutService.getHangoutDetails(_hangoutId!);
      if (details == null) {
        setState(() {
          _error = 'Hangout not found';
          _isLoading = false;
        });
        return;
      }

      // Load live member locations
      final liveLocations =
          await _locationService.getHangoutLiveLocations(_hangoutId!);

      setState(() {
        _hangoutDetails = details;
        _liveMembers = liveLocations;
        _isLoading = false;
      });

      // Subscribe to real-time updates
      _subscribeToLocationUpdates();

      // Start periodic refresh
      _startLocationRefreshTimer();

      // Update map markers
      _updateMapMarkers();
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  void _subscribeToLocationUpdates() {
    if (_hangoutId == null) return;

    _locationSubscription?.unsubscribe();

    // Subscribe to real-time location updates
    _locationSubscription = _locationService.subscribeToLocationUpdates(
      hangoutId: _hangoutId!,
      onLocationUpdate: (locationData) {
        // Refresh live members when location updates come in
        _refreshLiveMembers();
      },
    );
  }

  Future<void> _refreshLiveMembers() async {
    if (_hangoutId == null) return;

    try {
      final updatedLocations =
          await _locationService.getHangoutLiveLocations(_hangoutId!);
      if (mounted) {
        setState(() {
          _liveMembers = updatedLocations;
        });
        _updateMapMarkers();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error refreshing live members: $error');
      }
    }
  }

  void _startLocationRefreshTimer() {
    _locationRefreshTimer?.cancel();
    _locationRefreshTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) async {
        if (_hangoutId != null) {
          final updatedLocations =
              await _locationService.getHangoutLiveLocations(_hangoutId!);
          setState(() {
            _liveMembers = updatedLocations;
          });
          _updateMapMarkers();
        }
      },
    );
  }

  void _updateMapMarkers() {
    final newMarkers = <Marker>{};
    final newCircles = <Circle>{};

    // Add venue marker if available
    if (_hangoutDetails?['venue_latitude'] != null &&
        _hangoutDetails?['venue_longitude'] != null) {
      final venueLatLng = LatLng(
        (_hangoutDetails!['venue_latitude'] as num).toDouble(),
        (_hangoutDetails!['venue_longitude'] as num).toDouble(),
      );

      newMarkers.add(
        Marker(
          markerId: const MarkerId('venue'),
          position: venueLatLng,
          infoWindow: InfoWindow(
            title: _hangoutDetails!['venue_name'] ?? 'Meetup Venue',
            snippet: _hangoutDetails!['venue_address'],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    // Add member markers from live location sessions
    final filteredMembers = _getFilteredMembers();
    for (final member in filteredMembers) {
      if (member['current_latitude'] != null &&
          member['current_longitude'] != null) {
        final position = LatLng(
          (member['current_latitude'] as num).toDouble(),
          (member['current_longitude'] as num).toDouble(),
        );

        final userProfile = member['user_profiles'];
        final isCurrentUser = member['user_id'] ==
            SupabaseService.instance.client.auth.currentUser?.id;

        newMarkers.add(
          Marker(
            markerId: MarkerId('member_${member['user_id']}'),
            position: position,
            infoWindow: InfoWindow(
              title: userProfile?['display_name'] ??
                  userProfile?['full_name'] ??
                  'Unknown Member',
              snippet: _getLastUpdateText(member['last_update']),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isCurrentUser
                  ? BitmapDescriptor.hueBlue
                  : BitmapDescriptor.hueGreen,
            ),
            onTap: () => _showMemberBottomSheet(member),
          ),
        );

        // Add accuracy circle for approximate locations
        if (member['accuracy_level'] != 'exact') {
          final radius = _getAccuracyRadius(member['accuracy_level']);
          newCircles.add(
            Circle(
              circleId: CircleId('accuracy_${member['user_id']}'),
              center: position,
              radius: radius,
              strokeWidth: 2,
              strokeColor: Colors.blue.withAlpha(128),
              fillColor: Colors.blue.withAlpha(26),
            ),
          );
        }
      }
    }

    setState(() {
      _markers = newMarkers;
      _circles = newCircles;
    });
  }

  List<Map<String, dynamic>> _getFilteredMembers() {
    switch (_memberFilter) {
      case 'friends':
        // TODO: Implement friends filter based on user relationships
        return _liveMembers;
      case 'host':
        return _liveMembers
            .where((member) => member['user_id'] == _hangoutDetails?['host_id'])
            .toList();
      case 'all':
      default:
        return _liveMembers;
    }
  }

  double _getAccuracyRadius(String? accuracyLevel) {
    switch (accuracyLevel) {
      case 'approximate':
        return 300.0;
      case 'area_only':
        return 500.0;
      default:
        return 50.0;
    }
  }

  String _getLastUpdateText(String? lastUpdate) {
    if (lastUpdate == null) return 'No update';

    try {
      final updateTime = DateTime.parse(lastUpdate);
      final now = DateTime.now();
      final difference = now.difference(updateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else {
        return '${difference.inHours}h ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void _showMemberBottomSheet(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MemberInfoBottomSheetWidget(
        member: member,
        hangoutDetails: _hangoutDetails,
        onNavigateToMember: (memberId) {
          Navigator.pop(context);
          _animateToMember(memberId);
        },
        onSendMessage: (memberId) {
          Navigator.pop(context);
          // TODO: Navigate to messaging interface
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Messaging feature coming soon',
                  style: GoogleFonts.inter()),
            ),
          );
        },
      ),
    );
  }

  void _animateToMember(String memberId) {
    final member = _liveMembers.firstWhere(
      (m) => m['user_id'] == memberId,
      orElse: () => {},
    );

    if (member.isNotEmpty &&
        member['current_latitude'] != null &&
        member['current_longitude'] != null) {
      final position = LatLng(
        (member['current_latitude'] as num).toDouble(),
        (member['current_longitude'] as num).toDouble(),
      );

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 16.0),
        ),
      );
    }
  }

  void _centerOnAllParticipants() async {
    if (_markers.isEmpty) return;

    final bounds = _calculateMapBounds();
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100.0),
    );
  }

  LatLngBounds _calculateMapBounds() {
    final positions = _markers.map((marker) => marker.position).toList();

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (final pos in positions) {
      minLat = minLat < pos.latitude ? minLat : pos.latitude;
      maxLat = maxLat > pos.latitude ? maxLat : pos.latitude;
      minLng = minLng < pos.longitude ? minLng : pos.longitude;
      maxLng = maxLng > pos.longitude ? maxLng : pos.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 6.w),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Hangout Map',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (_hangoutDetails != null)
              Text(
                _hangoutDetails!['title'] ?? 'Untitled Hangout',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showMembersList ? Icons.people : Icons.people_outline,
              color: Colors.black87,
              size: 6.w,
            ),
            onPressed: () {
              setState(() {
                _showMembersList = !_showMembersList;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black87, size: 6.w),
            onSelected: (value) {
              switch (value) {
                case 'recenter':
                  _centerOnAllParticipants();
                  break;
                case 'refresh':
                  _loadHangoutData();
                  break;
                case 'settings':
                  Navigator.pushNamed(
                      context, AppRoutes.liveLocationSharingHub);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'recenter',
                child: Row(
                  children: [
                    Icon(Icons.center_focus_strong, size: 5.w),
                    SizedBox(width: 2.w),
                    Text('Recenter', style: GoogleFonts.inter()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 5.w),
                    SizedBox(width: 2.w),
                    Text('Refresh', style: GoogleFonts.inter()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 5.w),
                    SizedBox(width: 2.w),
                    Text('Settings', style: GoogleFonts.inter()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : Stack(
                  children: [
                    // Google Map
                    GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                        if (_markers.isNotEmpty) {
                          Future.delayed(
                            const Duration(milliseconds: 500),
                            _centerOnAllParticipants,
                          );
                        }
                      },
                      initialCameraPosition: CameraPosition(
                        target: _getInitialPosition(),
                        zoom: 14.0,
                      ),
                      markers: _markers,
                      circles: _circles,
                      mapType: _getMapType(),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    ),

                    // Map Controls
                    Positioned(
                      top: 2.h,
                      right: 4.w,
                      child: MapControlsWidget(
                        selectedMapType: _mapType,
                        onMapTypeChanged: (type) {
                          setState(() {
                            _mapType = type;
                          });
                        },
                        onRecenterPressed: _centerOnAllParticipants,
                        onMyLocationPressed: () async {
                          try {
                            final position =
                                await _locationService.getCurrentLocation();
                            if (position != null) {
                              _mapController?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                        position.latitude, position.longitude),
                                    zoom: 16.0,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              print('Error getting current location: $e');
                            }
                          }
                        },
                      ),
                    ),

                    // Venue Info
                    if (_hangoutDetails?['venue_name'] != null)
                      Positioned(
                        top: 2.h,
                        left: 4.w,
                        child:
                            VenueInfoWidget(hangoutDetails: _hangoutDetails!),
                      ),

                    // Live Members List
                    if (_showMembersList)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LiveMemberListWidget(
                          liveMembers: _getFilteredMembers(),
                          selectedFilter: _memberFilter,
                          onFilterChanged: (filter) {
                            setState(() {
                              _memberFilter = filter;
                            });
                            _updateMapMarkers();
                          },
                          onMemberTap: (memberId) {
                            _animateToMember(memberId);
                          },
                          onMemberInfo: (member) {
                            _showMemberBottomSheet(member);
                          },
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 12.w, color: Colors.red),
          SizedBox(height: 2.h),
          Text(
            'Something went wrong',
            style:
                GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 1.h),
          Text(
            _error!,
            style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _loadHangoutData,
            child: Text('Retry', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  LatLng _getInitialPosition() {
    if (_hangoutDetails?['venue_latitude'] != null &&
        _hangoutDetails?['venue_longitude'] != null) {
      return LatLng(
        (_hangoutDetails!['venue_latitude'] as num).toDouble(),
        (_hangoutDetails!['venue_longitude'] as num).toDouble(),
      );
    }

    // Default to Lisbon if no venue location
    return const LatLng(38.7223, -9.1393);
  }

  MapType _getMapType() {
    switch (_mapType) {
      case 'satellite':
        return MapType.satellite;
      case 'terrain':
        return MapType.terrain;
      case 'hybrid':
        return MapType.hybrid;
      case 'normal':
      default:
        return MapType.normal;
    }
  }
}