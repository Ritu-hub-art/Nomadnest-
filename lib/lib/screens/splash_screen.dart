import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../router/app_router.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    AuthService.instance.authState().listen((User? user) async {
      if (!mounted) return;
      if (user == null) {
        Navigator.pushReplacementNamed(context, AppRouter.authGateway);
      } else {
        await user.reload();
        final verified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
        if (verified) {
          Navigator.pushReplacementNamed(context, AppRouter.home);
        } else {
          Navigator.pushReplacementNamed(context, AppRouter.verifyEmail);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
