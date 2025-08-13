import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/environment_service.dart';
import '../services/network_service.dart';
import '../services/connectivity_service.dart';

class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  final NetworkService _networkService = NetworkService();
  final ConnectivityService _connectivity = ConnectivityService();
  bool _isRunningHealthCheck = false;
  String? _healthCheckResult;
  DateTime? _lastHealthCheck;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(
          child: Text('Diagnostics only available in debug mode'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Network Diagnostics',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEnvironmentSection(),
            const SizedBox(height: 24),
            _buildConnectivitySection(),
            const SizedBox(height: 24),
            _buildHealthCheckSection(),
            const SizedBox(height: 24),
            _buildErrorLogsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Environment Configuration',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('API Base URL', _networkService.effectiveBaseUrl),
            _buildInfoRow('Timeout', '${_networkService.effectiveTimeout}ms'),
            _buildInfoRow(
                'HTTPS Enabled', EnvironmentService.useHttps.toString()),
            _buildInfoRow('Health Endpoint', EnvironmentService.healthEndpoint),
            _buildInfoRow(
                'Debug Network', EnvironmentService.debugNetwork.toString()),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _copyToClipboard(
                  'API Base URL: ${_networkService.effectiveBaseUrl}'),
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Copy Base URL'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectivitySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connectivity Status',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<NetworkStatus>(
              stream: _connectivity.networkStatusStream,
              initialData: _connectivity.currentStatus,
              builder: (context, snapshot) {
                final status = snapshot.data ?? NetworkStatus.unknown;
                final statusText =
                    status.toString().split('.').last.toUpperCase();
                final statusColor = status == NetworkStatus.online
                    ? Colors.green
                    : status == NetworkStatus.offline
                        ? Colors.red
                        : Colors.orange;

                return Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      statusText,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCheckSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Check',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (_lastHealthCheck != null) ...[
              _buildInfoRow('Last Check', _formatDateTime(_lastHealthCheck!)),
              _buildInfoRow('Result', _healthCheckResult ?? 'Unknown'),
              const SizedBox(height: 8),
            ],
            ElevatedButton.icon(
              onPressed: _isRunningHealthCheck ? null : _runHealthCheck,
              icon: _isRunningHealthCheck
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.health_and_safety, size: 16),
              label: Text(
                  _isRunningHealthCheck ? 'Checking...' : 'Run Health Check'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorLogsSection() {
    final logs = _networkService.errorLogs;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Errors (${logs.length})',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (logs.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _copyToClipboard(logs.toString()),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy Logs'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (logs.isEmpty)
              Text(
                'No errors logged',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Column(
                children: logs
                    .take(5)
                    .map((log) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log['endpoint'] ?? 'Unknown endpoint',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${log['error_type']} - Status: ${log['status'] ?? 'N/A'}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              Text(
                                _formatDateTime(
                                    DateTime.parse(log['timestamp'])),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runHealthCheck() async {
    setState(() {
      _isRunningHealthCheck = true;
    });

    try {
      final stopwatch = Stopwatch()..start();
      final isHealthy = await _networkService.healthCheck();
      stopwatch.stop();

      setState(() {
        _healthCheckResult = isHealthy
            ? '✅ Healthy (${stopwatch.elapsedMilliseconds}ms)'
            : '❌ Failed (${stopwatch.elapsedMilliseconds}ms)';
        _lastHealthCheck = DateTime.now();
        _isRunningHealthCheck = false;
      });

      Fluttertoast.showToast(
        msg: isHealthy ? 'Health check passed!' : 'Health check failed!',
        backgroundColor: isHealthy ? Colors.green : Colors.red,
      );
    } catch (e) {
      setState(() {
        _healthCheckResult = '❌ Error: $e';
        _lastHealthCheck = DateTime.now();
        _isRunningHealthCheck = false;
      });

      Fluttertoast.showToast(
        msg: 'Health check error!',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(msg: 'Copied to clipboard');
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
