import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BlockedUsersWidget extends StatefulWidget {
  final List<Map<String, dynamic>> blockedUsers;
  final Function(String) onUnblockUser;

  const BlockedUsersWidget({
    super.key,
    required this.blockedUsers,
    required this.onUnblockUser,
  });

  @override
  State<BlockedUsersWidget> createState() => _BlockedUsersWidgetState();
}

class _BlockedUsersWidgetState extends State<BlockedUsersWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.blockedUsers;
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = widget.blockedUsers
          .where(
              (user) => user['name'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blocked Users',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Manage users you have blocked from contacting you',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 2.h),

            // Search functionality
            if (widget.blockedUsers.isNotEmpty)
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search blocked users...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),

            if (widget.blockedUsers.isNotEmpty) SizedBox(height: 2.h),

            // Blocked users list
            if (_filteredUsers.isEmpty && widget.blockedUsers.isNotEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: AppTheme.textSecondaryLight,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No users found',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            else if (widget.blockedUsers.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.block_outlined,
                        size: 48,
                        color: AppTheme.textSecondaryLight,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No blocked users',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Users you block will appear here',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: _filteredUsers
                    .map((user) => _buildBlockedUserTile(user))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockedUserTile(Map<String, dynamic> user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(user['imageUrl']),
            onBackgroundImageError: (exception, stackTrace) {
              // Handle image loading errors gracefully
            },
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Blocked on ${user['blockedDate']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _showUnblockConfirmation(user),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              side: BorderSide(color: AppTheme.successLight),
              foregroundColor: AppTheme.successLight,
            ),
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }

  void _showUnblockConfirmation(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock User'),
        content: Text(
          'Are you sure you want to unblock ${user['name']}? They will be able to contact you again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onUnblockUser(user['id']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successLight,
            ),
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }
}
