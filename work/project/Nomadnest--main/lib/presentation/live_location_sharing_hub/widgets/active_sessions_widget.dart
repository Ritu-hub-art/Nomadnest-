import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ActiveSessionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activeHangouts;
  final bool isCurrentlySharing;
  final String? currentHangoutId;
  final Function(String) onStartSharing;
  final VoidCallback onStopSharing;
  final Function(String) onViewMap;

  const ActiveSessionsWidget({
    super.key,
    required this.activeHangouts,
    required this.isCurrentlySharing,
    required this.currentHangoutId,
    required this.onStartSharing,
    required this.onStopSharing,
    required this.onViewMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Sessions',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 2.h),
        if (activeHangouts.isEmpty)
          _buildEmptyState()
        else
          ...activeHangouts
              .map((hangout) => _buildHangoutCard(context, hangout)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 12.w,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 2.h),
          Text(
            'No active hangouts',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Join a hangout with location sharing enabled to start sharing your location',
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

  Widget _buildHangoutCard(BuildContext context, Map<String, dynamic> hangout) {
    final isCurrentHangout = currentHangoutId == hangout['id'];
    final memberCount = (hangout['hangout_members'] as List?)?.length ?? 0;
    final hostProfile = hangout['user_profiles'];

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isCurrentHangout ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isCurrentHangout ? Colors.green.shade300 : Colors.grey.shade200,
          width: isCurrentHangout ? 2 : 1,
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
          // Header Row
          Row(
            children: [
              // Host Avatar
              CircleAvatar(
                radius: 6.w,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: hostProfile?['profile_image_url'] != null
                    ? CachedNetworkImageProvider(
                        hostProfile['profile_image_url'])
                    : null,
                child: hostProfile?['profile_image_url'] == null
                    ? Icon(Icons.person, size: 6.w, color: Colors.grey.shade500)
                    : null,
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
                    Text(
                      'Host: ${hostProfile?['display_name'] ?? hostProfile?['full_name'] ?? 'Unknown'}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Indicator
              if (isCurrentHangout)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'LIVE',
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

          // Venue Info
          if (hangout['venue_name'] != null)
            Row(
              children: [
                Icon(Icons.location_on, size: 4.w, color: Colors.grey.shade600),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    hangout['venue_name'],
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

          if (hangout['venue_name'] != null) SizedBox(height: 1.h),

          // Stats Row
          Row(
            children: [
              Icon(Icons.group, size: 4.w, color: Colors.grey.shade600),
              SizedBox(width: 1.w),
              Text(
                '$memberCount members',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.schedule, size: 4.w, color: Colors.grey.shade600),
              SizedBox(width: 1.w),
              Text(
                _formatTime(hangout['starts_at']),
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Action Buttons
          Row(
            children: [
              if (isCurrentHangout)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onStopSharing,
                    icon: const Icon(Icons.stop, color: Colors.white),
                    label: Text(
                      'Stop Sharing',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isCurrentlySharing
                        ? null
                        : () => onStartSharing(hangout['id']),
                    icon: Icon(
                      Icons.location_on,
                      color: isCurrentlySharing ? Colors.grey : Colors.white,
                    ),
                    label: Text(
                      isCurrentlySharing ? 'Already Sharing' : 'Start Sharing',
                      style: GoogleFonts.inter(
                        color: isCurrentlySharing ? Colors.grey : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrentlySharing
                          ? Colors.grey.shade300
                          : Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

              SizedBox(width: 3.w),

              // View Map Button
              OutlinedButton.icon(
                onPressed: () => onViewMap(hangout['id']),
                icon: Icon(Icons.map, size: 4.w),
                label: Text(
                  'Map',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(String? dateTimeString) {
    if (dateTimeString == null) return 'TBD';

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = dateTime.difference(now);

      if (difference.isNegative) {
        return 'Started';
      } else if (difference.inDays > 0) {
        return 'In ${difference.inDays}d';
      } else if (difference.inHours > 0) {
        return 'In ${difference.inHours}h';
      } else {
        return 'In ${difference.inMinutes}m';
      }
    } catch (e) {
      return 'TBD';
    }
  }
}
