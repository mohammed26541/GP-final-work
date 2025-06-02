import 'package:flutter/material.dart';
import '../../models/notification/notification.dart' as models;
import '../../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  
  List<models.Notification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<models.Notification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Fetch all notifications
  Future<void> fetchAllNotifications() async {
    _setLoading(true);
    try {
      final notifications = await _notificationService.getAllNotifications();
      
      _notifications = notifications;
      _updateUnreadCount();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  // Fetch unread count
  Future<void> fetchUnreadCount() async {
    try {
      final count = await _notificationService.getUnreadCount();
      
      _unreadCount = count;
      notifyListeners();
    } catch (e) {
      // Don't set loading or error for this lightweight call
      print('Error fetching unread count: ${e.toString()}');
    }
  }
  
  // Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    _setLoading(true);
    try {
      final updatedNotification = await _notificationService.markAsRead(notificationId);
      
      // Update the notification in the list
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1 && updatedNotification != null) {
        _notifications[index] = updatedNotification;
      } else if (index != -1) {
        // If the notification is null but we found it in our list, mark it as read locally
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
      
      _updateUnreadCount();
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Mark all notifications as read
  Future<bool> markAllAsRead() async {
    _setLoading(true);
    try {
      final success = await _notificationService.markAllAsRead();
      
      if (success) {
        // Update all notifications in the list
        _notifications = _notifications.map((notification) => 
          notification.copyWith(isRead: true)
        ).toList();
        
        _unreadCount = 0;
      }
      
      _setError(null);
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Helper methods
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
  
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
  
  void _updateUnreadCount() {
    _unreadCount = _notifications.where((notification) => !notification.isRead).length;
    notifyListeners();
  }
}
