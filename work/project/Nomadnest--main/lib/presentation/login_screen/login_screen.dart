import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/logo_widget.dart';
import './widgets/custom_text_field.dart';
import './widgets/loading_overlay.dart';
import './widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthState();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void _checkAuthState() {
    // Listen to auth state changes
    AuthService.instance.onAuthStateChange((event, session) {
      if (event == AuthChangeEvent.signedIn && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
      }
    });

    // Check if user is already signed in
    if (AuthService.instance.isSignedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthService.instance.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response?.user != null) {
        // Check if email is verified
        final isVerified = await AuthService.instance.isEmailVerified();

        if (isVerified) {
          Fluttertoast.showToast(
            msg: "Welcome back to NomadNest!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            fontSize: 14.sp,
          );

          // Navigate to dashboard
          Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
        } else {
          Fluttertoast.showToast(
            msg: "Please verify your email before signing in",
            backgroundColor: Theme.of(context).colorScheme.error,
            textColor: Theme.of(context).colorScheme.onError,
          );

          // Sign out the user since they haven't verified email
          await AuthService.instance.signOut();
        }
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (error) {
      String errorMessage = 'Failed to sign in';

      if (error.toString().contains('invalid_credentials')) {
        errorMessage = 'Invalid email or password';
      } else if (error.toString().contains('email_not_confirmed')) {
        errorMessage = 'Please verify your email first';
      } else if (error.toString().contains('too_many_requests')) {
        errorMessage = 'Too many attempts. Please try again later';
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = false;

      if (provider == 'Google') {
        success =
            await AuthService.instance.signInWithOAuth(OAuthProvider.google);
      } else if (provider == 'Apple') {
        success =
            await AuthService.instance.signInWithOAuth(OAuthProvider.apple);
      }

      if (success) {
        Fluttertoast.showToast(
          msg: "Welcome to NomadNest via $provider!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.onPrimary,
          fontSize: 14.sp,
        );
      } else {
        throw Exception('$provider authentication failed');
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to sign in with $provider: ${error.toString()}",
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email address first",
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.instance.resetPassword(_emailController.text.trim());

      Fluttertoast.showToast(
        msg: "Password reset link sent to your email",
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.onPrimary,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to send reset link: ${error.toString()}",
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),

                  // Logo
                  FadeTransition(
                    opacity: _fadeController,
                    child: const LogoWidget(width: 140, height: 70),
                  ),

                  SizedBox(height: 4.h),

                  // Welcome text
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOut,
                    )),
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back',
                          style: GoogleFonts.inter(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Sign in to continue your nomad journey',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Login form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Email Address',
                          hint: 'Enter your email',
                          iconName: 'email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),

                        SizedBox(height: 3.h),

                        CustomTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          iconName: 'lock',
                          isPassword: true,
                          controller: _passwordController,
                          validator: _validatePassword,
                        ),

                        SizedBox(height: 2.h),

                        // Remember me and forgot password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                Text(
                                  'Remember me',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: _handleForgotPassword,
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4.h),

                        // Sign in button
                        SizedBox(
                          width: double.infinity,
                          height: 6.h,
                          child: ElevatedButton(
                            onPressed: _handleEmailLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          'Or continue with',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Social login buttons
                  Column(
                    children: [
                      SocialLoginButton(
                        iconName: 'apple',
                        label: 'Continue with Apple',
                        backgroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        textColor: Theme.of(context).colorScheme.surface,
                        onPressed: () => _handleSocialLogin('Apple'),
                      ),
                      SizedBox(height: 2.h),
                      SocialLoginButton(
                        iconName: 'g_translate',
                        label: 'Continue with Google',
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        onPressed: () => _handleSocialLogin('Google'),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.emailSignupFlow);
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
