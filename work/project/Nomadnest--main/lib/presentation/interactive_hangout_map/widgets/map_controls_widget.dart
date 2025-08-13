import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class MapControlsWidget extends StatelessWidget {
  final String selectedMapType;
  final Function(String) onMapTypeChanged;
  final VoidCallback onRecenterPressed;
  final VoidCallback onMyLocationPressed;

  const MapControlsWidget({
    super.key,
    required this.selectedMapType,
    required this.onMapTypeChanged,
    required this.onRecenterPressed,
    required this.onMyLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Map Type Button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showMapTypeMenu(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(3.w),
                child: Icon(
                  Icons.layers,
                  size: 6.w,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Recenter Button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRecenterPressed,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(3.w),
                child: Icon(
                  Icons.center_focus_strong,
                  size: 6.w,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // My Location Button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onMyLocationPressed,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(3.w),
                child: Icon(
                  Icons.my_location,
                  size: 6.w,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showMapTypeMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                  Text(
                    'Map Style',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _buildMapTypeOption(
                    context,
                    'normal',
                    'Standard',
                    'Default map view with roads and labels',
                    Icons.map,
                  ),
                  _buildMapTypeOption(
                    context,
                    'satellite',
                    'Satellite',
                    'Aerial view from satellite imagery',
                    Icons.satellite_alt,
                  ),
                  _buildMapTypeOption(
                    context,
                    'terrain',
                    'Terrain',
                    'Topographical features and elevation',
                    Icons.terrain,
                  ),
                  _buildMapTypeOption(
                    context,
                    'hybrid',
                    'Hybrid',
                    'Satellite imagery with road labels',
                    Icons.layers,
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTypeOption(
    BuildContext context,
    String value,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = selectedMapType == value;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () {
          onMapTypeChanged(value);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue.shade300 : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 5.w,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? Colors.blue.shade800 : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 5.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
