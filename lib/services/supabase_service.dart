import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './environment_service.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  late SupabaseClient _client;
  bool _initialized = false;

  SupabaseClient get client {
    if (!_initialized) {
      throw Exception(
          'SupabaseService not initialized. Call initialize() first.');
    }
    return _client;
  }

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await EnvironmentService.initialize();

      // Validate environment configuration
      if (!EnvironmentService.isValidConfiguration) {
        throw Exception(
            'Invalid Supabase configuration. Check environment variables.');
      }

      await Supabase.initialize(
        url: EnvironmentService.supabaseUrl,
        anonKey: EnvironmentService.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          autoRefreshToken: true,
          persistSession: true,
        ),
        debug: kDebugMode,
      );

      _client = Supabase.instance.client;
      _initialized = true;

      if (kDebugMode) {
        print('✅ Supabase initialized successfully');
        print(
            '📧 Email service configured: ${EnvironmentService.hasEmailService}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ Supabase initialization failed: $error');
      }
      rethrow;
    }
  }
}