import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_context_menu_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/typing_indicator_widget.dart';

class MessagingInterface extends StatefulWidget {
  const MessagingInterface({Key? key}) : super(key: key);

  @override
  State<MessagingInterface> createState() => _MessagingInterfaceState();
}

class _MessagingInterfaceState extends State<MessagingInterface> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLocationSharing = false;
  bool _isTyping = false;
  String _currentUserId = 'user_1';
  Map<String, dynamic>? _selectedMessage;

  // Mock conversation data
  final Map<String, dynamic> _conversationData = {
    "conversationId": "conv_001",
    "participants": [
      {
        "id": "user_1",
        "name": "Alex Chen",
        "avatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "isOnline": true,
        "lastSeen": null,
      },
      {
        "id": "user_2",
        "name": "Maria Rodriguez",
        "avatar":
            "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
        "isOnline": false,
        "lastSeen": DateTime.now().subtract(const Duration(minutes: 15)),
      }
    ],
    "isGroupChat": false,
    "chatType": "host_traveler",
  };

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _simulateTyping();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    final mockMessages = [
      {
        "id": "msg_001",
        "senderId": "user_2",
        "senderName": "Maria Rodriguez",
        "senderAvatar":
            "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
        "type": "text",
        "content":
            "Hi Alex! Thanks for accepting my hosting request. I'm really excited to visit Barcelona!",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
        "isRead": true,
      },
      {
        "id": "msg_002",
        "senderId": "user_1",
        "senderName": "Alex Chen",
        "senderAvatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "type": "text",
        "content":
            "Welcome to Barcelona! I'm happy to host you. When are you planning to arrive?",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        "isRead": true,
      },
      {
        "id": "msg_003",
        "senderId": "user_2",
        "senderName": "Maria Rodriguez",
        "senderAvatar":
            "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
        "type": "text",
        "content":
            "I'll be arriving tomorrow evening around 7 PM. My flight lands at El Prat airport.",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        "isRead": true,
      },
      {
        "id": "msg_004",
        "senderId": "user_1",
        "senderName": "Alex Chen",
        "senderAvatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "type": "location",
        "content": "Here's my location for easy pickup",
        "locationName": "Plaça de Catalunya, Barcelona",
        "latitude": 41.3851,
        "longitude": 2.1734,
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        "isRead": true,
      },
      {
        "id": "msg_005",
        "senderId": "user_2",
        "senderName": "Maria Rodriguez",
        "senderAvatar":
            "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
        "type": "image",
        "imageUrl":
            "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop",
        "caption": "This is my flight details. See you soon!",
        "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
        "isRead": true,
      },
      {
        "id": "msg_006",
        "senderId": "user_1",
        "senderName": "Alex Chen",
        "senderAvatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "type": "safety_checkin",
        "content": "Safety check-in completed",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 30)),
        "isRead": true,
      },
      {
        "id": "msg_007",
        "senderId": "user_2",
        "senderName": "Maria Rodriguez",
        "senderAvatar":
            "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
        "type": "text",
        "content":
            "Perfect! I'll take the Aerobus to Plaça de Catalunya. Should be there around 8:30 PM.",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
        "isRead": false,
      },
    ];

    setState(() {
      _messages.addAll(mockMessages);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _simulateTyping() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
            });
          }
        });
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String content) {
    final newMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "senderId": _currentUserId,
      "senderName": "Alex Chen",
      "senderAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "type": "text",
      "content": content,
      "timestamp": DateTime.now(),
      "isRead": false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate message delivery
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          final messageIndex =
              _messages.indexWhere((msg) => msg['id'] == newMessage['id']);
          if (messageIndex != -1) {
            _messages[messageIndex]['isRead'] = true;
          }
        });
      }
    });
  }

  void _handleAttachImage() {
    // Simulate image attachment
    final newMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "senderId": _currentUserId,
      "senderName": "Alex Chen",
      "senderAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "type": "image",
      "imageUrl":
          "https://images.unsplash.com/photo-1551632811-561732d1e306?w=400&h=300&fit=crop",
      "caption": "Here's a photo of my place!",
      "timestamp": DateTime.now(),
      "isRead": false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _handleShareLocation() {
    setState(() {
      _isLocationSharing = !_isLocationSharing;
    });

    if (_isLocationSharing) {
      final newMessage = {
        "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
        "senderId": _currentUserId,
        "senderName": "Alex Chen",
        "senderAvatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "type": "location",
        "content": "Live location shared",
        "locationName": "Current Location",
        "latitude": 41.3851,
        "longitude": 2.1734,
        "timestamp": DateTime.now(),
        "isRead": false,
      };

      setState(() {
        _messages.add(newMessage);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _handleSafetyCheckin() {
    final newMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "senderId": _currentUserId,
      "senderName": "Alex Chen",
      "senderAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "type": "safety_checkin",
      "content": "Safety check-in completed",
      "timestamp": DateTime.now(),
      "isRead": false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _showMessageContextMenu(Map<String, dynamic> message, Offset position) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: MessageContextMenuWidget(
              message: message,
              isMe: message['senderId'] == _currentUserId,
              onCopy: () => _copyMessage(message),
              onDelete: () => _deleteMessage(message),
              onReport: () => _reportMessage(message),
              onReply: () => _replyToMessage(message),
            ),
          ),
        ],
      ),
    );
  }

  void _copyMessage(Map<String, dynamic> message) {
    if (message['type'] == 'text') {
      Clipboard.setData(ClipboardData(text: message['content'] as String));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message copied to clipboard'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteMessage(Map<String, dynamic> message) {
    setState(() {
      _messages.removeWhere((msg) => msg['id'] == message['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message deleted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportMessage(Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Message'),
        content: Text(
            'Are you sure you want to report this message for inappropriate content?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Message reported successfully'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text('Report'),
          ),
        ],
      ),
    );
  }

  void _replyToMessage(Map<String, dynamic> message) {
    setState(() {
      _selectedMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final otherParticipant = (_conversationData['participants'] as List)
        .firstWhere((p) => p['id'] != _currentUserId);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 4.w,
              child: CustomImageWidget(
                imageUrl: otherParticipant['avatar'] as String,
                width: 8.w,
                height: 8.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherParticipant['name'] as String,
                    style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    otherParticipant['isOnline'] as bool
                        ? 'Online'
                        : 'Last seen ${_formatLastSeen(otherParticipant['lastSeen'] as DateTime?)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: otherParticipant['isOnline'] as bool
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to user profile
              Navigator.pushNamed(context, '/user-profile');
            },
            icon: CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              // Show more options
              _showMoreOptions();
            },
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Load more messages
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return TypingIndicatorWidget(
                      userName: otherParticipant['name'] as String,
                      userAvatar: otherParticipant['avatar'] as String,
                    );
                  }

                  final message = _messages[index];
                  final isMe = message['senderId'] == _currentUserId;

                  return GestureDetector(
                    onLongPressStart: (details) {
                      _showMessageContextMenu(message, details.globalPosition);
                    },
                    child: MessageBubbleWidget(
                      message: message,
                      isMe: isMe,
                      onLongPress: () {
                        // Handle long press if needed
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          MessageInputWidget(
            onSendMessage: _sendMessage,
            onAttachImage: _handleAttachImage,
            onShareLocation: _handleShareLocation,
            onSafetyCheckin: _handleSafetyCheckin,
            isLocationSharing: _isLocationSharing,
          ),
        ],
      ),
    );
  }

  String _formatLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) return 'recently';

    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            _buildMoreOption(
              icon: 'search',
              label: 'Search Messages',
              onTap: () {
                Navigator.pop(context);
                // Implement search functionality
              },
            ),
            _buildMoreOption(
              icon: 'block',
              label: 'Block User',
              onTap: () {
                Navigator.pop(context);
                _showBlockUserDialog();
              },
            ),
            _buildMoreOption(
              icon: 'report',
              label: 'Report Conversation',
              onTap: () {
                Navigator.pop(context);
                _showReportDialog();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 20.sp,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block User'),
        content: Text(
            'Are you sure you want to block this user? You won\'t receive messages from them anymore.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User blocked successfully'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Conversation'),
        content: Text(
            'Are you sure you want to report this conversation for inappropriate content?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Conversation reported successfully'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text('Report'),
          ),
        ],
      ),
    );
  }
}
