import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class HangoutService {
  static final HangoutService _instance = HangoutService._internal();
  factory HangoutService() => _instance;
  HangoutService._internal();

  static HangoutService get instance => _instance;

  final SupabaseClient _client = SupabaseService.instance.client;

  /// Get user's hangouts (hosted and joined)
  Future<List<Map<String, dynamic>>> getUserHangouts() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      // Get hangouts where user is host or member
      final response = await _client
          .from('hangouts')
          .select('''
            *,
            hangout_members!inner(
              status,
              joined_at
            ),
            user_profiles!hangouts_host_id_fkey(
              full_name,
              display_name,
              profile_image_url
            )
          ''')
          .or('host_id.eq.$userId,hangout_members.user_id.eq.$userId')
          .order('starts_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Get user hangouts failed: $error');
      return [];
    }
  }

  /// Get active hangouts with location sharing enabled
  Future<List<Map<String, dynamic>>> getActiveHangoutsWithLocation() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _client
          .from('hangouts')
          .select('''
            *,
            hangout_members!inner(
              status,
              joined_at
            ),
            user_profiles!hangouts_host_id_fkey(
              full_name,
              display_name,
              profile_image_url
            )
          ''')
          .eq('status', 'active')
          .eq('is_location_sharing_enabled', true)
          .or('host_id.eq.$userId,hangout_members.user_id.eq.$userId')
          .order('starts_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Get active hangouts with location failed: $error');
      return [];
    }
  }

  /// Get hangout details by ID
  Future<Map<String, dynamic>?> getHangoutDetails(String hangoutId) async {
    try {
      final response = await _client.from('hangouts').select('''
            *,
            user_profiles!hangouts_host_id_fkey(
              full_name,
              display_name,
              profile_image_url
            ),
            hangout_members(
              *,
              user_profiles!hangout_members_user_id_fkey(
                full_name,
                display_name,
                profile_image_url
              )
            )
          ''').eq('id', hangoutId).single();

      return response;
    } catch (error) {
      debugPrint('Get hangout details failed: $error');
      return null;
    }
  }

  /// Get hangout members with location sharing status
  Future<List<Map<String, dynamic>>> getHangoutMembers(String hangoutId) async {
    try {
      final response = await _client.from('hangout_members').select('''
            *,
            user_profiles!hangout_members_user_id_fkey(
              full_name,
              display_name,
              profile_image_url
            ),
            live_location_sessions(
              is_sharing,
              current_latitude,
              current_longitude,
              last_update,
              accuracy_level
            )
          ''').eq('hangout_id', hangoutId).eq('status', 'joined');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Get hangout members failed: $error');
      return [];
    }
  }

  /// Create a new hangout
  Future<Map<String, dynamic>?> createHangout({
    required String title,
    required String description,
    String? venueName,
    String? venueAddress,
    String? venuePlaceId,
    double? venueLatitude,
    double? venueLongitude,
    DateTime? startsAt,
    DateTime? endsAt,
    int maxParticipants = 10,
    bool isLocationSharingEnabled = false,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('hangouts')
          .insert({
            'title': title,
            'description': description,
            'host_id': userId,
            'venue_name': venueName,
            'venue_address': venueAddress,
            'venue_place_id': venuePlaceId,
            'venue_latitude': venueLatitude,
            'venue_longitude': venueLongitude,
            'starts_at': startsAt?.toIso8601String(),
            'ends_at': endsAt?.toIso8601String(),
            'max_participants': maxParticipants,
            'is_location_sharing_enabled': isLocationSharingEnabled,
            'status': 'active',
          })
          .select()
          .single();

      // Add host as first member
      await _client.from('hangout_members').insert({
        'hangout_id': response['id'],
        'user_id': userId,
        'status': 'joined',
        'joined_at': DateTime.now().toIso8601String(),
      });

      return response;
    } catch (error) {
      debugPrint('Create hangout failed: $error');
      return null;
    }
  }

  /// Update hangout details
  Future<bool> updateHangout({
    required String hangoutId,
    String? title,
    String? description,
    String? venueName,
    String? venueAddress,
    double? venueLatitude,
    double? venueLongitude,
    DateTime? startsAt,
    DateTime? endsAt,
    bool? isLocationSharingEnabled,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (venueName != null) updates['venue_name'] = venueName;
      if (venueAddress != null) updates['venue_address'] = venueAddress;
      if (venueLatitude != null) updates['venue_latitude'] = venueLatitude;
      if (venueLongitude != null) updates['venue_longitude'] = venueLongitude;
      if (startsAt != null) updates['starts_at'] = startsAt.toIso8601String();
      if (endsAt != null) updates['ends_at'] = endsAt.toIso8601String();
      if (isLocationSharingEnabled != null) {
        updates['is_location_sharing_enabled'] = isLocationSharingEnabled;
      }

      if (updates.isEmpty) return true;

      await _client
          .from('hangouts')
          .update(updates)
          .eq('id', hangoutId)
          .eq('host_id', userId);

      return true;
    } catch (error) {
      debugPrint('Update hangout failed: $error');
      return false;
    }
  }

  /// Join a hangout
  Future<bool> joinHangout(String hangoutId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      await _client.from('hangout_members').upsert({
        'hangout_id': hangoutId,
        'user_id': userId,
        'status': 'joined',
        'joined_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (error) {
      debugPrint('Join hangout failed: $error');
      return false;
    }
  }

  /// Leave a hangout
  Future<bool> leaveHangout(String hangoutId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      await _client
          .from('hangout_members')
          .update({
            'status': 'left',
            'left_at': DateTime.now().toIso8601String(),
          })
          .eq('hangout_id', hangoutId)
          .eq('user_id', userId);

      return true;
    } catch (error) {
      debugPrint('Leave hangout failed: $error');
      return false;
    }
  }

  /// Toggle location sharing for a hangout
  Future<bool> toggleLocationSharing(String hangoutId, bool enabled) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      await _client
          .from('hangouts')
          .update({'is_location_sharing_enabled': enabled})
          .eq('id', hangoutId)
          .eq('host_id', userId);

      return true;
    } catch (error) {
      debugPrint('Toggle location sharing failed: $error');
      return false;
    }
  }

  /// Get location sharing statistics for a hangout
  Future<Map<String, dynamic>?> getLocationSharingStats(
      String hangoutId) async {
    try {
      // Get total members
      final membersData = await _client
          .from('hangout_members')
          .select('id')
          .eq('hangout_id', hangoutId)
          .eq('status', 'joined')
          .count();

      // Get active sharers
      final sharersData = await _client
          .from('live_location_sessions')
          .select('id')
          .eq('hangout_id', hangoutId)
          .eq('is_sharing', true)
          .count();

      // Get session duration stats
      final sessionsData = await _client
          .from('live_location_sessions')
          .select('session_started_at, session_ended_at')
          .eq('hangout_id', hangoutId)
          .not('session_started_at', 'is', null);

      double avgDuration = 0;
      if (sessionsData.isNotEmpty) {
        final durations = sessionsData.map((session) {
          final start = DateTime.parse(session['session_started_at']);
          final end = session['session_ended_at'] != null
              ? DateTime.parse(session['session_ended_at'])
              : DateTime.now();
          return end.difference(start).inMinutes;
        }).toList();

        avgDuration = durations.isNotEmpty
            ? durations.reduce((a, b) => a + b) / durations.length
            : 0;
      }

      return {
        'total_members': membersData.count,
        'active_sharers': sharersData.count,
        'sharing_rate': membersData.count > 0
            ? (sharersData.count / membersData.count * 100).round()
            : 0,
        'avg_session_duration': avgDuration.round(),
      };
    } catch (error) {
      debugPrint('Get location sharing stats failed: $error');
      return null;
    }
  }

  /// Subscribe to hangout updates
  RealtimeChannel subscribeToHangout({
    required String hangoutId,
    required Function(Map<String, dynamic>) onUpdate,
  }) {
    return _client
        .channel('hangout_$hangoutId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'hangouts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: hangoutId,
          ),
          callback: (payload) => onUpdate(payload.newRecord),
        )
        .subscribe();
  }

  /// Subscribe to hangout member changes
  RealtimeChannel subscribeToHangoutMembers({
    required String hangoutId,
    required Function(List<Map<String, dynamic>>) onMembersUpdate,
  }) {
    return _client
        .channel('hangout_members_$hangoutId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'hangout_members',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'hangout_id',
            value: hangoutId,
          ),
          callback: (payload) async {
            // Refresh members list
            final members = await getHangoutMembers(hangoutId);
            onMembersUpdate(members);
          },
        )
        .subscribe();
  }
}
