import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LiveMemberListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> liveMembers;
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final Function(String) onMemberTap;
  final Function(Map<String, dynamic>) onMemberInfo;

  const LiveMemberListWidget({
    super.key,
    required this.liveMembers,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onMemberTap,
    required this.onMemberInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
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

          // Header with filters
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.people, size: 5.w, color: Colors.blue),
                    SizedBox(width: 2.w),
                    Text(
                      'Live Members',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${liveMembers.length} sharing',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'All'),
                      SizedBox(width: 2.w),
                      _buildFilterChip('friends', 'Friends'),
                      SizedBox(width: 2.w),
                      _buildFilterChip('host', 'Host Only'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 1.h),

          // Members List
          Expanded(
            child: liveMembers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: liveMembers.length,
                    itemBuilder: (context, index) =>
                        _buildMemberItem(liveMembers[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = selectedFilter == value;

    return GestureDetector(
      onTap: () => onFilterChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 10.w, color: Colors.grey.shade400),
          SizedBox(height: 2.h),
          Text(
            'No members sharing location',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            'Members will appear here when they start sharing',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberItem(Map<String, dynamic> member) {
    final userProfile = member['user_profiles'];
    final lastUpdate = member['last_update'];
    final isCurrentUser = member['user_id'] ==
        'current_user'; // TODO: Replace with actual current user check

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () => onMemberTap(member['user_id']),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isCurrentUser ? Colors.blue.shade200 : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 6.w,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: userProfile?['profile_image_url'] != null
                        ? CachedNetworkImageProvider(
                            userProfile['profile_image_url'])
                        : null,
                    child: userProfile?['profile_image_url'] == null
                        ? Icon(Icons.person,
                            size: 6.w, color: Colors.grey.shade500)
                        : null,
                  ),

                  // Live indicator
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: _getStatusColor(lastUpdate),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 3.w),

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
                              fontSize: 13.sp,
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'YOU',
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
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
                        Icon(
                          Icons.access_time,
                          size: 3.w,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _getLastUpdateText(lastUpdate),
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.my_location,
                          size: 3.w,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _getAccuracyText(member['accuracy_level']),
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    // Member status and last update
                    Text(
                      member['is_sharing'] == true
                          ? 'Sharing location • ${_getLastUpdateText(member['last_update'])}'
                          : 'Location sharing off',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: member['is_sharing'] == true
                            ? Colors.green.shade600
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onMemberInfo(member),
                    icon: Icon(
                      Icons.info_outline,
                      size: 5.w,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () => onMemberTap(member['user_id']),
                    icon: Icon(
                      Icons.my_location,
                      size: 5.w,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  String _getAccuracyText(String? accuracy) {
    switch (accuracy) {
      case 'exact':
        return 'Exact';
      case 'approximate':
        return '~300m';
      case 'area_only':
        return '~500m';
      default:
        return 'Unknown';
    }
  }
}
