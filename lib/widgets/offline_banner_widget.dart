import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/connectivity_service.dart';

class OfflineBannerWidget extends StatefulWidget {
  final Widget child;

  const OfflineBannerWidget({
    super.key,
    required this.child,
  });

  @override
  State<OfflineBannerWidget> createState() => _OfflineBannerWidgetState();
}

class _OfflineBannerWidgetState extends State<OfflineBannerWidget> {
  final ConnectivityService _connectivity = ConnectivityService();
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _isOffline = _connectivity.isOffline;

    _connectivity.networkStatusStream.listen((status) {
      if (mounted) {
        setState(() {
          _isOffline = status == NetworkStatus.offline;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isOffline ? 40.0 : 0.0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _isOffline ? 1.0 : 0.0,
            child: Container(
              width: double.infinity,
              color: Colors.orange.shade600,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "You're offline. We'll retry automatically.",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
