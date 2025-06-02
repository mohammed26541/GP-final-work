import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/course/course.dart';
import '../../providers/course_provider/course_provider.dart';
import '../../providers/category_provider/category_provider.dart';
import '../../providers/notification_provider/notification_provider.dart';
import '../../providers/order_provider/order_provider.dart';
import 'realtime_service.dart';

/// Manager class that connects realtime updates to providers
class RealtimeUpdateManager {
  static final RealtimeUpdateManager _instance = RealtimeUpdateManager._internal();
  final RealtimeService _realtimeService = RealtimeService();
  
  // Stream subscriptions
  StreamSubscription? _courseSubscription;
  StreamSubscription? _categorySubscription;
  StreamSubscription? _notificationSubscription;
  StreamSubscription? _orderSubscription;
  
  // Provider references
  CourseProvider? _courseProvider;
  CategoryProvider? _categoryProvider;
  NotificationProvider? _notificationProvider;
  OrderProvider? _orderProvider;
  
  // Flag to track initialization
  bool _isInitialized = false;
  
  factory RealtimeUpdateManager() {
    return _instance;
  }
  
  RealtimeUpdateManager._internal();
  
  /// Initialize the manager with provider references
  void initialize({
    CourseProvider? courseProvider,
    CategoryProvider? categoryProvider,
    NotificationProvider? notificationProvider,
    OrderProvider? orderProvider,
  }) {
    _courseProvider = courseProvider;
    _categoryProvider = categoryProvider;
    _notificationProvider = notificationProvider;
    _orderProvider = orderProvider;
    
    if (!_isInitialized) {
      _setupSubscriptions();
      _isInitialized = true;
      print('🔄 RealtimeUpdateManager initialized');
    }
  }
  
  /// Setup stream subscriptions
  void _setupSubscriptions() {
    // Course updates
    if (_courseProvider != null) {
      _courseSubscription = _realtimeService.courseStream.listen((update) {
        _handleCourseUpdate(update);
      });
    }
    
    // Category updates
    if (_categoryProvider != null) {
      _categorySubscription = _realtimeService.categoryStream.listen((update) {
        _handleCategoryUpdate(update);
      });
    }
    
    // Notification updates
    if (_notificationProvider != null) {
      _notificationSubscription = _realtimeService.notificationStream.listen((update) {
        _handleNotificationUpdate(update);
      });
    }
    
    // Order updates
    if (_orderProvider != null) {
      _orderSubscription = _realtimeService.orderStream.listen((update) {
        _handleOrderUpdate(update);
      });
    }
  }
  
  /// Handle course updates
  void _handleCourseUpdate(Map<String, dynamic> update) {
    final String action = update['action'];
    final dynamic payload = update['payload'];
    
    if (_courseProvider == null) return;
    
    switch (action) {
      case 'create':
        // Convert payload to Course object
        final Course newCourse = Course.fromJson(payload);
        
        // Update provider lists
        _courseProvider!.addCourseToLists(newCourse);
        break;
        
      case 'update':
        // Convert payload to Course object
        final Course updatedCourse = Course.fromJson(payload);
        
        // Update provider lists
        _courseProvider!.updateCourseInLists(updatedCourse);
        break;
        
      case 'delete':
        // Get course ID from payload
        final String courseId = payload['id'];
        
        // Remove from provider lists
        _courseProvider!.removeCourseFromLists(courseId);
        break;
    }
  }
  
  /// Handle category updates
  void _handleCategoryUpdate(Map<String, dynamic> update) {
    final String action = update['action'];
    // We're not using payload directly but logging it for debugging
    final dynamic payload = update['payload'];
    debugPrint('📁 Category $action event received: ${payload['id'] ?? 'unknown'}');
    
    if (_categoryProvider == null) return;
    
    switch (action) {
      case 'create':
        // For create events, we'll just trigger a refresh of all categories
        // since CategoryProvider doesn't have an add method
        _categoryProvider!.fetchAllCategories();
        break;
        
      case 'update':
        // For update events, we'll just trigger a refresh of all categories
        // since CategoryProvider doesn't have an update method
        _categoryProvider!.fetchAllCategories();
        break;
        
      case 'delete':
        // For delete events, we'll just trigger a refresh of all categories
        // since CategoryProvider doesn't have a remove method
        _categoryProvider!.fetchAllCategories();
        break;
    }
  }
  
  /// Handle notification updates
  void _handleNotificationUpdate(Map<String, dynamic> update) {
    final String action = update['action'];
    final dynamic payload = update['payload'];
    
    if (_notificationProvider == null) return;
    
    // For all notification events, we'll trigger a refresh of notifications
    // This is a simplified approach since we don't have access to the actual methods
    // in the NotificationProvider
    
    // In a real implementation, you would add specific methods to NotificationProvider
    // to handle these events (addNotification, updateNotification, removeNotification)
    
    // For now, we'll just log the event and let the provider handle refreshing data
    debugPrint('📣 Notification $action event received: ${payload['id'] ?? 'unknown'}');
    
    // Trigger a refresh of notifications (assuming this method exists)
    // If it doesn't exist, you'll need to implement it in NotificationProvider
    try {
      // This is a placeholder - replace with actual method when available
      // _notificationProvider!.fetchNotifications();
    } catch (e) {
      debugPrint('❌ Error refreshing notifications: $e');
    }
  }
  
  /// Handle order updates
  void _handleOrderUpdate(Map<String, dynamic> update) {
    final String action = update['action'];
    final dynamic payload = update['payload'];
    
    if (_orderProvider == null) return;
    
    // For all order events, we'll trigger a refresh of orders
    // This is a simplified approach since we don't have access to the actual methods
    // in the OrderProvider
    
    // In a real implementation, you would add specific methods to OrderProvider
    // to handle these events (addOrder, updateOrder, removeOrder)
    
    // For now, we'll just log the event and let the provider handle refreshing data
    debugPrint('🛒 Order $action event received: ${payload['id'] ?? 'unknown'}');
    
    // Trigger a refresh of orders (assuming this method exists)
    // If it doesn't exist, you'll need to implement it in OrderProvider
    try {
      // This is a placeholder - replace with actual method when available
      // _orderProvider!.fetchOrders();
    } catch (e) {
      debugPrint('❌ Error refreshing orders: $e');
    }
  }
  
  /// Force an immediate poll for updates
  Future<void> forcePoll() async {
    await _realtimeService.forcePoll();
  }
  
  /// Dispose all resources
  void dispose() {
    _courseSubscription?.cancel();
    _categorySubscription?.cancel();
    _notificationSubscription?.cancel();
    _orderSubscription?.cancel();
    _isInitialized = false;
  }
}
