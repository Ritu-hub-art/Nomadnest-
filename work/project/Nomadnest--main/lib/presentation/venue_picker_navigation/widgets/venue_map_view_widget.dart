import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class VenueMapViewWidget extends StatefulWidget {
  final Position? currentPosition;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;
  final Function(Map<String, dynamic>) onMarkerTapped;

  const VenueMapViewWidget({
    super.key,
    required this.currentPosition,
    required this.markers,
    required this.onMapCreated,
    required this.onMarkerTapped,
  });

  @override
  State<VenueMapViewWidget> createState() => _VenueMapViewWidgetState();
}

class _VenueMapViewWidgetState extends State<VenueMapViewWidget> {
  GoogleMapController? _controller;
  bool _isMapLoading = true;

  @override
  Widget build(BuildContext context) {
    final initialPosition = widget.currentPosition != null
        ? LatLng(
            widget.currentPosition!.latitude, widget.currentPosition!.longitude)
        : const LatLng(40.7128, -74.0060); // Default to NYC

    return Stack(
      children: [
        // Google Map
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            widget.onMapCreated(controller);
            setState(() => _isMapLoading = false);
          },
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 14.0,
          ),
          markers: widget.markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onTap: (LatLng position) {
            // Hide any open info windows when tapping on map
          },
        ),

        // Map Controls Overlay
        Positioned(
          top: 2.h,
          right: 4.w,
          child: Column(
            children: [
              // Recenter Button
              _buildMapControlButton(
                icon: Icons.my_location,
                onPressed: _recenterToCurrentLocation,
                tooltip: 'My Location',
              ),

              SizedBox(height: 2.h),

              // Map Type Toggle
              _buildMapControlButton(
                icon: Icons.layers,
                onPressed: _showMapTypeOptions,
                tooltip: 'Map Layers',
              ),

              SizedBox(height: 2.h),

              // Zoom In
              _buildMapControlButton(
                icon: Icons.add,
                onPressed: _zoomIn,
                tooltip: 'Zoom In',
              ),

              SizedBox(height: 1.h),

              // Zoom Out
              _buildMapControlButton(
                icon: Icons.remove,
                onPressed: _zoomOut,
                tooltip: 'Zoom Out',
              ),
            ],
          ),
        ),

        // Map Status Indicator
        Positioned(
          top: 2.h,
          left: 4.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(230),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        widget.markers.isNotEmpty ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${widget.markers.length} venues found',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Loading Indicator
        if (_isMapLoading)
          Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading map...',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // No Location Permission Overlay
        if (widget.currentPosition == null && !_isMapLoading)
          Positioned(
            bottom: 10.h,
            left: 4.w,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_disabled,
                    color: Colors.orange.shade700,
                    size: 20.sp,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Location access needed for better venue suggestions',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87, size: 20.sp),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.all(2.w),
        constraints: BoxConstraints(
          minWidth: 12.w,
          minHeight: 12.w,
        ),
      ),
    );
  }

  void _recenterToCurrentLocation() {
    if (widget.currentPosition != null && _controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              widget.currentPosition!.latitude,
              widget.currentPosition!.longitude,
            ),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  void _showMapTypeOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Map Type',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: Icon(Icons.map, color: Colors.green),
              title: Text('Normal'),
              onTap: () {
                _controller?.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                      widget.currentPosition?.latitude ?? 40.7128,
                      widget.currentPosition?.longitude ?? -74.0060,
                    ),
                    zoom: 14.0,
                  ),
                ));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.satellite, color: Colors.blue),
              title: Text('Satellite'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.terrain, color: Colors.brown),
              title: Text('Terrain'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _zoomIn() {
    _controller?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _controller?.animateCamera(CameraUpdate.zoomOut());
  }
}
