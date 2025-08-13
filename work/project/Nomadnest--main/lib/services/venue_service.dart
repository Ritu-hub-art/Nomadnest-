import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/supabase_service.dart';

class VenueService {
  static VenueService? _instance;
  static VenueService get instance => _instance ??= VenueService._();
  VenueService._();

  SupabaseClient get _client => SupabaseService.instance.client;

  // Google Places API integration for venue search
  Future<List<Map<String, dynamic>>> searchVenues({
    required String query,
    Position? userLocation,
    String? placeType,
    int radius = 5000,
  }) async {
    try {
      // Mock venue data for development - replace with actual Google Places API
      final mockVenues = [
        {
          'place_id': 'ChIJN1t_tDeuEmsRUsoyG83frY4',
          'name': 'Starbucks Coffee',
          'formatted_address': '123 Main St, Downtown',
          'geometry': {
            'location': {'lat': 40.7128, 'lng': -74.0060}
          },
          'types': ['cafe', 'food', 'point_of_interest'],
          'rating': 4.2,
          'price_level': 2,
          'photos': [
            {
              'photo_reference': 'mock_photo_ref_1',
              'html_attributions': ['Starbucks']
            }
          ],
          'opening_hours': {'open_now': true},
          'distance': userLocation != null
              ? _calculateDistance(userLocation.latitude,
                  userLocation.longitude, 40.7128, -74.0060)
              : 0.5,
        },
        {
          'place_id': 'ChIJOwg_06VPwokRYv534QaPC8g',
          'name': 'Central Park',
          'formatted_address': 'Central Park, New York, NY',
          'geometry': {
            'location': {'lat': 40.7829, 'lng': -73.9654}
          },
          'types': ['park', 'tourist_attraction', 'point_of_interest'],
          'rating': 4.6,
          'price_level': 0,
          'photos': [
            {
              'photo_reference': 'mock_photo_ref_2',
              'html_attributions': ['Google']
            }
          ],
          'opening_hours': {'open_now': true},
          'distance': userLocation != null
              ? _calculateDistance(userLocation.latitude,
                  userLocation.longitude, 40.7829, -73.9654)
              : 1.2,
        },
        {
          'place_id': 'ChIJb9IySw6Q3IAR_6128GcTUEo',
          'name': 'Blue Bottle Coffee',
          'formatted_address': '456 Coffee Ave, Brooklyn',
          'geometry': {
            'location': {'lat': 40.7580, 'lng': -73.9855}
          },
          'types': ['cafe', 'food', 'store'],
          'rating': 4.4,
          'price_level': 3,
          'photos': [
            {
              'photo_reference': 'mock_photo_ref_3',
              'html_attributions': ['Blue Bottle Coffee']
            }
          ],
          'opening_hours': {'open_now': false},
          'distance': userLocation != null
              ? _calculateDistance(userLocation.latitude,
                  userLocation.longitude, 40.7580, -73.9855)
              : 0.8,
        },
      ];

      // Filter by query if provided
      var filteredVenues = mockVenues.where((venue) {
        if (query.isEmpty) return true;
        return (venue['name'] as String?)?.toLowerCase().contains(query.toLowerCase()) == true ||
            (venue['formatted_address'] as String?)
                ?.toLowerCase()
                .contains(query.toLowerCase()) == true;
      }).toList();

      // Sort by distance if user location available
      if (userLocation != null) {
        filteredVenues.sort((a, b) => (a['distance'] as num).compareTo(b['distance'] as num));
      }

      return filteredVenues;
    } catch (error) {
      throw Exception('Venue search failed: $error');
    }
  }

  // Get venue details by place ID
  Future<Map<String, dynamic>?> getVenueDetails(String placeId) async {
    try {
      // Mock detailed venue information
      final venueDetails = {
        'ChIJN1t_tDeuEmsRUsoyG83frY4': {
          'place_id': 'ChIJN1t_tDeuEmsRUsoyG83frY4',
          'name': 'Starbucks Coffee',
          'formatted_address': '123 Main St, Downtown, NY 10001',
          'formatted_phone_number': '+1 (555) 123-4567',
          'international_phone_number': '+1 555-123-4567',
          'geometry': {
            'location': {'lat': 40.7128, 'lng': -74.0060}
          },
          'rating': 4.2,
          'price_level': 2,
          'opening_hours': {
            'open_now': true,
            'weekday_text': [
              'Monday: 6:00 AM – 10:00 PM',
              'Tuesday: 6:00 AM – 10:00 PM',
              'Wednesday: 6:00 AM – 10:00 PM',
              'Thursday: 6:00 AM – 10:00 PM',
              'Friday: 6:00 AM – 11:00 PM',
              'Saturday: 7:00 AM – 11:00 PM',
              'Sunday: 7:00 AM – 9:00 PM'
            ]
          },
          'photos': [
            {
              'photo_reference': 'mock_photo_ref_1',
              'html_attributions': ['Starbucks'],
              'height': 400,
              'width': 600
            }
          ],
          'reviews': [
            {
              'author_name': 'John D.',
              'rating': 5,
              'text': 'Great coffee and friendly staff!',
              'time': DateTime.now()
                      .subtract(const Duration(days: 2))
                      .millisecondsSinceEpoch ~/
                  1000,
            },
            {
              'author_name': 'Sarah M.',
              'rating': 4,
              'text': 'Good place to work with WiFi.',
              'time': DateTime.now()
                      .subtract(const Duration(days: 5))
                      .millisecondsSinceEpoch ~/
                  1000,
            }
          ],
          'website': 'https://www.starbucks.com',
          'types': ['cafe', 'food', 'point_of_interest', 'establishment'],
        }
      };

      return venueDetails[placeId];
    } catch (error) {
      throw Exception('Failed to get venue details: $error');
    }
  }

  // Save venue to search history
  Future<void> saveToSearchHistory(Map<String, dynamic> venue) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return;

      final location = venue['geometry']['location'];
      final venueData = {
        'user_id': currentUser.id,
        'venue_name': venue['name'],
        'venue_place_id': venue['place_id'],
        'venue_address': venue['formatted_address'],
        'venue_latitude': location['lat'],
        'venue_longitude': location['lng'],
        'venue_type': _mapGoogleTypeToVenueType(venue['types']),
        'last_searched_at': DateTime.now().toIso8601String(),
      };

      // Check if venue already exists in history
      final existing = await _client
          .from('venue_search_history')
          .select()
          .eq('user_id', currentUser.id)
          .eq('venue_place_id', venue['place_id'])
          .maybeSingle();

      if (existing != null) {
        // Update existing record
        await _client.from('venue_search_history').update({
          'search_count': (existing['search_count'] as int) + 1,
          'last_searched_at': DateTime.now().toIso8601String(),
        }).eq('id', existing['id']);
      } else {
        // Insert new record
        await _client.from('venue_search_history').insert(venueData);
      }
    } catch (error) {
      throw Exception('Failed to save venue to history: $error');
    }
  }

  // Get recent venue search history
  Future<List<Map<String, dynamic>>> getRecentVenues({int limit = 10}) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _client
          .from('venue_search_history')
          .select()
          .eq('user_id', currentUser.id)
          .order('last_searched_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get recent venues: $error');
    }
  }

  // Set venue for hangout
  Future<void> setHangoutVenue(
      String hangoutId, Map<String, dynamic> venue) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      final location = venue['geometry']['location'];
      final venueData = {
        'venue_name': venue['name'],
        'venue_address': venue['formatted_address'],
        'venue_place_id': venue['place_id'],
        'venue_latitude': location['lat'],
        'venue_longitude': location['lng'],
        'venue_type': _mapGoogleTypeToVenueType(venue['types']),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _client
          .from('hangouts')
          .update(venueData)
          .eq('id', hangoutId)
          .eq('host_id', currentUser.id);

      // Save to search history
      await saveToSearchHistory(venue);
    } catch (error) {
      throw Exception('Failed to set hangout venue: $error');
    }
  }

  // Calculate route between two points
  Future<Map<String, dynamic>> calculateRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String mode = 'walking',
  }) async {
    try {
      // Mock route data - replace with actual Google Directions API
      final distance =
          _calculateDistance(originLat, originLng, destLat, destLng);
      final distanceMeters = (distance * 1000).round();

      // Estimate duration based on mode
      int durationSeconds;
      switch (mode) {
        case 'walking':
          durationSeconds = (distanceMeters / 1.4).round(); // ~5 km/h
          break;
        case 'cycling':
          durationSeconds = (distanceMeters / 4.2).round(); // ~15 km/h
          break;
        case 'driving':
          durationSeconds = (distanceMeters / 11.1).round(); // ~40 km/h
          break;
        case 'transit':
          durationSeconds = (distanceMeters / 8.3).round(); // ~30 km/h
          break;
        default:
          durationSeconds = (distanceMeters / 1.4).round();
      }

      return {
        'distance_meters': distanceMeters,
        'distance_text': _formatDistance(distance),
        'duration_seconds': durationSeconds,
        'duration_text': _formatDuration(durationSeconds),
        'polyline_encoded':
            _generateMockPolyline(originLat, originLng, destLat, destLng),
        'navigation_mode': mode,
      };
    } catch (error) {
      throw Exception('Failed to calculate route: $error');
    }
  }

  // Save navigation route
  Future<void> saveNavigationRoute({
    required String hangoutId,
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    required String mode,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      final route = await calculateRoute(
        originLat: originLat,
        originLng: originLng,
        destLat: destLat,
        destLng: destLng,
        mode: mode,
      );

      final routeData = {
        'hangout_id': hangoutId,
        'user_id': currentUser.id,
        'origin_latitude': originLat,
        'origin_longitude': originLng,
        'destination_latitude': destLat,
        'destination_longitude': destLng,
        'navigation_mode': mode,
        'distance_meters': route['distance_meters'],
        'duration_seconds': route['duration_seconds'],
        'polyline_encoded': route['polyline_encoded'],
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Check if route exists for this user and hangout
      final existing = await _client
          .from('navigation_routes')
          .select()
          .eq('hangout_id', hangoutId)
          .eq('user_id', currentUser.id)
          .maybeSingle();

      if (existing != null) {
        await _client
            .from('navigation_routes')
            .update(routeData)
            .eq('id', existing['id']);
      } else {
        await _client.from('navigation_routes').insert(routeData);
      }
    } catch (error) {
      throw Exception('Failed to save navigation route: $error');
    }
  }

  // Helper methods
  String _mapGoogleTypeToVenueType(List<dynamic> types) {
    if (types.contains('restaurant') || types.contains('food'))
      return 'restaurant';
    if (types.contains('cafe')) return 'cafe';
    if (types.contains('park')) return 'park';
    if (types.contains('museum')) return 'museum';
    if (types.contains('bar') || types.contains('night_club')) return 'bar';
    if (types.contains('tourist_attraction') ||
        types.contains('point_of_interest')) return 'attraction';
    return 'other';
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) /
        1000; // in kilometers
  }

  String _formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${(seconds / 60).round()} min';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

  String _generateMockPolyline(
      double lat1, double lng1, double lat2, double lng2) {
    // Simple mock polyline - in production, use Google Directions API response
    return 'mock_encoded_polyline_${lat1}_${lng1}_${lat2}_${lng2}';
  }
}