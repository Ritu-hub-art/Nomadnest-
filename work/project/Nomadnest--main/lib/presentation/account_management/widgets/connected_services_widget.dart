import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ConnectedServicesWidget extends StatelessWidget {
  final Map<String, dynamic> accountData;
  final Function(String, bool) onServiceToggled;

  const ConnectedServicesWidget({
    super.key,
    required this.accountData,
    required this.onServiceToggled,
  });

  @override
  Widget build(BuildContext context) {
    final linkedServices =
        List<String>.from(accountData['socialMediaLinked'] ?? []);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'link',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Connected Services',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          _buildServiceTile(
              context, 'Google', linkedServices.contains('Google')),
          _buildServiceTile(
              context, 'Facebook', linkedServices.contains('Facebook')),
          _buildServiceTile(context, 'Apple', linkedServices.contains('Apple')),
          _buildServiceTile(
              context, 'Twitter', linkedServices.contains('Twitter')),
        ],
      ),
    );
  }

  Widget _buildServiceTile(
      BuildContext context, String service, bool isConnected) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      leading: _getServiceIcon(service),
      title: Text(
        service,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        isConnected ? 'Connected' : 'Not connected',
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: isConnected
              ? Colors.green.shade600
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isConnected
          ? TextButton(
              onPressed: () => _showDisconnectConfirmation(context, service),
              child: Text(
                'Disconnect',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : TextButton(
              onPressed: () => onServiceToggled(service, true),
              child: Text(
                'Connect',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
    );
  }

  Widget _getServiceIcon(String service) {
    String iconName;
    Color? iconColor;

    switch (service.toLowerCase()) {
      case 'google':
        iconName = 'search';
        iconColor = Colors.red;
        break;
      case 'facebook':
        iconName = 'facebook';
        iconColor = Colors.blue;
        break;
      case 'apple':
        iconName = 'apple';
        iconColor = Colors.black;
        break;
      case 'twitter':
        iconName = 'alternate_email';
        iconColor = Colors.blue;
        break;
      default:
        iconName = 'link';
        iconColor = null;
    }

    return CustomIconWidget(
      iconName: iconName,
      color: iconColor,
      size: 24,
    );
  }

  void _showDisconnectConfirmation(BuildContext context, String service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disconnect $service'),
        content:
            Text('Are you sure you want to disconnect your $service account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onServiceToggled(service, false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }
}