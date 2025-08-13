import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth_gateway.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/verify_email_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/home_screen.dart';

class AppRouter {
  static const splash = '/';
  static const authGateway = '/auth-gateway';
  static const login = '/login';
  static const signup = '/signup';
  static const verifyEmail = '/verify-email';
  static const profileSetup = '/profile-setup';
  static const home = '/home';

  static final routes = <String, WidgetBuilder>{
    splash: (_) => const SplashScreen(),
    authGateway: (_) => const AuthGateway(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignUpScreen(),
    verifyEmail: (_) => const VerifyEmailScreen(),
    profileSetup: (_) => const ProfileSetupScreen(),
    home: (_) => const HomeScreen(),
  };
}
