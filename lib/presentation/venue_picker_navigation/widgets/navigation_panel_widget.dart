import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';

class NavigationPanelWidget extends StatefulWidget {
  final Position? currentPosition;
  final Map<String, dynamic>? selectedVenue;
  final Map<String, dynamic>? navigationRoute;
  final String navigationMode;
  final Function(String) onModeChanged;
  final VoidCallback onStartNavigation;

  const NavigationPanelWidget({
    super.key,
    required this.currentPosition,
    required this.selectedVenue,
    required this.navigationRoute,
    required this.navigationMode,
    required this.onModeChanged,
    required this.onStartNavigation,
  });

  @override
  State<NavigationPanelWidget> createState() => _NavigationPanelWidgetState();
}

class _NavigationPanelWidgetState extends State<NavigationPanelWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.selectedVenue == null)
            _buildSelectVenuePrompt()
          else if (widget.currentPosition == null)
            _buildLocationRequiredPrompt()
          else ...[
            _buildNavigationHeader(),
            SizedBox(height: 3.h),
            _buildTransportationModes(),
            SizedBox(height: 3.h),
            if (widget.navigationRoute != null) ...[
              _buildRouteInformation(),
              SizedBox(height: 3.h),
            ],
            _buildNavigationActions(),
            SizedBox(height: 3.h),
            _buildLiveETACard(),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectVenuePrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.place,
              size: 48,
              color: Colors.blue.shade300,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Select a Venue First',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose a destination from the search or map tab to view navigation options',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRequiredPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_disabled,
              size: 48,
              color: Colors.orange.shade300,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Location Required',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Enable location access to calculate routes and navigation directions',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.navigation, color: Colors.blue.shade700, size: 20.sp),
              SizedBox(width: 2.w),
              Text(
                'Navigation',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FROM',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Your Location',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TO',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.selectedVenue!['name'],
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransportationModes() {
    final modes = [
      {
        'key': 'walking',
        'icon': Icons.directions_walk,
        'label': 'Walk',
        'color': Colors.green
      },
      {
        'key': 'driving',
        'icon': Icons.directions_car,
        'label': 'Drive',
        'color': Colors.blue
      },
      {
        'key': 'transit',
        'icon': Icons.directions_transit,
        'label': 'Transit',
        'color': Colors.purple
      },
      {
        'key': 'cycling',
        'icon': Icons.directions_bike,
        'label': 'Bike',
        'color': Colors.orange
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transportation Mode',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: modes
              .map((mode) => Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onModeChanged(mode['key'] as String),
                      child: Container(
                        margin: EdgeInsets.only(
                            right: modes.last == mode ? 0 : 2.w),
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          color: widget.navigationMode == mode['key']
                              ? (mode['color'] as Color).withAlpha(26)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.navigationMode == mode['key']
                                ? (mode['color'] as Color)
                                : Colors.grey.shade300,
                            width: widget.navigationMode == mode['key'] ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              mode['icon'] as IconData,
                              size: 24.sp,
                              color: widget.navigationMode == mode['key']
                                  ? (mode['color'] as Color)
                                  : Colors.grey.shade600,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              mode['label'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: widget.navigationMode == mode['key']
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: widget.navigationMode == mode['key']
                                    ? (mode['color'] as Color)
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRouteInformation() {
    final route = widget.navigationRoute!;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route Information',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildRouteInfoItem(
                  icon: Icons.straighten,
                  label: 'Distance',
                  value: route['distance_text'],
                  color: Colors.blue,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: _buildRouteInfoItem(
                  icon: Icons.access_time,
                  label: 'Duration',
                  value: route['duration_text'],
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(height: 1.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationActions() {
    return Row(
      children: [
        // Open in Google Maps Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Open in Google Maps
              final venue = widget.selectedVenue!;
              final location = venue['geometry']['location'];
              // Implementation for opening Google Maps would go here
            },
            icon: Icon(Icons.open_in_new, size: 18.sp),
            label: Text(
              'Open in Maps',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.blue.shade300),
              foregroundColor: Colors.blue.shade700,
            ),
          ),
        ),

        SizedBox(width: 3.w),

        // Start Navigation Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onStartNavigation,
            icon: Icon(Icons.navigation, size: 18.sp),
            label: Text(
              'Start Navigation',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveETACard() {
    if (widget.navigationRoute == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: Colors.green.shade700, size: 20.sp),
              SizedBox(width: 2.w),
              Text(
                'Live ETA',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
              Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'LIVE',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Estimated arrival in ${widget.navigationRoute!['duration_text']}',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.green.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Traffic conditions are updated in real-time',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.green.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
