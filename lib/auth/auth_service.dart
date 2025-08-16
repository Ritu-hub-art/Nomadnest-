import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/environment_service.dart';

class AuthService {
  static final SupabaseClient _sb = Supabase.instance.client;

  /// Sign up with email verification deep link
  static Future<void> signUp({
    required String email,
    required String password,
    String? emailRedirectTo,
  }) async {
    try {
      final redirectTo = emailRedirectTo ?? '${EnvironmentService.appScheme}://auth/verify';
      
      await _sb.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: redirectTo,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _sb.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<void> signOut() async {
    try {
      await _sb.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static User? get currentUser => _sb.auth.currentUser;

  static bool get isEmailVerified {
    final user = _sb.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }
}

