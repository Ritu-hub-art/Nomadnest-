import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/check_in_scheduler.dart';
import './widgets/emergency_contact_card.dart';
import './widgets/location_sharing_toggle.dart';
import './widgets/privacy_indicator.dart';
import './widgets/safety_action_button.dart';
import './widgets/safety_activity_item.dart';

class SafetyCompanion extends StatefulWidget {
  const SafetyCompanion({Key? key}) : super(key: key);

  @override
  State<SafetyCompanion> createState() => _SafetyCompanionState();
}

class _SafetyCompanionState extends State<SafetyCompanion>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLocationSharingEnabled = true;
  bool _isEmergencyContactsEnabled = false;
  bool _isAutoCheckInEnabled = true;
  String _selectedCheckInInterval = '1hour';

  // Mock data for emergency contacts
  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      'id': 1,
      'name': 'Sarah Johnson',
      'relationship': 'Emergency Contact',
      'phone': '+1 (555) 123-4567',
      'email': 'sarah.johnson@email.com',
    },
    {
      'id': 2,
      'name': 'Michael Chen',
      'relationship': 'Family',
      'phone': '+1 (555) 987-6543',
      'email': 'michael.chen@email.com',
    },
    {
      'id': 3,
      'name': 'Emma Rodriguez',
      'relationship': 'Friend',
      'phone': '+1 (555) 456-7890',
      'email': 'emma.rodriguez@email.com',
    },
  ];

  // Mock data for safety activities
  final List<Map<String, dynamic>> _safetyActivities = [
    {
      'id': 1,
      'type': 'safe_checkin',
      'location': 'Downtown Barcelona, Spain',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'isEmergency': false,
    },
    {
      'id': 2,
      'type': 'location_shared',
      'location': 'Park Güell, Barcelona',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isEmergency': false,
    },
    {
      'id': 3,
      'type': 'safe_checkin',
      'location': 'Sagrada Familia, Barcelona',
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'isEmergency': false,
    },
    {
      'id': 4,
      'type': 'location_shared',
      'location': 'Las Ramblas, Barcelona',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'isEmergency': false,
    },
  ];

  final List<String> _sharingWithContacts = [
    'Sarah J.',
    'Michael C.',
    'Emma R.'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleSafeCheckIn() {
    HapticFeedback.lightImpact();

    setState(() {
      _safetyActivities.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch,
        'type': 'safe_checkin',
        'location': 'Current Location',
        'timestamp': DateTime.now(),
        'isEmergency': false,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Safety check-in sent to your emergency contacts'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _handleEmergencyHelp() {
    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Emergency Alert',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ],
          ),
          content: Text(
            'This will immediately alert your emergency contacts and share your location. Are you sure you need help?',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendEmergencyAlert();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              ),
              child: Text(
                'Send Alert',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _sendEmergencyAlert() {
    setState(() {
      _safetyActivities.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch,
        'type': 'help_request',
        'location': 'Current Location',
        'timestamp': DateTime.now(),
        'isEmergency': true,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Emergency alert sent! Help is on the way.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _handleContactCall(Map<String, dynamic> contact) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${contact['name']}...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _handleContactMessage(Map<String, dynamic> contact) {
    HapticFeedback.selectionClick();
    Navigator.pushNamed(context, '/messaging-interface');
  }

  Widget _buildQuickActionsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Quick Safety Actions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SafetyActionButton(
            title: "I'm Safe",
            subtitle: 'Send check-in to emergency contacts',
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            textColor: AppTheme.lightTheme.colorScheme.onTertiary,
            iconName: 'check_circle',
            onPressed: _handleSafeCheckIn,
          ),
          SafetyActionButton(
            title: 'Need Help',
            subtitle: 'Send emergency alert with location',
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            textColor: AppTheme.lightTheme.colorScheme.onError,
            iconName: 'warning',
            onPressed: _handleEmergencyHelp,
            isEmergency: true,
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Location & Privacy',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          PrivacyIndicator(
            isLocationSharing: _isLocationSharingEnabled,
            sharingWith: _sharingWithContacts,
          ),
          LocationSharingToggle(
            title: 'Share Location',
            subtitle: 'Allow emergency contacts to see your location',
            isEnabled: _isLocationSharingEnabled,
            iconName: 'location_on',
            onChanged: (value) {
              setState(() {
                _isLocationSharingEnabled = value;
              });
              if (value) {
                setState(() {
                  _safetyActivities.insert(0, {
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'type': 'location_shared',
                    'location': 'Current Location',
                    'timestamp': DateTime.now(),
                    'isEmergency': false,
                  });
                });
              }
            },
          ),
          LocationSharingToggle(
            title: 'Emergency Contacts',
            subtitle: 'Enable quick access to emergency contacts',
            isEnabled: _isEmergencyContactsEnabled,
            iconName: 'contacts',
            onChanged: (value) {
              setState(() {
                _isEmergencyContactsEnabled = value;
              });
            },
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Automated Safety',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          CheckInScheduler(
            isEnabled: _isAutoCheckInEnabled,
            selectedInterval: _selectedCheckInInterval,
            onToggle: (value) {
              setState(() {
                _isAutoCheckInEnabled = value;
              });
            },
            onIntervalChanged: (interval) {
              setState(() {
                _selectedCheckInInterval = interval;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emergency Contacts',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            const Text('Add contact functionality coming soon'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.all(4.w),
                      ),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          if (_emergencyContacts.isEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'person_add',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 12.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No Emergency Contacts',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Add trusted contacts who can help you in emergencies',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ..._emergencyContacts.map((contact) {
              return EmergencyContactCard(
                contact: contact,
                onCall: () => _handleContactCall(contact),
                onMessage: () => _handleContactMessage(contact),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Recent Safety Activity',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          if (_safetyActivities.isEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 12.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No Recent Activity',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Your safety check-ins and location sharing will appear here',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ..._safetyActivities.map((activity) {
              return SafetyActivityItem(activity: activity);
            }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'Safety Companion',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: AppTheme.lightTheme.cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: Text(
                      'Safety Features Help',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Quick Actions:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '• "I\'m Safe" - Send check-in to emergency contacts\n• "Need Help" - Send emergency alert with location',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Location Sharing:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '• Control who can see your location\n• Enable/disable sharing anytime\n• Privacy indicators show sharing status',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Automated Check-ins:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '• Set periodic safety confirmations\n• Customizable intervals from 15 minutes to 4 hours\n• Automatic alerts if you don\'t respond',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Got it',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
          labelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Quick Actions'),
            Tab(text: 'Contacts'),
            Tab(text: 'Activity'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQuickActionsTab(),
          _buildContactsTab(),
          _buildActivityTab(),
        ],
      ),
    );
  }
}
