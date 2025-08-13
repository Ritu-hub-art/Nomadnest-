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
          AppTheme.lightTheme.colorScheme.primary.withOpacity(0.8),
          AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.9),
        ],
        stops: const [0.0, 0.6, 1.0],
      ),
    ),
    child: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            // Optional tagline...
          ],
        ),
      ),
    ),
  ),
); // <-- closes Scaffold
