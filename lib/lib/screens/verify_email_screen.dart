import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../router/app_router.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _checking = false;
  bool _resending = false;

  Future<void> _openMail() async {
    final uri = Uri(scheme: 'mailto', path: '');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _checkVerified() async {
    setState(() => _checking = true);
    await AuthService.instance.reloadUser();
    final user = AuthService.instance.currentUser;
    final isVerified = user?.emailVerified ?? false;
    if (isVerified) {
      await AuthService.instance.markVerifiedInProfile();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRouter.profileSetup, (_) => false);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Still not verified — check your inbox or spam.')),
      );
    }
    if (mounted) setState(() => _checking = false);
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    await AuthService.instance.resendVerificationEmail();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification email resent.')),
    );
    setState(() => _resending = false);
  }

  @override
  Widget build(BuildContext context) {
    final email = AuthService.instance.currentUser?.email ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('We sent a verification link to:\n$email'),
            const SizedBox(height: 16),
            FilledButton(onPressed: _openMail, child: const Text('Open Mail app')),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _resending ? null : _resend,
              child: _resending ? const CircularProgressIndicator() : const Text('Resend email'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _checking ? null : _checkVerified,
              child: _checking ? const CircularProgressIndicator() : const Text("I've verified — Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
