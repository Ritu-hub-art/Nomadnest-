import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/account_info_widget.dart';
import './widgets/connected_services_widget.dart';
import './widgets/data_management_widget.dart';
import './widgets/security_widget.dart';
import './widgets/subscription_management_widget.dart';
import './widgets/verification_status_widget.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({super.key});

  @override
  State<AccountManagement> createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  // Account management state
  Map<String, dynamic> _accountData = {
    'email': 'sarah.chen@nomadnest.com',
    'phone': '+1 (555) 123-4567',
    'phoneVerified': true,
    'emailVerified': true,
    'twoFactorEnabled': false,
    'identityVerified': true,
    'socialMediaLinked': ['Google', 'Facebook'],
    'subscriptionPlan': 'Premium',
    'billingCycle': 'Monthly',
    'accountCreated': '2024-01-15',
    'lastLogin': '2024-01-10',
    'dataExportRequested': false,
    'accountDeletionRequested': false,
  };

  final List<Map<String, dynamic>> _activeSessions = [
    {
      'id': '1',
      'device': 'iPhone 15 Pro',
      'location': 'San Francisco, CA',
      'lastActive': '5 minutes ago',
      'current': true,
    },
    {
      'id': '2',
      'device': 'MacBook Pro',
      'location': 'San Francisco, CA',
      'lastActive': '2 hours ago',
      'current': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Account Management',
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
            // Account Header
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
                      iconName: 'account_circle',
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
                          'Account & Security',
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Manage your account settings and data',
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

            // Account Information Section
            AccountInfoWidget(
              accountData: _accountData,
              onAccountInfoChanged: (key, value) {
                setState(() {
                  _accountData[key] = value;
                });
                _showSuccessToast('Account information updated');
              },
            ),

            SizedBox(height: 2.h),

            // Verification Status Section
            VerificationStatusWidget(
              accountData: _accountData,
              onVerificationChanged: (key, value) {
                setState(() {
                  _accountData[key] = value;
                });
                _showSuccessToast('Verification status updated');
              },
            ),

            SizedBox(height: 2.h),

            // Data Management Section
            DataManagementWidget(
              accountData: _accountData,
              onDataActionRequested: (action) {
                setState(() {
                  if (action == 'export') {
                    _accountData['dataExportRequested'] = true;
                  } else if (action == 'delete') {
                    _accountData['accountDeletionRequested'] = true;
                  }
                });
                _handleDataAction(action);
              },
            ),

            SizedBox(height: 2.h),

            // Security Section
            SecurityWidget(
              accountData: _accountData,
              activeSessions: _activeSessions,
              onSecurityChanged: (key, value) {
                setState(() {
                  _accountData[key] = value;
                });
                _showSuccessToast('Security settings updated');
              },
              onSessionLogout: (sessionId) {
                setState(() {
                  _activeSessions
                      .removeWhere((session) => session['id'] == sessionId);
                });
                _showSuccessToast('Session logged out');
              },
            ),

            SizedBox(height: 2.h),

            // Connected Services Section
            ConnectedServicesWidget(
              accountData: _accountData,
              onServiceToggled: (service, connected) {
                setState(() {
                  List<String> services = List<String>.from(
                      _accountData['socialMediaLinked'] ?? []);
                  if (connected) {
                    if (!services.contains(service)) {
                      services.add(service);
                    }
                  } else {
                    services.remove(service);
                  }
                  _accountData['socialMediaLinked'] = services;
                });
                _showSuccessToast('Connected services updated');
              },
            ),

            SizedBox(height: 2.h),

            // Subscription Management Section
            SubscriptionManagementWidget(
              accountData: _accountData,
              onSubscriptionChanged: (key, value) {
                setState(() {
                  _accountData[key] = value;
                });
                _showSuccessToast('Subscription updated');
              },
            ),

            SizedBox(height: 4.h),

            // Danger Zone
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .errorContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Text(
                      'Danger Zone',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    leading: CustomIconWidget(
                      iconName: 'delete_forever',
                      color: Theme.of(context).colorScheme.error,
                      size: 24,
                    ),
                    title: Text(
                      'Delete Account',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    subtitle: Text(
                      'Permanently delete your account and all data',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: const CustomIconWidget(
                      iconName: 'chevron_right',
                      size: 20,
                    ),
                    onTap: _showAccountDeletionDialog,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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

  void _handleDataAction(String action) {
    if (action == 'export') {
      _showDataExportDialog();
    } else if (action == 'delete') {
      _showAccountDeletionDialog();
    }
  }

  void _showDataExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Export Data',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'We\'ll prepare a download of your personal data. This may take a few minutes to complete.',
          style: GoogleFonts.inter(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessToast('Data export requested');
            },
            child: Text(
              'Export Data',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showAccountDeletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Account',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. This will permanently delete your account and all associated data.',
              style: GoogleFonts.inter(fontSize: 16.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              'Before deletion:',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '• Export your data if needed\n• Cancel active subscriptions\n• 30-day cooling-off period applies',
              style: GoogleFonts.inter(fontSize: 14.sp),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessToast('Account deletion process started');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              'Delete Account',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
