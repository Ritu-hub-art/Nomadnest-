import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmergencyContactsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> emergencyContacts;
  final Function(List<Map<String, dynamic>>) onContactsChanged;

  const EmergencyContactsWidget({
    super.key,
    required this.emergencyContacts,
    required this.onContactsChanged,
  });

  @override
  Widget build(BuildContext context) {
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
                  iconName: 'contacts',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Contacts',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Add up to 5 trusted contacts',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: emergencyContacts.length < 5 ? _addContact : null,
                  child: Text(
                    'Add',
                    style: GoogleFonts.inter(
                      color: emergencyContacts.length < 5
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (emergencyContacts.isNotEmpty)
            ...emergencyContacts
                .map((contact) => _buildContactTile(context, contact)),
          if (emergencyContacts.isEmpty)
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'No emergency contacts added yet',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, Map<String, dynamic> contact) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 6.w,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            child: Text(
              contact['name']
                  .toString()
                  .split(' ')
                  .map((e) => e[0])
                  .take(2)
                  .join(),
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        contact['name'],
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (contact['verified'] == true)
                      CustomIconWidget(
                        iconName: 'verified',
                        color: Colors.green.shade600,
                        size: 16,
                      ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  contact['phone'],
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  contact['relationship'],
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) =>
                _handleContactAction(context, contact, value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'verify', child: Text('Verify')),
              const PopupMenuItem(value: 'remove', child: Text('Remove')),
            ],
            child: const CustomIconWidget(
              iconName: 'more_vert',
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _addContact() {
    // Implementation for adding contact
  }

  void _handleContactAction(
      BuildContext context, Map<String, dynamic> contact, String action) {
    switch (action) {
      case 'edit':
        // Implementation for editing contact
        break;
      case 'verify':
        // Implementation for verifying contact
        break;
      case 'remove':
        final updatedContacts =
            List<Map<String, dynamic>>.from(emergencyContacts);
        updatedContacts.removeWhere((c) => c['id'] == contact['id']);
        onContactsChanged(updatedContacts);
        break;
    }
  }
}
