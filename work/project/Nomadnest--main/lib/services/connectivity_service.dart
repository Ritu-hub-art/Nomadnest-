import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum NetworkStatus { online, offline, unknown }

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  final StreamController<NetworkStatus> _networkStatusController =
      StreamController<NetworkStatus>.broadcast();
  Stream<NetworkStatus> get networkStatusStream =>
      _networkStatusController.stream;

  NetworkStatus _currentStatus = NetworkStatus.unknown;
  NetworkStatus get currentStatus => _currentStatus;

  bool get isOnline => _currentStatus == NetworkStatus.online;
  bool get isOffline => _currentStatus == NetworkStatus.offline;

  Future<void> initialize() async {
    // Check initial connectivity
    await _updateConnectivityStatus();

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        await _updateConnectivityStatus();
      },
    );
  }

  Future<void> _updateConnectivityStatus() async {
    try {
      final List<ConnectivityResult> connectivityResults =
          await _connectivity.checkConnectivity();

      NetworkStatus newStatus = NetworkStatus.offline;

      for (final ConnectivityResult result in connectivityResults) {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet) {
          newStatus = NetworkStatus.online;
          break;
        }
      }

      if (_currentStatus != newStatus) {
        _currentStatus = newStatus;
        _networkStatusController.add(_currentStatus);

        if (kDebugMode) {
          print('Network status changed: $_currentStatus');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking connectivity: $e');
      }
      _currentStatus = NetworkStatus.unknown;
      _networkStatusController.add(_currentStatus);
    }
  }

  Future<bool> hasConnection() async {
    await _updateConnectivityStatus();
    return isOnline;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _networkStatusController.close();
  }
}
