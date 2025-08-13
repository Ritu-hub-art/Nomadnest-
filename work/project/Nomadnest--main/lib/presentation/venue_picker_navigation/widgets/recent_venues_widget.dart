import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class RecentVenuesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> venues;
  final Function(Map<String, dynamic>) onVenueSelected;

  const RecentVenuesWidget({
    super.key,
    required this.venues,
    required this.onVenueSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (venues.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Venues',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${venues.length} saved',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Recent Venues List
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final venue = venues[index];
                return _buildRecentVenueCard(venue);
              },
            ),
          ),

          SizedBox(height: 3.h),

          // Divider
          Divider(
            color: Colors.grey[200],
            thickness: 1,
          ),

          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildRecentVenueCard(Map<String, dynamic> venue) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 3.w),
      child: GestureDetector(
        onTap: () {
          // Convert venue data format to match search results
          final searchFormatVenue = {
            'place_id': venue['venue_place_id'],
            'name': venue['venue_name'],
            'formatted_address': venue['venue_address'],
            'geometry': {
              'location': {
                'lat': venue['venue_latitude'],
                'lng': venue['venue_longitude'],
              }
            },
            'types': [venue['venue_type']],
          };
          onVenueSelected(searchFormatVenue);
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Venue Icon and Type
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _getVenueTypeColor(venue['venue_type'])
                            .withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getVenueTypeIcon(venue['venue_type']),
                        color: _getVenueTypeColor(venue['venue_type']),
                        size: 18.sp,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        '${venue['search_count']}x',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Venue Name
                Text(
                  venue['venue_name'] ?? 'Unknown Venue',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 0.5.h),

                // Address
                Text(
                  venue['venue_address'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 1.h),

                // Last Used
                Text(
                  _formatLastUsed(venue['last_searched_at']),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getVenueTypeIcon(String type) {
    switch (type) {
      case 'restaurant':
        return Icons.restaurant;
      case 'cafe':
        return Icons.local_cafe;
      case 'park':
        return Icons.park;
      case 'museum':
        return Icons.museum;
      case 'bar':
        return Icons.local_bar;
      case 'attraction':
        return Icons.attractions;
      case 'outdoor':
        return Icons.nature;
      default:
        return Icons.place;
    }
  }

  Color _getVenueTypeColor(String type) {
    switch (type) {
      case 'restaurant':
        return Colors.orange;
      case 'cafe':
        return Colors.brown;
      case 'park':
        return Colors.green;
      case 'museum':
        return Colors.purple;
      case 'bar':
        return Colors.red;
      case 'attraction':
        return Colors.blue;
      case 'outdoor':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatLastUsed(String? dateTimeString) {
    if (dateTimeString == null) return 'Recently used';

    try {
      final lastUsed = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(lastUsed);

      if (difference.inDays > 7) {
        return '${difference.inDays ~/ 7}w ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else {
        return 'Recently used';
      }
    } catch (e) {
      return 'Recently used';
    }
  }
}
