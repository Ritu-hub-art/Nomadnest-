import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/supabase_service.dart';

class RecentActivityWidget extends StatefulWidget {
  const RecentActivityWidget({super.key});

  @override
  State<RecentActivityWidget> createState() => _RecentActivityWidgetState();
}

class _RecentActivityWidgetState extends State<RecentActivityWidget> {
  final SupabaseClient _client = SupabaseService.instance.client;

  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      // Get recent location sharing sessions
      final response = await _client
          .from('live_location_sessions')
          .select('''
            *,
            hangouts!inner(
              title,
              venue_name
            )
          ''')
          .eq('user_id', userId)
          .not('session_started_at', 'is', null)
          .order('session_started_at', ascending: false)
          .limit(20);

      setState(() {
        _activities = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 12.w, color: Colors.red),
            SizedBox(height: 2.h),
            Text(
              'Failed to load activity',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.h),
            Text(
              _error!,
              style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadActivities,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2.h),
            if (_activities.isEmpty)
              _buildEmptyState()
            else
              ...(_activities.map((activity) => _buildActivityItem(activity))),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 12.w,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 2.h),
          Text(
            'No activity yet',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your location sharing history will appear here',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final hangout = activity['hangouts'];
    final startedAt = DateTime.parse(activity['session_started_at']);
    final endedAt = activity['session_ended_at'] != null
        ? DateTime.parse(activity['session_ended_at'])
        : null;

    final duration = endedAt != null
        ? endedAt.difference(startedAt)
        : DateTime.now().difference(startedAt);

    final isActive = activity['is_sharing'] == true && endedAt == null;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green.shade200 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green : Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isActive
                      ? Icons.radio_button_checked
                      : Icons.location_history,
                  size: 4.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hangout['title'] ?? 'Untitled Hangout',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hangout['venue_name'] != null)
                      Text(
                        'at ${hangout['venue_name']}',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Icon(Icons.access_time, size: 4.w, color: Colors.grey.shade600),
              SizedBox(width: 2.w),
              Text(
                _formatDateTime(startedAt),
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.timer, size: 4.w, color: Colors.grey.shade600),
              SizedBox(width: 1.w),
              Text(
                _formatDuration(duration),
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(Icons.my_location, size: 4.w, color: Colors.grey.shade600),
              SizedBox(width: 2.w),
              Text(
                'Accuracy: ${_formatAccuracy(activity['accuracy_level'])}',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.update, size: 4.w, color: Colors.grey.shade600),
              SizedBox(width: 1.w),
              Text(
                'Every ${activity['update_frequency'] ?? 10}s',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          if (isActive) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fiber_manual_record,
                      size: 3.w, color: Colors.green),
                  SizedBox(width: 2.w),
                  Text(
                    'Currently sharing location',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${_formatTime(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  String _formatAccuracy(String? accuracy) {
    switch (accuracy) {
      case 'exact':
        return 'Exact';
      case 'approximate':
        return 'Approximate';
      case 'area_only':
        return 'Area Only';
      default:
        return 'Unknown';
    }
  }
}
