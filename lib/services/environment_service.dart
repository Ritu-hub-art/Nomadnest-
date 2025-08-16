import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentService {
  static bool _initialized = false;
  static Map<String, dynamic> _envVars = {};

  // Initialize environment variables
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Try to load .env file first (preferred method with flutter_dotenv)
      try {
        await dotenv.load(fileName: '.env');
        _initialized = true;
        _validateEnvironment();
        return;
      } catch (e) {
        if (kDebugMode) {
          print('Info: .env file not found, falling back to env.json: $e');
        }
      }

      // Fallback to env.json file for backward compatibility
      final String envString = await rootBundle.loadString('env.json');
      _envVars = json.decode(envString);
      _initialized = true;

      // Validate required environment variables
      _validateEnvironment();
    } catch (e) {
      if (kDebugMode) {
        print('Warning: Failed to load environment configuration: $e');
      }
      _initialized = true; // Continue with defaults
    }
  }

  static void _validateEnvironment() {
    // Check for required Supabase configuration
    if (supabaseUrl.isEmpty) {
      throw Exception('SUPABASE_URL is not set in environment configuration');
    }

    if (supabaseAnonKey.isEmpty) {
      throw Exception(
          'SUPABASE_ANON_KEY is not set in environment configuration');
    }

    if (kDebugMode) {
      print('Environment loaded successfully');
      print('Supabase URL configured: ${supabaseUrl.isNotEmpty}');
      print('Supabase Key configured: ${supabaseAnonKey.isNotEmpty}');
      print('Resend Key configured: ${resendApiKey.isNotEmpty}');
    }
  }

  // Supabase Configuration
  static String get supabaseUrl => dotenv.maybeGet('SUPABASE_URL') ?? _getEnvVar('SUPABASE_URL');
  static String get supabaseAnonKey => dotenv.maybeGet('SUPABASE_ANON_KEY') ?? _getEnvVar('SUPABASE_ANON_KEY');
  
  // Deep link scheme
  static String get appScheme => dotenv.maybeGet('APP_SCHEME') ?? _getEnvVar('APP_SCHEME', fallback: 'com.nomadnest.app');

  // Email Service Configuration
  static String get resendApiKey => _getEnvVar('RESEND_API_KEY');

  // Google Maps Configuration
  static String get mapsApiKey => _getEnvVar('MAPS_API_KEY');

  // API Configuration
  static String get apiBaseUrl => _getEnvVar('API_BASE_URL');
  static int get apiTimeout =>
      int.tryParse(_getEnvVar('API_TIMEOUT_MS')) ?? 15000;
  static bool get useHttps => _getEnvVar('USE_HTTPS').toLowerCase() == 'true';
  static String get healthEndpoint =>
      _getEnvVar('HEALTH_ENDPOINT', fallback: '/health');

  // Debug Configuration
  static bool get debugNetwork =>
      kDebugMode && _getEnvVar('DEBUG_NETWORK').toLowerCase() == 'true';
  static bool get enableRequestLogging =>
      kDebugMode &&
      _getEnvVar('ENABLE_REQUEST_LOGGING').toLowerCase() == 'true';

  // Helper method to get environment variable with fallback
  static String _getEnvVar(String key, {String fallback = ''}) {
    final value = _envVars[key];
    if (value == null || value.toString().isEmpty) return fallback;

    // Handle special case where value contains "Real value exists"
    if (value.toString().contains('Real value exists')) {
      return String.fromEnvironment(key, defaultValue: fallback);
    }

    return value.toString();
  }

  // Helper methods
  static bool get isProduction => !kDebugMode;
  static bool get isValidConfiguration =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  static bool get hasEmailService => resendApiKey.isNotEmpty;
  static bool get hasGoogleMaps => mapsApiKey.isNotEmpty;
}Empty;
}