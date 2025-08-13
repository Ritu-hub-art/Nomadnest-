import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class VenueSearchBarWidget extends StatefulWidget {
  final String query;
  final Function(String) onQueryChanged;
  final bool isLoading;

  const VenueSearchBarWidget({
    super.key,
    required this.query,
    required this.onQueryChanged,
    this.isLoading = false,
  });

  @override
  State<VenueSearchBarWidget> createState() => _VenueSearchBarWidgetState();
}

class _VenueSearchBarWidgetState extends State<VenueSearchBarWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Search for restaurants, cafes, parks...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ),
                prefixIcon: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 20.sp,
                ),
                suffixIcon: widget.isLoading
                    ? Container(
                        width: 20,
                        height: 20,
                        padding: EdgeInsets.all(3.w),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      )
                    : _controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey[400],
                              size: 18.sp,
                            ),
                            onPressed: () {
                              _controller.clear();
                              widget.onQueryChanged('');
                            },
                          )
                        : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 3.h,
                ),
              ),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
              onChanged: widget.onQueryChanged,
              textInputAction: TextInputAction.search,
            ),
          ),

          SizedBox(height: 2.h),

          // Quick Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Restaurants', Icons.restaurant),
                SizedBox(width: 2.w),
                _buildFilterChip('Cafes', Icons.local_cafe),
                SizedBox(width: 2.w),
                _buildFilterChip('Parks', Icons.park),
                SizedBox(width: 2.w),
                _buildFilterChip('Museums', Icons.museum),
                SizedBox(width: 2.w),
                _buildFilterChip('Bars', Icons.local_bar),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: Colors.blue),
          SizedBox(width: 1.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blue.shade50,
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue,
      side: BorderSide(color: Colors.blue.shade200),
      onSelected: (selected) {
        if (selected) {
          widget.onQueryChanged(label.toLowerCase());
          _controller.text = label.toLowerCase();
        }
      },
    );
  }
}
