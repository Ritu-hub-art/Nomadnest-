import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MemberInfoBottomSheetWidget extends StatelessWidget {
  final Map<String, dynamic> member;
  final Map<String, dynamic>? hangoutDetails;
  final Function(String) onNavigateToMember;
  final Function(String) onSendMessage;

  const MemberInfoBottomSheetWidget({
    super.key,
    required this.member,
    required this.hangoutDetails,
    required this.onNavigateToMember,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final userProfile = member['user_profiles'];
    final isCurrentUser = member['user_id'] ==
        'current_user'; // TODO: Replace with actual current user check

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Member Header
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 8.w,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              userProfile?['profile_image_url'] != null
                                  ? CachedNetworkImageProvider(
                                      userProfile['profile_image_url'])
                                  : null,
                          child: userProfile?['profile_image_url'] == null
                              ? Icon(Icons.person,
                                  size: 8.w, color: Colors.grey.shade500)
                              : null,
                        ),

                        // Live status indicator
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: _getStatusColor(member['last_update']),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  userProfile?['display_name'] ??
                                      userProfile?['full_name'] ??
                                      'Unknown Member',
                                  style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isCurrentUser)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'YOU',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Container(
                                width: 2.w,
                                height: 2.w,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(member['last_update']),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                _getStatusText(member['last_update']),
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Location Information
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Details',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      _buildInfoRow(
                        Icons.access_time,
                        'Last Update',
                        _getLastUpdateText(member['last_update']),
                      ),
                      SizedBox(height: 1.h),
                      _buildInfoRow(
                        Icons.my_location,
                        'Accuracy',
                        _getAccuracyText(member['accuracy_level']),
                      ),
                      if (member['speed'] != null && member['speed'] > 0) ...[
                        SizedBox(height: 1.h),
                        _buildInfoRow(
                          Icons.speed,
                          'Speed',
                          '${(member['speed'] as num).toStringAsFixed(1)} m/s',
                        ),
                      ],
                      if (member['heading'] != null) ...[
                        SizedBox(height: 1.h),
                        _buildInfoRow(
                          Icons.navigation,
                          'Heading',
                          '${(member['heading'] as num).toStringAsFixed(0)}°',
                        ),
                      ],
                      SizedBox(height: 1.h),
                      _buildInfoRow(
                        Icons.update,
                        'Update Frequency',
                        'Every ${member['update_frequency'] ?? 10}s',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Location sharing status
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: member['is_sharing'] == true
                        ? Colors.green.shade50
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(3.w),
                    border: Border.all(
                      color: member['is_sharing'] == true
                          ? Colors.green.shade200
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        member['is_sharing'] == true
                            ? Icons.location_on
                            : Icons.location_off,
                        color: member['is_sharing'] == true
                            ? Colors.green.shade600
                            : Colors.grey.shade600,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member['is_sharing'] == true
                                  ? 'Sharing live location'
                                  : 'Location sharing off',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: member['is_sharing'] == true
                                    ? Colors.green.shade700
                                    : Colors.grey.shade700,
                              ),
                            ),
                            if (member['is_sharing'] == true) ...[
                              SizedBox(height: 0.5.h),
                              Text(
                                'Accuracy: ${_getAccuracyText(member['accuracy_level'])}',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                'Last update: ${_getLastUpdateText(member['last_update'])}',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Distance and ETA (if venue is set)
                if (hangoutDetails?['venue_latitude'] != null &&
                    hangoutDetails?['venue_longitude'] != null &&
                    member['current_latitude'] != null &&
                    member['current_longitude'] != null)
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Distance to Venue',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.blue, size: 5.w),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                hangoutDetails!['venue_name'] ?? 'Venue',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                            Text(
                              _calculateDistance(),
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 3.h),

                // Action Buttons
                Row(
                  children: [
                    if (!isCurrentUser)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onSendMessage(member['user_id']),
                          icon: const Icon(Icons.message, color: Colors.white),
                          label: Text(
                            'Message',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    if (!isCurrentUser) SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => onNavigateToMember(member['user_id']),
                        icon: const Icon(Icons.navigation, color: Colors.white),
                        label: Text(
                          'Navigate',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 4.w, color: Colors.grey.shade600),
        SizedBox(width: 3.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? lastUpdate) {
    if (lastUpdate == null) return Colors.grey;

    try {
      final updateTime = DateTime.parse(lastUpdate);
      final now = DateTime.now();
      final difference = now.difference(updateTime);

      if (difference.inMinutes < 2) {
        return Colors.green; // Live
      } else if (difference.inMinutes < 5) {
        return Colors.orange; // Recent
      } else {
        return Colors.red; // Stale
      }
    } catch (e) {
      return Colors.grey;
    }
  }

  String _getStatusText(String? lastUpdate) {
    if (lastUpdate == null) return 'Status unknown';

    try {
      final updateTime = DateTime.parse(lastUpdate);
      final now = DateTime.now();
      final difference = now.difference(updateTime);

      if (difference.inMinutes < 2) {
        return 'Live location sharing';
      } else if (difference.inMinutes < 5) {
        return 'Recent location update';
      } else {
        return 'Location may be stale';
      }
    } catch (e) {
      return 'Status unknown';
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
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getAccuracyText(String? accuracyLevel) {
    switch (accuracyLevel) {
      case 'exact':
        return 'Precise location';
      case 'approximate':
        return 'Approximate (~300m)';
      case 'area_only':
        return 'Area only (~500m)';
      default:
        return 'Unknown';
    }
  }

  String _calculateDistance() {
    // TODO: Implement actual distance calculation using Haversine formula
    // For now, return a placeholder
    return '~1.2km';
  }
}
