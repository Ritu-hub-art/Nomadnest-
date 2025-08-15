import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Check authentication status
      setState(() => _initializationStatus = 'Checking authentication...');
      await Future.delayed(const Duration(milliseconds: 500));
      final bool isAuthenticated = await _checkAuthenticationStatus();

      // Load user preferences
      setState(() => _initializationStatus = 'Loading preferences...');
      await Future.delayed(const Duration(milliseconds: 400));
      await _loadUserPreferences();

      // Request location permissions
      setState(() => _initializationStatus = 'Setting up location...');
      await Future.delayed(const Duration(milliseconds: 400));
      await _requestLocationPermissions();

      // Prepare cached map data
      setState(() => _initializationStatus = 'Preparing maps...');
      await Future.delayed(const Duration(milliseconds: 500));
      await _prepareCachedMapData();

      // Complete initialization
      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Ready!';
      });

      // Wait for animation to complete
      await Future.delayed(const Duration(milliseconds: 800));

      // Navigate based on authentication status
      if (mounted) {
        _navigateToNextScreen(isAuthenticated);
      }
    } catch (e) {
      // Handle initialization errors
      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Connection timeout';
      });

      // Show retry option after 5 seconds
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        _showRetryOption();
      }
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate authentication check
    // In real implementation, check stored tokens/credentials
    return false; // Assuming user is not authenticated for demo
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    // In real implementation, load from SharedPreferences or secure storage
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _requestLocationPermissions() async {
    // Simulate location permission request
    // In real implementation, use permission_handler package
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _prepareCachedMapData() async {
    // Simulate preparing cached map data
    // In real implementation, check and update offline map tiles
    await Future.delayed(const Duration(milliseconds: 400));
  }

  void _navigateToNextScreen(bool isAuthenticated) {
    if (isAuthenticated) {
      // Navigate to home dashboard for authenticated users
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else {
      // Check if user has completed onboarding
      final bool hasCompletedOnboarding = _checkOnboardingStatus();
      if (hasCompletedOnboarding) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  bool _checkOnboardingStatus() {
    // Simulate checking onboarding completion status
    // In real implementation, check SharedPreferences
    return false; // Assuming first-time user for demo
  }

  void _showRetryOption() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Connection Error',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Unable to initialize the app. Please check your internet connection and try again.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryInitialization();
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _initializationStatus = 'Retrying...';
    });
    _animationController.reset();
    _animationController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.9),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section with animation
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Custom NomadNest logo
                              Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(2.w),
                                child: LogoWidget(
                                  width: 26.w,
                                  height: 26.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              // App name
                              Text(
                                'NomadNest',
                                style: AppTheme
                                    .lightTheme.textTheme.displaySmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              // App tagline
                              Text(
                                'Hosting the World, One Nest at a Time',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Loading section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Loading indicator
                    if (_isInitializing) ...[
                      SizedBox(
                        width: 8.w,
                        height: 8.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],

                    // Status text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _initializationStatus,
                        key: ValueKey(_initializationStatus),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom section with version info
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Column(
                  children: [
                    Text(
                      'Version 1.0.0',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Travel safely with verified hosts',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
