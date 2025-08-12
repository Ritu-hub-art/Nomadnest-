import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/logo_widget.dart';
import '../login_screen/widgets/custom_text_field.dart';
import '../login_screen/widgets/loading_overlay.dart';
import '../login_screen/widgets/social_login_button.dart';
import './widgets/email_verification_widget.dart';
import './widgets/password_strength_widget.dart';
import './widgets/profile_setup_wizard_widget.dart';
import './widgets/signup_success_widget.dart';

class EmailSignupFlow extends StatefulWidget {
  const EmailSignupFlow({super.key});

  @override
  State<EmailSignupFlow> createState() => _EmailSignupFlowState();
}

class _EmailSignupFlowState extends State<EmailSignupFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  int _currentStep = 0;
  static const int _totalSteps = 4;
  bool _isLoading = false;

  // Step 1: Email and Password
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  String _passwordStrength = 'weak';

  // Step 2: Email Verification
  final _verificationCodeController = TextEditingController();
  int _resendCooldown = 0;

  // Step 3: Profile Setup
  final ImagePicker _imagePicker = ImagePicker();
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  XFile? _profileImage;
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  String? _selectedCity;
  List<String> _selectedLanguages = [];
  final List<String> _availableLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Japanese',
    'Korean',
    'Mandarin',
    'Dutch',
    'Russian',
    'Arabic'
  ];
  final List<String> _popularCities = [
    'New York, NY',
    'Los Angeles, CA',
    'London, UK',
    'Paris, France',
    'Tokyo, Japan',
    'Barcelona, Spain',
    'Berlin, Germany',
    'Amsterdam, Netherlands',
    'Bangkok, Thailand',
    'Sydney, Australia',
    'Toronto, Canada',
    'Mexico City, Mexico'
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeAnimations();
    _initializeCamera();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _slideController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    _fadeController.forward();
    _slideController.forward();
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

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      HapticFeedback.lightImpact();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _handleSocialSignup(String provider) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    Fluttertoast.showToast(
        msg: "Welcome to NomadNest via $provider!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.onPrimary,
        fontSize: 14.sp);

    // Skip to profile setup for social signups
    setState(() {
      _currentStep = 2;
    });
    _pageController.animateToPage(2,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  Future<void> _handleEmailSignup() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      if (!_acceptTerms) {
        Fluttertoast.showToast(
            msg: "Please accept the Terms of Service",
            backgroundColor: Theme.of(context).colorScheme.error,
            textColor: Theme.of(context).colorScheme.onError);
      }
      return;
    }

    if (_passwordStrength == 'weak') {
      Fluttertoast.showToast(
          msg: "Please create a stronger password",
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Theme.of(context).colorScheme.onError);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate signup process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _nextStep();
  }

  void _onPasswordStrengthChanged(String strength) {
    setState(() {
      _passwordStrength = strength;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget _buildStepIndicator() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Row(
            children: List.generate(_totalSteps, (index) {
          final isActive = index <= _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
              child: Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                      color: isActive
                          ? (isCurrent
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary)
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2))));
        })));
  }

  Widget _buildEmailPasswordStep() {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 4.h),
                  const LogoWidget(width: 140, height: 70),
                  SizedBox(height: 4.h),
                  Text('Join NomadNest',
                      style: GoogleFonts.inter(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 1.h),
                  Text('Connect with nomads worldwide',
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                  SizedBox(height: 4.h),

                  // Social signup buttons
                  Column(children: [
                    SocialLoginButton(
                        iconName: 'apple',
                        label: 'Sign up with Apple',
                        backgroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        textColor: Theme.of(context).colorScheme.surface,
                        onPressed: () => _handleSocialSignup('Apple')),
                    SizedBox(height: 2.h),
                    SocialLoginButton(
                        iconName: 'g_translate',
                        label: 'Sign up with Google',
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        onPressed: () => _handleSocialSignup('Google')),
                    SizedBox(height: 2.h),
                    // New email signup button
                    SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton.icon(
                            onPressed: () => _nextStep(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            icon: const CustomIconWidget(
                                iconName: 'email',
                                color: Colors.white,
                                size: 20),
                            label: Text('Continue with Email',
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600)))),
                  ]),

                  SizedBox(height: 4.h),

                  // Sign in link
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Already have an account? ',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.login);
                        },
                        child: Text('Sign In',
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600))),
                  ]),

                  SizedBox(height: 2.h),
                ])));
  }

  Widget _buildEmailFormStep() {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 4.h),
              Text('Create Account',
                  style: GoogleFonts.inter(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 1.h),
              Text('Enter your details to get started',
                  style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              SizedBox(height: 4.h),

              // Email signup form
              Form(
                  key: _formKey,
                  child: Column(children: [
                    CustomTextField(
                        label: 'Email Address',
                        hint: 'Enter your email',
                        iconName: 'email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail),

                    SizedBox(height: 3.h),

                    CustomTextField(
                        label: 'Password',
                        hint: 'Create a strong password',
                        iconName: 'lock',
                        isPassword: true,
                        controller: _passwordController,
                        validator: _validatePassword),

                    SizedBox(height: 2.h),

                    // Password strength indicator
                    PasswordStrengthWidget(
                        password: _passwordController.text,
                        onStrengthChanged: _onPasswordStrengthChanged),

                    SizedBox(height: 3.h),

                    CustomTextField(
                        label: 'Confirm Password',
                        hint: 'Confirm your password',
                        iconName: 'lock',
                        isPassword: true,
                        controller: _confirmPasswordController,
                        validator: _validateConfirmPassword),

                    SizedBox(height: 3.h),

                    // Terms checkbox
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor:
                                  Theme.of(context).colorScheme.primary),
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: RichText(
                                      text: TextSpan(
                                          style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                          children: [
                                        const TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                            text: 'Terms of Service',
                                            style: GoogleFonts.inter(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w500)),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                            text: 'Privacy Policy',
                                            style: GoogleFonts.inter(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w500)),
                                      ])))),
                        ]),

                    SizedBox(height: 4.h),

                    // Continue button
                    SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                            onPressed: _handleEmailSignup,
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Text('Create Account',
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600)))),
                  ])),

              SizedBox(height: 2.h),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: LoadingOverlay(
            isLoading: _isLoading,
            child: SafeArea(
                child: Column(children: [
              // Step indicator
              _buildStepIndicator(),

              // Back button
              if (_currentStep > 0)
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Row(children: [
                      TextButton.icon(
                          onPressed: _previousStep,
                          icon: Icon(Icons.arrow_back,
                              color: Theme.of(context).colorScheme.primary),
                          label: Text('Back',
                              style: GoogleFonts.inter(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500))),
                    ])),

              // Page content
              Expanded(
                  child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                    _buildEmailPasswordStep(),
                    _buildEmailFormStep(),
                    EmailVerificationWidget(
                        email: _emailController.text,
                        verificationCodeController: _verificationCodeController,
                        resendCooldown: _resendCooldown,
                        onResendCode: () {
                          setState(() {
                            _resendCooldown = 60;
                          });
                          // Start cooldown timer
                          Future.doWhile(() async {
                            await Future.delayed(const Duration(seconds: 1));
                            if (mounted) {
                              setState(() {
                                if (_resendCooldown > 0) _resendCooldown--;
                              });
                            }
                            return _resendCooldown > 0;
                          });
                        },
                        onCodeVerified: _nextStep),
                    ProfileSetupWizardWidget(
                        displayNameController: _displayNameController,
                        bioController: _bioController,
                        profileImage: _profileImage,
                        selectedCity: _selectedCity,
                        selectedLanguages: _selectedLanguages,
                        availableLanguages: _availableLanguages,
                        popularCities: _popularCities,
                        cameraController: _cameraController,
                        isCameraInitialized: _isCameraInitialized,
                        imagePicker: _imagePicker,
                        onImageSelected: (image) {
                          setState(() {
                            _profileImage = image;
                          });
                        },
                        onCityChanged: (city) {
                          setState(() {
                            _selectedCity = city;
                          });
                        },
                        onLanguagesChanged: (languages) {
                          setState(() {
                            _selectedLanguages = languages;
                          });
                        },
                        onComplete: _nextStep),
                    SignupSuccessWidget(
                        userEmail: _emailController.text,
                        userName: _displayNameController.text.isEmpty
                            ? 'New User'
                            : _displayNameController.text,
                        onGetStarted: () {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.homeDashboard);
                        }),
                  ])),
            ]))));
  }
}
