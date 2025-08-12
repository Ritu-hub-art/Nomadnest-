import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class PrivacySafetyWidget extends StatelessWidget {
  final Map<String, dynamic> userSettings;
  final List<Map<String, dynamic>> blockedUsers;
  final Function(String, dynamic) onSettingChanged;
  final Function(String) onUnblockUser;

  const PrivacySafetyWidget({
    super.key,
    required this.userSettings,
    required this.blockedUsers,
    required this.onSettingChanged,
    required this.onUnblockUser,
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
          // Section header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'shield',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Privacy & Safety',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            thickness: 1,
            height: 1,
          ),

          // Profile visibility
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'visibility',
              size: 24,
            ),
            title: Text(
              'Profile Visibility',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              _getVisibilityText(userSettings['profileVisibility']),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showProfileVisibilityDialog(context),
            minTileHeight: 6.h,
          ),

          // Location sharing
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'location_on',
              size: 24,
            ),
            title: Text(
              'Location Sharing',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              _getLocationSharingText(userSettings['locationSharing']),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showLocationSharingDialog(context),
            minTileHeight: 6.h,
          ),

          // Show online status
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'circle',
              size: 24,
            ),
            title: Text(
              'Show Online Status',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Let others see when you\'re online',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: userSettings['showOnlineStatus'],
              onChanged: (value) {
                onSettingChanged('showOnlineStatus', value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            minTileHeight: 6.h,
          ),

          // Allow direct messages
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'message',
              size: 24,
            ),
            title: Text(
              'Direct Messages',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Allow others to message you directly',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: userSettings['allowDirectMessages'],
              onChanged: (value) {
                onSettingChanged('allowDirectMessages', value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            minTileHeight: 6.h,
          ),

          // Blocked users
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'block',
              size: 24,
            ),
            title: Text(
              'Blocked Users',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              '${blockedUsers.length} blocked user${blockedUsers.length != 1 ? 's' : ''}',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showBlockedUsersDialog(context),
            minTileHeight: 6.h,
          ),

          // Report & Safety
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'flag',
              size: 24,
            ),
            title: Text(
              'Report & Safety Center',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Report issues and safety resources',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showSafetyCenterDialog(context),
            minTileHeight: 6.h,
          ),
        ],
      ),
    );
  }

  String _getVisibilityText(String visibility) {
    switch (visibility) {
      case 'public':
        return 'Visible to everyone';
      case 'friends':
        return 'Friends only';
      case 'private':
        return 'Private profile';
      default:
        return 'Public';
    }
  }

  String _getLocationSharingText(String locationSharing) {
    switch (locationSharing) {
      case 'everyone':
        return 'Share with everyone';
      case 'friends':
        return 'Friends only';
      case 'nobody':
        return 'Don\'t share location';
      default:
        return 'Friends only';
    }
  }

  void _showProfileVisibilityDialog(BuildContext context) {
    String selectedVisibility = userSettings['profileVisibility'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Profile Visibility',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Public', style: GoogleFonts.inter()),
                subtitle: Text('Anyone can see your profile',
                    style: GoogleFonts.inter()),
                value: 'public',
                groupValue: selectedVisibility,
                onChanged: (value) =>
                    setState(() => selectedVisibility = value!),
              ),
              RadioListTile<String>(
                title: Text('Friends Only', style: GoogleFonts.inter()),
                subtitle: Text('Only your connections can see your profile',
                    style: GoogleFonts.inter()),
                value: 'friends',
                groupValue: selectedVisibility,
                onChanged: (value) =>
                    setState(() => selectedVisibility = value!),
              ),
              RadioListTile<String>(
                title: Text('Private', style: GoogleFonts.inter()),
                subtitle: Text('Your profile is hidden from search',
                    style: GoogleFonts.inter()),
                value: 'private',
                groupValue: selectedVisibility,
                onChanged: (value) =>
                    setState(() => selectedVisibility = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onSettingChanged('profileVisibility', selectedVisibility);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSharingDialog(BuildContext context) {
    String selectedSharing = userSettings['locationSharing'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Location Sharing',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Everyone', style: GoogleFonts.inter()),
                subtitle: Text('Share your location with all users',
                    style: GoogleFonts.inter()),
                value: 'everyone',
                groupValue: selectedSharing,
                onChanged: (value) => setState(() => selectedSharing = value!),
              ),
              RadioListTile<String>(
                title: Text('Friends Only', style: GoogleFonts.inter()),
                subtitle: Text('Only friends can see your location',
                    style: GoogleFonts.inter()),
                value: 'friends',
                groupValue: selectedSharing,
                onChanged: (value) => setState(() => selectedSharing = value!),
              ),
              RadioListTile<String>(
                title: Text('Nobody', style: GoogleFonts.inter()),
                subtitle: Text('Don\'t share your location',
                    style: GoogleFonts.inter()),
                value: 'nobody',
                groupValue: selectedSharing,
                onChanged: (value) => setState(() => selectedSharing = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onSettingChanged('locationSharing', selectedSharing);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockedUsersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Blocked Users',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: blockedUsers.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomIconWidget(
                        iconName: 'block',
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No blocked users',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: blockedUsers.length,
                  itemBuilder: (context, index) {
                    final user = blockedUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['avatar']),
                      ),
                      title: Text(
                        user['name'],
                        style: GoogleFonts.inter(fontSize: 16.sp),
                      ),
                      subtitle: Text(
                        'Blocked ${user['blockedDate']}',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          onUnblockUser(user['id']);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Unblock',
                          style: GoogleFonts.inter(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Done',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSafetyCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Report & Safety Center',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'report',
                size: 24,
              ),
              title: Text(
                'Report a Problem',
                style: GoogleFonts.inter(fontSize: 16.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to report form
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'help',
                size: 24,
              ),
              title: Text(
                'Safety Guidelines',
                style: GoogleFonts.inter(fontSize: 16.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to safety guidelines
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'support_agent',
                size: 24,
              ),
              title: Text(
                'Contact Support',
                style: GoogleFonts.inter(fontSize: 16.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to support
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
