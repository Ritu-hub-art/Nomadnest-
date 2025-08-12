import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/automatic_checkin_widget.dart';
import './widgets/emergency_contacts_widget.dart';
import './widgets/location_sharing_widget.dart';
import './widgets/privacy_safety_controls_widget.dart';
import './widgets/safety_companion_widget.dart';
import './widgets/trust_verification_widget.dart';

class SafetySettings extends StatefulWidget {
  const SafetySettings({super.key});

  @override
  State<SafetySettings> createState() => _SafetySettingsState();
}

class _SafetySettingsState extends State<SafetySettings> {
  // Safety settings state
  Map<String, dynamic> _safetySettings = {
    'emergencyContactsEnabled': true,
    'autoCheckinEnabled': true,
    'checkinInterval': '2 hours',
    'locationSharingEnabled': true,
    'locationPrecision': 'exact',
    'trustedContactsOnly': true,
    'safetyButtonEnabled': true,
    'panicModeEnabled': true,
    'emergencyServicesIntegration': true,
    'identityVerified': true,
    'phoneVerified': true,
    'socialMediaLinked': false,
    'profileVisibility': 'trusted_only',
    'meetingLocationPreference': 'public_places',
    'safetyRatingVisible': true,
    'safetyBuddyEnabled': true,
    'automatedSafetyTips': true,
    'localEmergencyServices': true,
    'biometricAuth': true,
  };

  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      'id': '1',
      'name': 'Mom - Linda Chen',
      'phone': '+1 (555) 123-4567',
      'relationship': 'Parent',
      'verified': true,
    },
    {
      'id': '2',
      'name': 'Emily Rodriguez',
      'phone': '+1 (555) 987-6543',
      'relationship': 'Best Friend',
      'verified': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Safety Settings',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Safety Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'shield',
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Safety Matters',
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Configure your safety features and emergency contacts',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Emergency Contacts Section
            EmergencyContactsWidget(
              emergencyContacts: _emergencyContacts,
              onContactsChanged: (contacts) {
                setState(() {
                  _emergencyContacts.clear();
                  _emergencyContacts.addAll(contacts);
                });
                _showSuccessToast('Emergency contacts updated');
              },
            ),

            SizedBox(height: 2.h),

            // Automatic Check-ins Section
            AutomaticCheckinWidget(
              safetySettings: _safetySettings,
              onSettingChanged: (key, value) {
                setState(() {
                  _safetySettings[key] = value;
                });
                _showSuccessToast('Check-in settings updated');
              },
            ),

            SizedBox(height: 2.h),

            // Location Sharing Section
            LocationSharingWidget(
              safetySettings: _safetySettings,
              onSettingChanged: (key, value) {
                setState(() {
                  _safetySettings[key] = value;
                });
                _showSuccessToast('Location sharing updated');
              },
            ),

            SizedBox(height: 2.h),

            // Safety Companion Section
            SafetyCompanionWidget(
              safetySettings: _safetySettings,
              onSettingChanged: (key, value) {
                setState(() {
                  _safetySettings[key] = value;
                });
                _showSuccessToast('Safety companion updated');
              },
            ),

            SizedBox(height: 2.h),

            // Trust & Verification Section
            TrustVerificationWidget(
              safetySettings: _safetySettings,
              onSettingChanged: (key, value) {
                setState(() {
                  _safetySettings[key] = value;
                });
                _showSuccessToast('Verification settings updated');
              },
            ),

            SizedBox(height: 2.h),

            // Privacy & Safety Controls Section
            PrivacySafetyControlsWidget(
              safetySettings: _safetySettings,
              onSettingChanged: (key, value) {
                setState(() {
                  _safetySettings[key] = value;
                });
                _showSuccessToast('Privacy settings updated');
              },
            ),

            SizedBox(height: 4.h),

            // Help Section
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    leading: const CustomIconWidget(
                      iconName: 'help',
                      size: 24,
                    ),
                    title: Text(
                      'Safety Best Practices',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Learn about safety features and tips',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: const CustomIconWidget(
                      iconName: 'chevron_right',
                      size: 20,
                    ),
                    onTap: () {
                      _showSafetyTips();
                    },
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    leading: const CustomIconWidget(
                      iconName: 'support',
                      size: 24,
                    ),
                    title: Text(
                      'Emergency Support',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      '24/7 safety support hotline',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: const CustomIconWidget(
                      iconName: 'phone',
                      size: 20,
                    ),
                    onTap: () {
                      _contactEmergencySupport();
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _showSuccessToast(String message) {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _showSafetyTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Safety Best Practices',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSafetyTip('Always meet in public places'),
              _buildSafetyTip('Share your location with trusted contacts'),
              _buildSafetyTip('Enable automatic check-ins'),
              _buildSafetyTip('Verify your identity and contacts'),
              _buildSafetyTip('Trust your instincts'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTip(String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check',
            color: Colors.green.shade600,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              tip,
              style: GoogleFonts.inter(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _contactEmergencySupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Emergency Support',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'For immediate safety concerns, contact our 24/7 support line:\n\n+1 (800) NOMAD-HELP\n\nFor life-threatening emergencies, please call your local emergency services (911).',
          style: GoogleFonts.inter(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
