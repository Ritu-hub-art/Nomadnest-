import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/auth_page.dart';
import 'home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔧 Replace with your real Supabase values (Dashboard → Project Settings → API)
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

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _sb = Supabase.instance.client;
  late final Stream<AuthState> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = _sb.auth.onAuthStateChange;
  }

  @override
  Widget build(BuildContext context) {
    final session = _sb.auth.currentSession;

    return StreamBuilder<AuthState>(
      stream: _authStream,
      initialData: session == null
          ? AuthState(AuthChangeEvent.signedOut, null)
          : AuthState(AuthChangeEvent.signedIn, session),
      builder: (context, snapshot) {
        final authState = snapshot.data;

        if (authState?.session == null) {
          return const AuthPage();
        }
        return const HomePage();
      },
    );
  }
}

