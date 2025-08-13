import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class LocationService {
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();
  LocationService._();

  SupabaseClient get _client => SupabaseService.instance.client;
  StreamSubscription<Position>? _positionStream;
  Timer? _locationUpdateTimer;
  String? _currentSharingHangoutId;
  bool _isSharingLocation = false;

  // Permission handling
  Future<bool> requestLocationPermission() async {
    try {
      if (kIsWeb) {
        // Web handles permissions through browser
        return true;
      }

      final permission = await Permission.location.status;
      if (permission.isGranted) {
        return true;
      }

      final result = await Permission.location.request();
      return result.isGranted;
    } catch (error) {
      if (kDebugMode) {
        print('Location permission error: $error');
      }
      return false;
    }
  }

  // Get current position
  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission denied');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      return position;
    } catch (error) {
      if (kDebugMode) {
        print('Get current location error: $error');
      }
      return null;
    }
  }

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (error) {
      if (kDebugMode) {
        print('Location service check error: $error');
      }
      return false;
    }
  }

  // Start sharing live location for hangout
  Future<bool> startLocationSharing({
    required String hangoutId,
    String accuracyLevel = 'exact',
    int intervalSeconds = 10,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission required');
      }

      // Stop any existing sharing
      await stopLocationSharing();

      _currentSharingHangoutId = hangoutId;
      _isSharingLocation = true;

      // Create or update live location session
      final currentLocation = await getCurrentLocation();
      if (currentLocation != null) {
        await _client.from('live_location_sessions').upsert({
          'hangout_id': hangoutId,
          'user_id': currentUser.id,
          'is_sharing': true,
          'session_started_at': DateTime.now().toIso8601String(),
          'current_latitude': currentLocation.latitude,
          'current_longitude': currentLocation.longitude,
          'accuracy_level': accuracyLevel,
          'update_frequency': intervalSeconds,
          'last_update': DateTime.now().toIso8601String(),
        });
      }

      // Start location updates
      _startLocationUpdates(hangoutId, accuracyLevel, intervalSeconds);

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('Start location sharing error: $error');
      }
      return false;
    }
  }

  // Stop sharing live location
  Future<void> stopLocationSharing() async {
    try {
      if (!_isSharingLocation || _currentSharingHangoutId == null) return;

      final currentUser = _client.auth.currentUser;
      if (currentUser != null && _currentSharingHangoutId != null) {
        // Update session to stop sharing
        await _client
            .from('live_location_sessions')
            .update({
              'is_sharing': false,
              'session_ended_at': DateTime.now().toIso8601String(),
            })
            .eq('hangout_id', _currentSharingHangoutId!)
            .eq('user_id', currentUser.id);
      }

      // Cancel timers and streams
      _positionStream?.cancel();
      _locationUpdateTimer?.cancel();

      _isSharingLocation = false;
      _currentSharingHangoutId = null;
    } catch (error) {
      if (kDebugMode) {
        print('Stop location sharing error: $error');
      }
    }
  }

  // Get live locations for hangout participants
  Future<List<Map<String, dynamic>>> getHangoutLiveLocations(
      String hangoutId) async {
    try {
      final response = await _client
          .from('live_location_sessions')
          .select('''
            *,
            user_profiles!live_location_sessions_user_id_fkey (
              id,
              full_name,
              display_name,
              profile_image_url
            )
          ''')
          .eq('hangout_id', hangoutId)
          .eq('is_sharing', true)
          .not('current_latitude', 'is', null)
          .not('current_longitude', 'is', null);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      if (kDebugMode) {
        print('Get hangout live locations error: $error');
      }
      return [];
    }
  }

  // Subscribe to real-time location updates
  RealtimeChannel subscribeToLocationUpdates({
    required String hangoutId,
    required Function(Map<String, dynamic>) onLocationUpdate,
  }) {
    return _client
        .channel('hangout_locations:$hangoutId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'live_location_sessions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'hangout_id',
            value: hangoutId,
          ),
          callback: (payload) {
            if (payload.newRecord.isNotEmpty) {
              onLocationUpdate(payload.newRecord);
            }
          },
        )
        .subscribe();
  }

  // Calculate ETA to destination
  Future<Map<String, dynamic>?> calculateETA({
    required Position currentPosition,
    required double destLat,
    required double destLng,
    String mode = 'walking',
  }) async {
    try {
      final distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        destLat,
        destLng,
      );

      // Estimate speed based on mode (m/s)
      double speedMps;
      switch (mode) {
        case 'walking':
          speedMps = 1.4; // ~5 km/h
          break;
        case 'cycling':
          speedMps = 4.2; // ~15 km/h
          break;
        case 'driving':
          speedMps = 11.1; // ~40 km/h
          break;
        case 'transit':
          speedMps = 8.3; // ~30 km/h
          break;
        default:
          speedMps = 1.4;
      }

      final etaSeconds = (distance / speedMps).round();
      final etaMinutes = (etaSeconds / 60).round();

      return {
        'distance_meters': distance.round(),
        'eta_seconds': etaSeconds,
        'eta_minutes': etaMinutes,
        'eta_text': etaMinutes < 60
            ? '${etaMinutes}min'
            : '${etaMinutes ~/ 60}h ${etaMinutes % 60}min',
      };
    } catch (error) {
      if (kDebugMode) {
        print('Calculate ETA error: $error');
      }
      return null;
    }
  }

  // Private method to handle location updates
  void _startLocationUpdates(
      String hangoutId, String accuracyLevel, int intervalSeconds) {
    _locationUpdateTimer =
        Timer.periodic(Duration(seconds: intervalSeconds), (timer) async {
      if (!_isSharingLocation) {
        timer.cancel();
        return;
      }

      try {
        final position = await getCurrentLocation();
        if (position == null) return;

        final currentUser = _client.auth.currentUser;
        if (currentUser == null) return;

        // Apply approximation if requested
        double lat = position.latitude;
        double lng = position.longitude;

        if (accuracyLevel == 'approximate') {
          // Add random offset for privacy (100-300m radius)
          final random = DateTime.now().millisecondsSinceEpoch % 100;
          final offsetLat =
              (random - 50) * 0.000009; // ~1m per 0.000009 degrees
          final offsetLng = (random - 50) * 0.000009;
          lat += offsetLat;
          lng += offsetLng;
        } else if (accuracyLevel == 'area_only') {
          // Apply larger offset for area-only sharing (500m+ radius)
          final random = DateTime.now().millisecondsSinceEpoch % 200;
          final offsetLat = (random - 100) * 0.000045;
          final offsetLng = (random - 100) * 0.000045;
          lat += offsetLat;
          lng += offsetLng;
        }

        // Update location data
        await _client.from('live_location_sessions').upsert({
          'hangout_id': hangoutId,
          'user_id': currentUser.id,
          'current_latitude': lat,
          'current_longitude': lng,
          'accuracy_level': accuracyLevel,
          'heading': position.heading,
          'speed': position.speed,
          'last_update': DateTime.now().toIso8601String(),
          'is_sharing': true,
        });

        // Also add to location sharing history for tracking
        await _client.from('location_sharing_history').insert({
          'hangout_id': hangoutId,
          'user_id': currentUser.id,
          'latitude': lat,
          'longitude': lng,
          'accuracy': position.accuracy,
          'heading': position.heading,
          'speed': position.speed,
          'recorded_at': DateTime.now().toIso8601String(),
        });
      } catch (error) {
        if (kDebugMode) {
          print('Location update error: $error');
        }
      }
    });
  }

  // Cleanup expired locations (call periodically)
  Future<void> cleanupExpiredLocations() async {
    try {
      final cutoffTime = DateTime.now().subtract(const Duration(hours: 2));
      await _client
          .from('live_location_sessions')
          .update({'is_sharing': false}).lt(
              'last_update', cutoffTime.toIso8601String());
    } catch (error) {
      if (kDebugMode) {
        print('Cleanup expired locations error: $error');
      }
    }
  }

  // Check if currently sharing location
  bool get isSharingLocation => _isSharingLocation;
  String? get currentSharingHangoutId => _currentSharingHangoutId;

  // Dispose resources
  void dispose() {
    _positionStream?.cancel();
    _locationUpdateTimer?.cancel();
    _isSharingLocation = false;
    _currentSharingHangoutId = null;
  }
}
