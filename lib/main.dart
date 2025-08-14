// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/auth_page.dart';
import 'home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔧 Replace with your real Supabase values
  await Supabase.initialize(
    url: 'https://YOUR-SUPABASE-URL.supabase.co',
    anonKey: 'YOUR-ANON-PUBLIC-KEY',
  );

  runApp(const NomadNestApp());
}

class NomadNestApp extends StatelessWidget {
  const NomadNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nomad Nest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}

/// Shows either Home or Auth based on current session and reacts to auth changes.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _supabase = Supabase.instance.client;
  late final Stream<AuthState> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = _supabase.auth.onAuthStateChange;
  }

  @override
  Widget build(BuildContext context) {
    final session = _supabase.auth.currentSession;

    return StreamBuilder<AuthState>(
      stream: _authStream,
      initialData: session == null
          ? const AuthState(AuthChangeEvent.signedOut, null)
          : AuthState(AuthChangeEvent.signedIn, session),
      builder: (context, snapshot) {
        final authState = snapshot.data;

        // If no session -> show Auth
        if (authState?.session == null) {
          return const AuthPage();
        }

        // If user exists but not verified, we *still* let them reach Home,
        // but Home shows a banner prompting verification status.
        return const HomePage();
      },
    );
  }
}
