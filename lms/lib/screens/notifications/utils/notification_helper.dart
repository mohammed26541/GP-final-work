import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/notification_provider/notification_provider.dart';

/// Helper class for fetching and managing notifications
class NotificationHelper {
  /// Fetches all notifications for the current user
  static Future<void> fetchNotifications(
    BuildContext context,
    Function setLoading,
  ) async {
    setLoading(true);
    
    try {
      // Fetch notifications
      await Provider.of<NotificationProvider>(context, listen: false).fetchAllNotifications();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setLoading(false);
      }
    }
  }
  
  /// Marks a single notification as read
  static Future<void> markAsRead(BuildContext context, String notificationId) async {
    try {
      final success = await Provider.of<NotificationProvider>(context, listen: false)
          .markAsRead(notificationId);
      
      if (success && context.mounted) {
        // Refresh unread count
        await Provider.of<NotificationProvider>(context, listen: false)
            .fetchUnreadCount();
      }
    } catch (e) {
      if (context.mounted) {
        // Use a post-frame callback to ensure we're not in the middle of a build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error marking notification as read: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    }
  }
  
  /// Marks all notifications as read
  static Future<void> markAllAsRead(BuildContext context) async {
    try {
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      final success = await notificationProvider.markAllAsRead();
      
      if (success && context.mounted) {
        // Use a post-frame callback to ensure we're not in the middle of a build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All notifications marked as read'),
                backgroundColor: Colors.green,
              ),
            );
          }
        });
      }
    } catch (e) {
      if (context.mounted) {
        // Use a post-frame callback to ensure we're not in the middle of a build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    }
  }
}
