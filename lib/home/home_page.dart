import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nomad Nest'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await AuthService.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome!', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            if (user != null) ...[
              _InfoRow(label: 'Email', value: user.email ?? '(no email)'),
              const SizedBox(height: 6),
              _InfoRow(
                label: 'Verified',
                value: AuthService.isEmailVerified ? 'Yes' : 'No',
              ),
              const SizedBox(height: 24),
              if (!AuthService.isEmailVerified)
                Card(
                  elevation: 0,
                  color: Colors.amber.withOpacity(.2),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Your email is not verified yet. Please open the verification link we sent to your inbox.',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
            const Spacer(),
            FilledButton.icon(
              onPressed: () {
                // Hook your map/hangouts here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is your Home. Hook your map/hangouts here.')),
                );
              },
              icon: const Icon(Icons.map),
              label: const Text('Open Hangouts/Map'),
            )
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;
    return Row(
      children: [
        Text('$label: ', style: style?.copyWith(fontWeight: FontWeight.w600)),
        Expanded(child: Text(value, style: style)),
      ],
    );
  }
}

