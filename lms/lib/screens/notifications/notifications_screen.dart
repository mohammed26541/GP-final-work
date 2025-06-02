import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider/notification_provider.dart';
import '../../providers/auth_provider/auth_provider.dart';
import 'utils/notification_helper.dart';
import 'widgets/empty_notifications_view.dart';
import 'widgets/login_prompt_view.dart';
import 'widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to fetch notifications after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications();
    });
  }
  
  /// Sets the loading state
  void _setLoading(bool value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    }
  }
  
  /// Fetches notifications for the current user
  Future<void> _fetchNotifications() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.currentUser == null) return;
    
    await NotificationHelper.fetchNotifications(context, _setLoading);
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    
    // Show login prompt if user is not authenticated
    if (authProvider.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: const LoginPromptView(),
      );
    }
    
    final notifications = notificationProvider.notifications;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
              onPressed: () => NotificationHelper.markAllAsRead(context),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
                ? const EmptyNotificationsView()
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationItem(notification: notification);
                    },
                  ),
      ),
    );
  }
}
