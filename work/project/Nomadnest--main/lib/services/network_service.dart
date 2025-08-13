import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './connectivity_service.dart';
import './environment_service.dart';

enum NetworkErrorType {
  offline,
  timeout,
  tlsHandshake,
  dnsResolution,
  clientError, // 4xx
  serverError, // 5xx
  unknown
}

class NetworkError {
  final NetworkErrorType type;
  final String message;
  final String userMessage;
  final int? statusCode;
  final String endpoint;
  final DateTime timestamp;

  NetworkError({
    required this.type,
    required this.message,
    required this.userMessage,
    this.statusCode,
    required this.endpoint,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toLogMap() => {
        'timestamp': timestamp.toIso8601String(),
        'endpoint': endpoint,
        'status': statusCode,
        'error_type': type.toString(),
        'message': message,
        'duration': null, // Will be set by interceptor
        'attempt_count': null, // Will be set by retry logic
      };
}

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  late Dio _dio;
  final ConnectivityService _connectivity = ConnectivityService();
  final List<Map<String, dynamic>> _errorLogs = [];

  Future<void> initialize() async {
    await EnvironmentService.initialize();
    await _connectivity.initialize();
    _setupDio();
  }

  void _setupDio() {
    _dio = Dio(BaseOptions(
      baseUrl: EnvironmentService.apiBaseUrl,
      connectTimeout: Duration(milliseconds: EnvironmentService.apiTimeout),
      receiveTimeout: Duration(milliseconds: EnvironmentService.apiTimeout),
      sendTimeout: Duration(milliseconds: EnvironmentService.apiTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(_RetryInterceptor());
    if (EnvironmentService.enableRequestLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
    _dio.interceptors.add(_ErrorHandlingInterceptor());
  }

  // Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get(EnvironmentService.healthEndpoint);
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Health check failed: $e');
      }
      return false;
    }
  }

  // Main request method
  Future<Response<T>> request<T>(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      // Check connectivity first
      if (!_connectivity.isOnline) {
        throw NetworkError(
          type: NetworkErrorType.offline,
          message: 'No internet connection',
          userMessage: 'No internet connection. Check Wi-Fi or mobile data.',
          endpoint: endpoint,
        );
      }

      final Response<T> response;
      switch (method.toUpperCase()) {
        case 'POST':
          response = await _dio.post<T>(endpoint,
              data: data, queryParameters: queryParameters, options: options);
          break;
        case 'PUT':
          response = await _dio.put<T>(endpoint,
              data: data, queryParameters: queryParameters, options: options);
          break;
        case 'DELETE':
          response = await _dio.delete<T>(endpoint,
              queryParameters: queryParameters, options: options);
          break;
        default:
          response = await _dio.get<T>(endpoint,
              queryParameters: queryParameters, options: options);
      }

      return response;
    } catch (e) {
      final networkError = _processError(e, endpoint);
      _logError(networkError);
      _showUserError(networkError);
      rethrow;
    }
  }

  NetworkError _processError(dynamic error, String endpoint) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return NetworkError(
            type: NetworkErrorType.timeout,
            message: 'Request timeout: ${error.message}',
            userMessage: 'Server took too long to respond. Tap to retry.',
            endpoint: endpoint,
          );

        case DioExceptionType.connectionError:
          if (error.error is SocketException) {
            final socketError = error.error as SocketException;
            if (socketError.osError?.errorCode == 7) {
              // No address associated with hostname
              return NetworkError(
                type: NetworkErrorType.dnsResolution,
                message: 'DNS resolution failed: ${socketError.message}',
                userMessage:
                    'Cannot reach server. Please check your connection.',
                endpoint: endpoint,
              );
            } else if (socketError.osError?.errorCode == 111) {
              // Connection refused
              return NetworkError(
                type: NetworkErrorType.serverError,
                message: 'Connection refused: ${socketError.message}',
                userMessage:
                    'Server is having trouble. We\'re on it—try again in a moment.',
                endpoint: endpoint,
              );
            }
          }

          if (error.message?.toLowerCase().contains('certificate') == true ||
              error.message?.toLowerCase().contains('handshake') == true ||
              error.message?.toLowerCase().contains('tls') == true) {
            return NetworkError(
              type: NetworkErrorType.tlsHandshake,
              message: 'TLS handshake failed: ${error.message}',
              userMessage:
                  'Secure connection failed. Please update the app or try again.',
              endpoint: endpoint,
            );
          }

          return NetworkError(
            type: NetworkErrorType.unknown,
            message: 'Connection error: ${error.message}',
            userMessage:
                'Connection failed. Please check your internet connection.',
            endpoint: endpoint,
          );

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          if (statusCode >= 400 && statusCode < 500) {
            return NetworkError(
              type: NetworkErrorType.clientError,
              message: 'Client error: ${error.response?.statusMessage}',
              userMessage: statusCode == 401
                  ? 'Please log in again.'
                  : 'Request failed. Please try again.',
              statusCode: statusCode,
              endpoint: endpoint,
            );
          } else if (statusCode >= 500) {
            return NetworkError(
              type: NetworkErrorType.serverError,
              message: 'Server error: ${error.response?.statusMessage}',
              userMessage:
                  'Server is having trouble. We\'re on it—try again in a moment.',
              statusCode: statusCode,
              endpoint: endpoint,
            );
          }
          break;

        case DioExceptionType.cancel:
          return NetworkError(
            type: NetworkErrorType.unknown,
            message: 'Request was cancelled',
            userMessage: 'Request was cancelled.',
            endpoint: endpoint,
          );

        default:
          return NetworkError(
            type: NetworkErrorType.unknown,
            message: 'Unknown error: ${error.message}',
            userMessage: 'Something went wrong. Please try again.',
            endpoint: endpoint,
          );
      }
    }

    return NetworkError(
      type: NetworkErrorType.unknown,
      message: 'Unexpected error: $error',
      userMessage: 'Something went wrong. Please try again.',
      endpoint: endpoint,
    );
  }

  void _logError(NetworkError error) {
    final logEntry = error.toLogMap();
    _errorLogs.add(logEntry);

    // Keep only last 50 errors
    if (_errorLogs.length > 50) {
      _errorLogs.removeAt(0);
    }

    if (kDebugMode) {
      print('Network Error: ${jsonEncode(logEntry)}');
    }
  }

  void _showUserError(NetworkError error) {
    if (!_connectivity.isOffline) {
      Fluttertoast.showToast(
        msg: error.userMessage,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // Getters for diagnostics
  List<Map<String, dynamic>> get errorLogs => List.unmodifiable(_errorLogs);
  String get effectiveBaseUrl => _dio.options.baseUrl;
  int get effectiveTimeout => _dio.options.connectTimeout?.inMilliseconds ?? 0;
}

// Retry interceptor for idempotent requests
class _RetryInterceptor extends Interceptor {
  static const int maxRetries = 3;
  static const List<int> retryDelays = [0, 1000, 3000]; // 0s, 1s, 3s

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] == null) {
      await _retryRequest(err, handler);
      return;
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Only retry idempotent methods
    final method = err.requestOptions.method.toUpperCase();
    if (!['GET', 'HEAD'].contains(method)) return false;

    // Only retry for network errors and timeouts
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }

  Future<void> _retryRequest(
      DioException err, ErrorInterceptorHandler handler) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      if (retryCount > 0) {
        await Future.delayed(
            Duration(milliseconds: retryDelays[retryCount - 1]));
      }

      try {
        final requestOptions = err.requestOptions
          ..extra['retryCount'] = retryCount + 1;
        final response = await Dio().request(
          requestOptions.path,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          ),
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );
        handler.resolve(response);
        return;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          handler.next(err);
          return;
        }
      }
    }
  }
}

// Error handling interceptor
class _ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode && EnvironmentService.debugNetwork) {
      print(
          'Request failed: ${err.requestOptions.method} ${err.requestOptions.path}');
      if (err.response != null) {
        print('Status: ${err.response?.statusCode}');
        print('Data: ${err.response?.data}');
      }
    }
    handler.next(err);
  }
}
