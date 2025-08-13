import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VenueDetailsBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> venue;
  final VoidCallback onSelectVenue;
  final VoidCallback onNavigate;

  const VenueDetailsBottomSheetWidget({
    super.key,
    required this.venue,
    required this.onSelectVenue,
    required this.onNavigate,
  });

  @override
  State<VenueDetailsBottomSheetWidget> createState() =>
      _VenueDetailsBottomSheetWidgetState();
}

class _VenueDetailsBottomSheetWidgetState
    extends State<VenueDetailsBottomSheetWidget> {
  final PageController _photoController = PageController();
  int _currentPhotoIndex = 0;

  @override
  void dispose() {
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.venue['photos'] as List<dynamic>? ?? [];
    final reviews = widget.venue['reviews'] as List<dynamic>? ?? [];
    final openingHours =
        widget.venue['opening_hours'] as Map<String, dynamic>? ?? {};

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Photo Carousel
                if (photos.isNotEmpty)
                  _buildPhotoCarousel(photos)
                else
                  _buildPlaceholderImage(),

                // Venue Details
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.venue['name'] ?? 'Unknown Venue',
                              style: GoogleFonts.inter(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (widget.venue['rating'] != null) ...[
                            SizedBox(width: 3.w),
                            _buildRatingChip(widget.venue['rating']),
                          ],
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Address
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.grey[600], size: 16.sp),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              widget.venue['formatted_address'] ?? '',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Info Row (Price, Phone, Hours)
                      _buildInfoRow(),

                      SizedBox(height: 3.h),

                      // Opening Hours
                      if (openingHours.isNotEmpty)
                        _buildOpeningHours(openingHours),

                      // Reviews Section
                      if (reviews.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        _buildReviewsSection(reviews),
                      ],

                      SizedBox(height: 3.h),

                      // Action Buttons
                      _buildActionButtons(),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoCarousel(List<dynamic> photos) {
    return Container(
      height: 25.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _photoController,
            onPageChanged: (index) {
              setState(() => _currentPhotoIndex = index);
            },
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://via.placeholder.com/400x200?text=Venue+Photo+${index + 1}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 48,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Photo Indicators
          if (photos.length > 1)
            Positioned(
              bottom: 2.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: photos.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPhotoIndex == entry.key
                          ? Colors.white
                          : Colors.white.withAlpha(128),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 25.h,
      width: double.infinity,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image,
          color: Colors.grey[400],
          size: 48,
        ),
      ),
    );
  }

  Widget _buildRatingChip(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber, size: 16.sp),
          SizedBox(width: 1.w),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.amber.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        // Price Level
        if (widget.venue['price_level'] != null)
          _buildInfoChip(
            icon: Icons.attach_money,
            text: _getPriceLevelText(widget.venue['price_level']),
            color: Colors.green,
          ),

        SizedBox(width: 3.w),

        // Phone
        if (widget.venue['formatted_phone_number'] != null)
          _buildInfoChip(
            icon: Icons.phone,
            text: 'Call',
            color: Colors.blue,
            onTap: () {
              // Handle phone call
            },
          ),

        SizedBox(width: 3.w),

        // Website
        if (widget.venue['website'] != null)
          _buildInfoChip(
            icon: Icons.language,
            text: 'Website',
            color: Colors.purple,
            onTap: () {
              // Handle website navigation
            },
          ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14.sp),
            SizedBox(width: 1.w),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHours(Map<String, dynamic> hours) {
    final isOpen = hours['open_now'] as bool? ?? false;
    final weekdayText = hours['weekday_text'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, color: Colors.grey[600], size: 16.sp),
            SizedBox(width: 2.w),
            Text(
              'Hours',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: isOpen ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isOpen ? Colors.green.shade200 : Colors.red.shade200,
                ),
              ),
              child: Text(
                isOpen ? 'Open' : 'Closed',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isOpen ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
        if (weekdayText.isNotEmpty) ...[
          SizedBox(height: 2.h),
          ...weekdayText.take(3).map((day) => Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Text(
                  day,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              )),
          if (weekdayText.length > 3)
            Text(
              'Show more hours',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildReviewsSection(List<dynamic> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 2.h),
        ...reviews.take(2).map((review) => _buildReviewItem(review)),
      ],
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  (review['author_name'] as String? ?? 'U')[0],
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['author_name'] ?? 'Anonymous',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < (review['rating'] ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          size: 14.sp,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            review['text'] ?? '',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Navigate Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onNavigate,
            icon: Icon(Icons.directions, size: 18.sp),
            label: Text(
              'Navigate',
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

        SizedBox(width: 3.w),

        // Select Venue Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onSelectVenue,
            icon: Icon(Icons.check, size: 18.sp),
            label: Text(
              'Select Venue',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
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

  String _getPriceLevelText(int level) {
    switch (level) {
      case 0:
        return 'Free';
      case 1:
        return '\$';
      case 2:
        return '\$\$';
      case 3:
        return '\$\$\$';
      case 4:
        return '\$\$\$\$';
      default:
        return 'Price varies';
    }
  }
}
