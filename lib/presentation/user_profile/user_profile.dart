import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievements_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/reviews_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/stats_row_widget.dart';
import './widgets/travel_history_widget.dart';
import './widgets/verification_status_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _imagePicker = ImagePicker();
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _showCameraView = false;
  XFile? _capturedImage;

  // Mock user profile data
  final Map<String, dynamic> _userProfile = {
    "id": 1,
    "name": "Sarah Chen",
    "email": "sarah.chen@nomadnest.com",
    "avatar":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
    "bio":
        "Digital nomad exploring the world one city at a time. Love connecting with locals and sharing travel stories. Always up for an adventure!",
    "location": "Currently in Barcelona, Spain",
    "isVerified": true,
    "verificationLevel": "full",
    "tripsCount": 47,
    "hostedCount": 23,
    "reviewsCount": 89,
    "rating": 4.8,
    "joinDate": "March 2022",
    "achievements": [
      {
        "id": 1,
        "title": "Explorer",
        "icon": "explore",
        "unlocked": true,
        "progress": 1.0,
      },
      {
        "id": 2,
        "title": "Host Hero",
        "icon": "home",
        "unlocked": true,
        "progress": 1.0,
      },
      {
        "id": 3,
        "title": "Social Butterfly",
        "icon": "people",
        "unlocked": false,
        "progress": 0.7,
      },
      {
        "id": 4,
        "title": "Safety First",
        "icon": "security",
        "unlocked": true,
        "progress": 1.0,
      },
    ],
    "travelHistory": [
      {
        "id": 1,
        "destination": "Tokyo, Japan",
        "date": "November 2024",
        "type": "Hosted",
        "rating": 5.0,
        "image":
            "https://images.pexels.com/photos/2506923/pexels-photo-2506923.jpeg",
      },
      {
        "id": 2,
        "destination": "Amsterdam, Netherlands",
        "date": "October 2024",
        "type": "Stayed",
        "rating": 4.5,
        "image":
            "https://images.pexels.com/photos/1388030/pexels-photo-1388030.jpeg",
      },
      {
        "id": 3,
        "destination": "Lisbon, Portugal",
        "date": "September 2024",
        "type": "Hosted",
        "rating": 4.8,
        "image":
            "https://images.pexels.com/photos/2901209/pexels-photo-2901209.jpeg",
      },
    ],
    "reviews": [
      {
        "id": 1,
        "reviewerName": "Marcus Johnson",
        "reviewerAvatar":
            "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg",
        "rating": 5.0,
        "comment":
            "Sarah was an amazing host! Her place was spotless and she gave great local recommendations. Would definitely stay again.",
        "date": "2 weeks ago",
      },
      {
        "id": 2,
        "reviewerName": "Elena Rodriguez",
        "reviewerAvatar":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg",
        "rating": 4.5,
        "comment":
            "Great experience staying with Sarah. She's very welcoming and the location was perfect for exploring the city.",
        "date": "1 month ago",
      },
      {
        "id": 3,
        "reviewerName": "David Kim",
        "reviewerAvatar":
            "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg",
        "rating": 5.0,
        "comment":
            "Sarah is a fantastic traveler and guest. Very respectful and easy to communicate with. Highly recommended!",
        "date": "2 months ago",
      },
    ],
  };

  // Determine if this is the user's own profile (for demo purposes, always true)
  final bool _isOwnProfile = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeCamera();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras.first)
              : _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

          await _cameraController!.initialize();
          await _applySettings();

          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      }
    } catch (e) {
      // Handle camera initialization error silently
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
        });
      }
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Flash not supported, continue without it
        }
      }
    } catch (e) {
      // Settings not supported, continue without them
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
        _showCameraView = false;
      });
    } catch (e) {
      // Handle capture error silently
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
      }
    } catch (e) {
      // Handle gallery error silently
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Change Profile Photo',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildImageOption(
                    'Camera',
                    'camera_alt',
                    () {
                      Navigator.pop(context);
                      if (_isCameraInitialized) {
                        setState(() {
                          _showCameraView = true;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildImageOption(
                    'Gallery',
                    'photo_library',
                    () {
                      Navigator.pop(context);
                      _pickImageFromGallery();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(String title, String iconName, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 8.w,
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => setState(() => _showCameraView = false),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => setState(() => _showCameraView = false),
        ),
        title: const Text('Take Photo', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _capturePhoto,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login-screen', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Logout',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showCameraView) {
      return _buildCameraView();
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title:
            Text(_isOwnProfile ? 'My Profile' : _userProfile["name"] as String),
        actions: [
          if (!_isOwnProfile)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/messaging-interface');
              },
              icon: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Profile'),
            Tab(text: 'History'),
            Tab(text: 'Reviews'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(),
          _buildHistoryTab(),
          _buildReviewsTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ProfileHeaderWidget(
            userProfile: _userProfile,
            isOwnProfile: _isOwnProfile,
            onEditPressed: () {
              // Navigate to edit profile
            },
            onCameraPressed: _showImagePickerOptions,
          ),
          SizedBox(height: 3.h),
          StatsRowWidget(userProfile: _userProfile),
          SizedBox(height: 3.h),
          VerificationStatusWidget(
            userProfile: _userProfile,
            isOwnProfile: _isOwnProfile,
            onVerifyPressed: () {
              // Navigate to verification flow
            },
          ),
          SizedBox(height: 3.h),
          AchievementsWidget(userProfile: _userProfile),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          TravelHistoryWidget(userProfile: _userProfile),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ReviewsWidget(userProfile: _userProfile),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SettingsSectionWidget(
            isOwnProfile: _isOwnProfile,
            onPrivacyPressed: () {
              // Navigate to privacy settings
            },
            onNotificationPressed: () {
              // Navigate to notification settings
            },
            onSafetyPressed: () {
              Navigator.pushNamed(context, '/safety-companion');
            },
            onAccountPressed: () {
              // Navigate to account management
            },
            onLogoutPressed: _handleLogout,
          ),
        ],
      ),
    );
  }
}
