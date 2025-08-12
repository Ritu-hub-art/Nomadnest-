import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/marketing_notifications_widget.dart';
import './widgets/quiet_hours_widget.dart';
import './widgets/social_notifications_widget.dart';
import './widgets/system_notifications_widget.dart';
import './widgets/travel_updates_widget.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  // Travel Updates
  bool _hostResponses = true;
  bool _hangoutInvitations = true;
  bool _safetyAlerts = true;

  // Social
  bool _newFollowers = true;
  bool _profileViews = false;
  bool _friendRequests = true;

  // Marketing
  bool _promotions = false;
  bool _featureAnnouncements = true;
  bool _travelTips = true;

  // System
  bool _securityAlerts = true;
  bool _appUpdates = true;
  bool _maintenanceNotices = false;

  // Quiet Hours
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);
  List<String> _quietHoursDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // Delivery Methods
  Map<String, Map<String, bool>> _deliveryMethods = {
    'hostResponses': {'push': true, 'email': true, 'sms': false},
    'hangoutInvitations': {'push': true, 'email': false, 'sms': false},
    'safetyAlerts': {'push': true, 'email': true, 'sms': true},
    'newFollowers': {'push': true, 'email': false, 'sms': false},
    'profileViews': {'push': false, 'email': false, 'sms': false},
    'friendRequests': {'push': true, 'email': true, 'sms': false},
  };

  void _onTravelUpdatesChanged(String type, bool value) {
    setState(() {
      switch (type) {
        case 'hostResponses':
          _hostResponses = value;
          break;
        case 'hangoutInvitations':
          _hangoutInvitations = value;
          break;
        case 'safetyAlerts':
          _safetyAlerts = value;
          break;
      }
    });
    _showSaveConfirmation();
  }

  void _onSocialChanged(String type, bool value) {
    setState(() {
      switch (type) {
        case 'newFollowers':
          _newFollowers = value;
          break;
        case 'profileViews':
          _profileViews = value;
          break;
        case 'friendRequests':
          _friendRequests = value;
          break;
      }
    });
    _showSaveConfirmation();
  }

  void _onMarketingChanged(String type, bool value) {
    setState(() {
      switch (type) {
        case 'promotions':
          _promotions = value;
          break;
        case 'featureAnnouncements':
          _featureAnnouncements = value;
          break;
        case 'travelTips':
          _travelTips = value;
          break;
      }
    });
    _showSaveConfirmation();
  }

  void _onSystemChanged(String type, bool value) {
    setState(() {
      switch (type) {
        case 'securityAlerts':
          _securityAlerts = value;
          break;
        case 'appUpdates':
          _appUpdates = value;
          break;
        case 'maintenanceNotices':
          _maintenanceNotices = value;
          break;
      }
    });
    _showSaveConfirmation();
  }

  void _onDeliveryMethodChanged(
      String notification, String method, bool value) {
    setState(() {
      _deliveryMethods[notification]![method] = value;
    });
    _showSaveConfirmation();
  }

  void _onQuietHoursChanged({
    TimeOfDay? start,
    TimeOfDay? end,
    List<String>? days,
  }) {
    setState(() {
      if (start != null) _quietHoursStart = start;
      if (end != null) _quietHoursEnd = end;
      if (days != null) _quietHoursDays = days;
    });
    _showSaveConfirmation();
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

  void _onTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            '🔔 Test notification sent! Check your notification panel.'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: _onTestNotification,
            tooltip: 'Test Notifications',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Travel Updates Section
            TravelUpdatesWidget(
              hostResponses: _hostResponses,
              hangoutInvitations: _hangoutInvitations,
              safetyAlerts: _safetyAlerts,
              deliveryMethods: _deliveryMethods,
              onChanged: _onTravelUpdatesChanged,
              onDeliveryMethodChanged: _onDeliveryMethodChanged,
            ),

            SizedBox(height: 3.h),

            // Social Notifications Section
            SocialNotificationsWidget(
              newFollowers: _newFollowers,
              profileViews: _profileViews,
              friendRequests: _friendRequests,
              deliveryMethods: _deliveryMethods,
              onChanged: _onSocialChanged,
              onDeliveryMethodChanged: _onDeliveryMethodChanged,
            ),

            SizedBox(height: 3.h),

            // Marketing Section
            MarketingNotificationsWidget(
              promotions: _promotions,
              featureAnnouncements: _featureAnnouncements,
              travelTips: _travelTips,
              onChanged: _onMarketingChanged,
            ),

            SizedBox(height: 3.h),

            // System Section
            SystemNotificationsWidget(
              securityAlerts: _securityAlerts,
              appUpdates: _appUpdates,
              maintenanceNotices: _maintenanceNotices,
              onChanged: _onSystemChanged,
            ),

            SizedBox(height: 3.h),

            // Quiet Hours Section
            QuietHoursWidget(
              startTime: _quietHoursStart,
              endTime: _quietHoursEnd,
              selectedDays: _quietHoursDays,
              onChanged: _onQuietHoursChanged,
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
