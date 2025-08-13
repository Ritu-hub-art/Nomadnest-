import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onFilterTap;

  const MapSearchBar({
    super.key,
    required this.onSearch,
    required this.onFilterTap,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _suggestions = [
    'New York, NY',
    'Los Angeles, CA',
    'London, UK',
    'Paris, France',
    'Tokyo, Japan',
    'Berlin, Germany',
    'Barcelona, Spain',
    'Amsterdam, Netherlands',
  ];
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _showSuggestions = false;
        _filteredSuggestions = [];
      });
    } else {
      setState(() {
        _filteredSuggestions = _suggestions
            .where((suggestion) => suggestion.toLowerCase().contains(query))
            .take(5)
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowLight,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: widget.onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search locations...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _showSuggestions = false;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(2.w),
                                child: CustomIconWidget(
                                  iconName: 'clear',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: widget.onFilterTap,
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowLight,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'tune',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showSuggestions) ...[
            SizedBox(height: 1.h),
            Container(
              constraints: BoxConstraints(maxHeight: 25.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredSuggestions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
                itemBuilder: (context, index) {
                  final suggestion = _filteredSuggestions[index];
                  return ListTile(
                    leading: CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    title: Text(
                      suggestion,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    onTap: () {
                      _searchController.text = suggestion;
                      widget.onSearch(suggestion);
                      setState(() {
                        _showSuggestions = false;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
