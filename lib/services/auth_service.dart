import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './environment_service.dart';
import './supabase_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  SupabaseClient get _client => SupabaseService.instance.client;

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (!isSignedIn) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Get user profile error: $error');
      }
      return null;
    }
  }

  // Sign up with email and password
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    String? fullName,
    String? displayName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName ?? email.split('@').first,
          'display_name': displayName ?? email.split('@').first,
          'role': 'nomad',
        },
      );

      if (response.user != null) {
        // Generate and send verification code
        await sendVerificationCode(email);
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Sign up error: $error');
      }
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Sign in error: $error');
      }
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      if (kDebugMode) {
        print('Sign out error: $error');
      }
      rethrow;
    }
  }

  // Generate and send verification code
  Future<String?> sendVerificationCode(String email) async {
    try {
      // Generate verification code using database function
      final codeResponse = await _client
          .rpc('create_verification_code', params: {'user_email': email});

      final verificationCode = codeResponse as String;

      // Send email using Resend edge function
      final supabaseUrl = EnvironmentService.supabaseUrl;
      final anonKey = EnvironmentService.supabaseAnonKey;
      final supabaseApiUrl =
          '$supabaseUrl/functions/v1/resend-email-verification';

      final dio = Dio();
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $anonKey',
      };

      // Enhanced error handling for email sending
      try {
        final emailResponse = await dio.post(supabaseApiUrl, data: {
          'email': email,
          'token': verificationCode,
          'user_name': email.split('@').first,
        });

        if (emailResponse.statusCode == 200) {
          if (kDebugMode) {
            print('✅ Verification email sent successfully to $email');
          }
          return verificationCode;
        } else {
          throw Exception(
              'Email service returned status: ${emailResponse.statusCode}');
        }
      } on DioException catch (dioError) {
        // Handle specific Dio errors
        String errorMessage = 'Failed to send verification email';

        if (dioError.response != null) {
          final statusCode = dioError.response!.statusCode;
          final responseData = dioError.response!.data;

          if (statusCode == 500 &&
              responseData.toString().contains('RESEND_API_KEY')) {
            errorMessage =
                'Email service not configured. Please contact support.';
          } else if (statusCode == 401) {
            errorMessage = 'Email service authentication failed';
          } else if (statusCode == 429) {
            errorMessage = 'Too many email requests. Please try again later.';
          } else {
            errorMessage = 'Email service error (Status: $statusCode)';
          }
        } else if (dioError.type == DioExceptionType.connectionTimeout) {
          errorMessage = 'Email service timeout. Please check your connection.';
        } else if (dioError.type == DioExceptionType.connectionError) {
          errorMessage =
              'Cannot connect to email service. Please check your internet connection.';
        }

        if (kDebugMode) {
          print('❌ Email sending failed: $errorMessage');
          print('Dio error details: ${dioError.toString()}');
        }

        throw Exception(errorMessage);
      }
    } catch (error) {
      if (kDebugMode) {
        print('Send verification code error: $error');
      }

      // Provide user-friendly error messages
      String userMessage = 'Failed to send verification email';
      if (error.toString().contains('Email service not configured')) {
        userMessage =
            'Email verification is temporarily unavailable. Please contact support.';
      } else if (error.toString().contains('authentication failed')) {
        userMessage = 'Email service authentication error. Please try again.';
      } else if (error.toString().contains('Too many email requests')) {
        userMessage =
            'Too many verification attempts. Please wait a moment and try again.';
      }

      throw Exception(userMessage);
    }
  }

  // Verify email code
  Future<bool> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _client.rpc('verify_email_code', params: {
        'user_email': email,
        'input_code': code,
      });

      return response == true;
    } catch (error) {
      if (kDebugMode) {
        print('Verify email code error: $error');
      }
      return false;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? fullName,
    String? displayName,
    String? bio,
    String? city,
    String? country,
    List<String>? languages,
    String? profileImageUrl,
  }) async {
    try {
      if (!isSignedIn) return false;

      final updateData = <String, dynamic>{};

      if (fullName != null) updateData['full_name'] = fullName;
      if (displayName != null) updateData['display_name'] = displayName;
      if (bio != null) updateData['bio'] = bio;
      if (city != null) updateData['city'] = city;
      if (country != null) updateData['country'] = country;
      if (languages != null) updateData['languages'] = languages;
      if (profileImageUrl != null)
        updateData['profile_image_url'] = profileImageUrl;

      updateData['updated_at'] = DateTime.now().toIso8601String();

      await _client
          .from('user_profiles')
          .update(updateData)
          .eq('id', currentUser!.id);

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('Update user profile error: $error');
      }
      return false;
    }
  }

  // Check if email is verified
  Future<bool> isEmailVerified() async {
    try {
      final profile = await getUserProfile();
      return profile?['email_verified_at'] != null;
    } catch (error) {
      if (kDebugMode) {
        print('Check email verification error: $error');
      }
      return false;
    }
  }

  // OAuth sign in (Google, Apple, etc.)
  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    try {
      final success = await _client.auth.signInWithOAuth(provider);
      return success;
    } catch (error) {
      if (kDebugMode) {
        print('OAuth sign in error: $error');
      }
      return false;
    }
  }

  // Listen to auth state changes
  void onAuthStateChange(Function(AuthChangeEvent, Session?) callback) {
    _client.auth.onAuthStateChange.listen((data) {
      callback(data.event, data.session);
    });
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      if (kDebugMode) {
        print('Reset password error: $error');
      }
      rethrow;
    }
  }

  // Change password
  Future<UserResponse?> changePassword(String newPassword) async {
    try {
      return await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (error) {
      if (kDebugMode) {
        print('Change password error: $error');
      }
      rethrow;
    }
  }
}
