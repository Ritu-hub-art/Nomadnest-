import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global Supabase client instance
final supabase = Supabase.instance.client;

/// Deep link scheme for email verification
String get appScheme => dotenv.maybeGet('APP_SCHEME') ?? 'com.nomadnest.app';

/// Initialize Supabase with PKCE authentication flow
Future<void> initSupabase() async {
  await dotenv.load();
  
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      autoRefreshToken: true,
      persistSession: true,
    ),
  );
}