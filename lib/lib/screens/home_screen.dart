import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = AuthService.instance.currentUser?.email ?? 'user';
    return Scaffold(
      appBar: AppBar(
        title: const Text('NomadNest'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRouter.authGateway, (_) => false);
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Center(
        child: Text('Hello, $email! Your email is verified.'),
      ),
    );
  }
}
