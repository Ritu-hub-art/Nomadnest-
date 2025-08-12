import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/blocked_users_widget.dart';
import './widgets/data_analytics_widget.dart';
import './widgets/location_sharing_widget.dart';
import './widgets/profile_visibility_widget.dart';

class PrivacyControlsSettings extends StatefulWidget {
  const PrivacyControlsSettings({super.key});

  @override
  State<PrivacyControlsSettings> createState() =>
      _PrivacyControlsSettingsState();
}

class _PrivacyControlsSettingsState extends State<PrivacyControlsSettings> {
  String _profileVisibility = 'friends';
  bool _locationSharingHosts = true;
  bool _locationSharingHangouts = false;
  bool _locationSharingEmergency = true;
  bool _usageDataCollection = false;
  bool _personalizedRecommendations = true;
  bool _marketingCommunications = false;

  final List<Map<String, dynamic>> _blockedUsers = [
    {
      'id': '1',
      'name': 'John Smith',
      'imageUrl':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
      'blockedDate': '2025-08-01',
    },
    {
      'id': '2',
      'name': 'Sarah Wilson',
      'imageUrl':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop',
      'blockedDate': '2025-07-15',
    },
  ];

  void _onProfileVisibilityChanged(String value) {
    setState(() {
      _profileVisibility = value;
    });
    _showSaveConfirmation();
  }

  void _onLocationSharingChanged(String type, bool value) {
    setState(() {
      switch (type) {
        case 'hosts':
          _locationSharingHosts = value;
          break;
        case 'hangouts':
          _locationSharingHangouts = value;
          break;
        case 'emergency':
          _locationSharingEmergency = value;
          break;
      }
    });
    _showSaveConfirmation();
  }

  void _onDataAnalyticsChanged(String type, bool value) {
    setState(() {
      switch (type) {
        case 'usage':
          _usageDataCollection = value;
          break;
        case 'recommendations':
          _personalizedRecommendations = value;
          break;
        case 'marketing':
          _marketingCommunications = value;
          break;
      }
    });
    _showSaveConfirmation();
  }

  void _onUnblockUser(String userId) {
    setState(() {
      _blockedUsers.removeWhere((user) => user['id'] == userId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('User unblocked successfully'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSaveConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings saved automatically'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onClearLocationHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Location History'),
        content: const Text(
          'This will permanently delete all your location history data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Location history cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _onExportLocationHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location history export will be sent to your email'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Privacy Controls'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Visibility Section
            ProfileVisibilityWidget(
              selectedValue: _profileVisibility,
              onChanged: _onProfileVisibilityChanged,
            ),

            SizedBox(height: 3.h),

            // Location Sharing Section
            LocationSharingWidget(
              locationSharingHosts: _locationSharingHosts,
              locationSharingHangouts: _locationSharingHangouts,
              locationSharingEmergency: _locationSharingEmergency,
              onChanged: _onLocationSharingChanged,
              onClearHistory: _onClearLocationHistory,
              onExportHistory: _onExportLocationHistory,
            ),

            SizedBox(height: 3.h),

            // Data & Analytics Section
            DataAnalyticsWidget(
              usageDataCollection: _usageDataCollection,
              personalizedRecommendations: _personalizedRecommendations,
              marketingCommunications: _marketingCommunications,
              onChanged: _onDataAnalyticsChanged,
            ),

            SizedBox(height: 3.h),

            // Blocked Users Section
            BlockedUsersWidget(
              blockedUsers: _blockedUsers,
              onUnblockUser: _onUnblockUser,
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
