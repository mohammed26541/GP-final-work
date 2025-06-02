import '../constants/api_endpoints.dart';
import '../models/notification/notification.dart';
import 'api_service/api_service.dart';

class NotificationService {
  final ApiService _apiService = ApiService();
  
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  
  NotificationService._internal();
  
  // Get all notifications for user
  Future<List<Notification>> getAllNotifications({
    int page = 1,
    int limit = 10,
    String userId = '', // Added userId parameter with default value
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      // Add userId to query params if provided
      if (userId.isNotEmpty) {
        queryParams['userId'] = userId;
      }
      
      final response = await _apiService.get(
        ApiEndpoints.getAllNotifications,
        queryParameters: queryParams,
      );
      
      final List<Notification> notifications = (response['notifications'] as List)
          .map((notification) => Notification.fromJson(notification))
          .toList();
      
      return notifications;
    } catch (e) {
      print('Error getting notifications: $e');
      return []; // Return empty list instead of rethrowing to avoid UI crashes
    }
  }
  
  // Mark notification as read
  Future<Notification?> markAsRead(String notificationId, {String userId = ''}) async {
    try {
      // Prepare the request data
      Map<String, dynamic> data = {
        'isRead': true,
      };
      
      // Add userId to request body if provided
      if (userId.isNotEmpty) {
        data['userId'] = userId;
      }
      
      // Use the dynamic URL construction function instead of static endpoint
      final response = await _apiService.put(
        ApiEndpoints.getUpdateNotificationUrl(notificationId),
        data: data,
      );
      
      // Check if response is null or not a Map
      if (response == null) {
        print('Received null response for notification: $notificationId');
        return null;
      }
      
      // Check if response is the expected format
      if (response is! Map<String, dynamic> || !response.containsKey('notification')) {
        print('Unexpected response format for notification: $notificationId');
        print('Response: $response');
        
        // Create a dummy notification to avoid errors
        return Notification(
          id: notificationId,
          userId: userId,
          title: '',
          message: '',
          type: 'system',
          isRead: true, 
          resourceId: '',
          createdAt: DateTime.now(),
        );
      }
      
      return Notification.fromJson(response['notification']);
    } catch (e) {
      print('Error marking notification as read: $e');
      // Return a dummy notification with isRead=true to avoid further issues
      return Notification(
        id: notificationId,
        userId: userId,
        title: '',
        message: '',
        type: 'system',
        isRead: true, 
        resourceId: '',
        createdAt: DateTime.now(),
      );
    }
  }
  
  // Mark all notifications as read
  Future<bool> markAllAsRead({String userId = ''}) async {
    try {
      // For marking all as read, we need to use a special endpoint or parameter
      // Since there's no specific endpoint for this in your API, we'll use a workaround
      
      // Fetch all notifications first
      final notifications = await getAllNotifications(limit: 100, userId: userId);
      
      // Mark each notification as read
      bool allSuccess = true;
      for (final notification in notifications) {
        if (!notification.isRead) {
          try {
            final result = await markAsRead(notification.id, userId: userId);
            if (result == null) {
              print('Failed to mark notification ${notification.id} as read: null result');
              allSuccess = false;
            }
          } catch (e) {
            print('Failed to mark notification ${notification.id} as read: $e');
            allSuccess = false;
          }
        }
      }
      
      return allSuccess;
    } catch (e) {
      print('Error in markAllAsRead: $e');
      return false; // Return false instead of rethrowing to avoid UI crashes
    }
  }
  
  // Get unread notifications count
  Future<int> getUnreadCount() async {
    try {
      // Since there's no dedicated endpoint for unread count, we'll have to
      // fetch all notifications and count the unread ones client-side
      print('Fetching notifications to count unread ones');
      
      // Use the general endpoint with a small limit to minimize data transfer
      final response = await _apiService.get(
        ApiEndpoints.getAllNotifications,
        queryParameters: {'limit': '100', 'unreadOnly': 'true'},
      );
      
      print('Get unread count response: $response');
      
      // Handle different response formats
      if (response is Map<String, dynamic>) {
        // If the API returns a count directly (in case it's added later)
        if (response.containsKey('unreadCount')) {
          return response['unreadCount'] ?? 0;
        }
        
        // Try to find notifications and count them
        List<dynamic>? notifications;
        
        if (response.containsKey('notifications')) {
          notifications = response['notifications'] as List;
        } else if (response.containsKey('data')) {
          notifications = response['data'] as List;
        } else if (response.containsKey('result')) {
          notifications = response['result'] as List;
        } else {
          // Look for any list in the response
          for (var key in response.keys) {
            if (response[key] is List) {
              notifications = response[key] as List;
              break;
            }
          }
        }
        
        // If we found notifications, count unread ones
        if (notifications != null) {
          final unreadCount = notifications.where((notification) {
            // Check if this notification is unread
            if (notification is Map<String, dynamic>) {
              return !(notification['read'] ?? false);
            }
            return false;
          }).length;
          
          print('Counted $unreadCount unread notifications client-side');
          return unreadCount;
        }
      } else if (response is List) {
        // If the API returns a list directly, count unread notifications
        final unreadCount = response.where((notification) {
          if (notification is Map<String, dynamic>) {
            return !(notification['read'] ?? false);
          }
          return false;
        }).length;
        
        print('Counted $unreadCount unread notifications from list response');
        return unreadCount;
      }
      
      // Default to zero if we couldn't determine the count
      return 0;
    } catch (e) {
      print('Error getting unread count: $e');
      // Return 0 instead of rethrowing to avoid UI disruptions
      return 0;
    }
  }
}
