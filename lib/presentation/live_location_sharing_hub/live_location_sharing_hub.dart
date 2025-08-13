import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/hangout_service.dart';
import '../../services/location_service.dart';
import './widgets/active_sessions_widget.dart';
import './widgets/location_accuracy_widget.dart';
import './widgets/permission_status_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/safety_controls_widget.dart';
import './widgets/update_frequency_widget.dart';

class LiveLocationSharingHub extends StatefulWidget {
  const LiveLocationSharingHub({super.key});

  @override
  State<LiveLocationSharingHub> createState() => _LiveLocationSharingHubState();
}

class _LiveLocationSharingHubState extends State<LiveLocationSharingHub>
    with TickerProviderStateMixin {
  final LocationService _locationService = LocationService.instance;
  final HangoutService _hangoutService = HangoutService.instance;

  late TabController _tabController;
  bool _isLoading = true;
  String? _error;

  // Data
  List<Map<String, dynamic>> _activeHangouts = [];
  Map<String, dynamic>? _locationStats;
  bool _hasLocationPermission = false;
  bool _isCurrentlySharing = false;
  String? _currentHangoutId;
  String _selectedAccuracy = 'exact';
  int _selectedFrequency = 10;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load active hangouts with location sharing
      final hangouts = await _hangoutService.getActiveHangoutsWithLocation();

      // Check location permission
      final hasPermission = await _locationService.requestLocationPermission();

      // Load current stats if sharing
      Map<String, dynamic>? stats;
      if (_isCurrentlySharing && _currentHangoutId != null) {
        stats = await _hangoutService
            .getLocationSharingStats(_currentHangoutId!);
      }

      setState(() {
        _activeHangouts = hangouts;
        _hasLocationPermission = hasPermission;
        _locationStats = stats;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final granted = await _locationService.requestLocationPermission();
    setState(() {
      _hasLocationPermission = granted;
    });
  }

  Future<void> _startSharing(String hangoutId) async {
    try {
      final success =
          await _locationService.startLocationSharing(hangoutId: hangoutId);

      if (success) {
        _loadData(); // Refresh data
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Started sharing location', style: GoogleFonts.inter()),
              backgroundColor: Colors.green));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to start location sharing',
                  style: GoogleFonts.inter()),
              backgroundColor: Colors.red));
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $error', style: GoogleFonts.inter()),
            backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _stopSharing() async {
    try {
      await _locationService.stopLocationSharing();
      _loadData(); // Refresh data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Stopped sharing location', style: GoogleFonts.inter()),
            backgroundColor: Colors.orange));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error stopping location sharing',
                style: GoogleFonts.inter()),
            backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black87, size: 6.w),
                onPressed: () => Navigator.pop(context)),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Live Location Hub',
                  style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
              if (_isCurrentlySharing)
                Text('Currently sharing • ${_activeHangouts.length} active',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp, color: Colors.green)),
            ]),
            actions: [
              if (_isCurrentlySharing)
                Container(
                    margin: EdgeInsets.only(right: 4.w),
                    child: Icon(Icons.radio_button_checked,
                        color: Colors.green, size: 5.w)),
            ],
            bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Settings'),
                  Tab(text: 'History'),
                ])),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Icon(Icons.error_outline,
                            size: 12.w, color: Colors.red),
                        SizedBox(height: 2.h),
                        Text('Something went wrong',
                            style: GoogleFonts.inter(
                                fontSize: 16.sp, fontWeight: FontWeight.w600)),
                        SizedBox(height: 1.h),
                        Text(_error!,
                            style: GoogleFonts.inter(
                                fontSize: 12.sp, color: Colors.grey),
                            textAlign: TextAlign.center),
                        SizedBox(height: 3.h),
                        ElevatedButton(
                            onPressed: _loadData,
                            child: Text('Retry', style: GoogleFonts.inter())),
                      ]))
                : TabBarView(controller: _tabController, children: [
                    _buildActiveTab(),
                    _buildSettingsTab(),
                    _buildHistoryTab(),
                  ]));
  }

  Widget _buildActiveTab() {
    return RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Status Header
              _buildStatusHeader(),
              SizedBox(height: 3.h),

              // Permission Status
              PermissionStatusWidget(
                  hasLocationPermission: _hasLocationPermission,
                  onRequestPermission: _requestLocationPermission),
              SizedBox(height: 3.h),

              // Active Sessions
              ActiveSessionsWidget(
                  activeHangouts: _activeHangouts,
                  currentHangoutId: _currentHangoutId,
                  isCurrentlySharing: _isCurrentlySharing,
                  onStartSharing: _startSharing,
                  onStopSharing: _stopSharing,
                  onViewMap: (hangoutId) {
                    Navigator.pushNamed(
                        context, AppRoutes.interactiveHangoutMap,
                        arguments: hangoutId);
                  }),
            ])));
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Location Accuracy
          LocationAccuracyWidget(
              selectedAccuracy: _selectedAccuracy,
              onAccuracyChanged: (accuracy) {
                setState(() {
                  _selectedAccuracy = accuracy;
                });
              }),
          SizedBox(height: 3.h),

          // Update Frequency
          UpdateFrequencyWidget(
              selectedFrequency: _selectedFrequency,
              onFrequencyChanged: (frequency) {
                setState(() {
                  _selectedFrequency = frequency;
                });
              }),
          SizedBox(height: 3.h),

          // Safety Controls
          const SafetyControlsWidget(),
        ]));
  }

  Widget _buildHistoryTab() {
    return const RecentActivityWidget();
  }

  Widget _buildStatusHeader() {
    if (!_isCurrentlySharing) {
      return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200)),
          child: Row(children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 6.w),
            SizedBox(width: 3.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Location sharing is off',
                      style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800)),
                  Text('Select a hangout below to start sharing your location',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp, color: Colors.blue.shade600)),
                ])),
          ]));
    }

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200)),
        child: Column(children: [
          Row(children: [
            Container(
                padding: EdgeInsets.all(2.w),
                decoration: const BoxDecoration(
                    color: Colors.green, shape: BoxShape.circle),
                child: Icon(Icons.location_on, color: Colors.white, size: 5.w)),
            SizedBox(width: 3.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Live sharing active',
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade800)),
                  Text('Your location is being shared with hangout members',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp, color: Colors.green.shade600)),
                ])),
          ]),
          if (_locationStats != null) ...[
            SizedBox(height: 2.h),
            Row(children: [
              _buildStatChip(
                  '${_locationStats!['active_sharers']} sharing', Colors.green),
              SizedBox(width: 2.w),
              _buildStatChip(
                  '${_locationStats!['sharing_rate']}% rate', Colors.blue),
              SizedBox(width: 2.w),
              _buildStatChip('${_selectedFrequency}s updates', Colors.orange),
            ]),
          ],
        ]));
  }

  Widget _buildStatChip(String label, Color color) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(77))),
        child: Text(label,
            style: GoogleFonts.inter(
                fontSize: 10.sp, fontWeight: FontWeight.w500)));
  }
}