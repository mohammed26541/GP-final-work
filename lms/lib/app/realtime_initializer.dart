import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import '../providers/course_provider/course_provider.dart';
import '../providers/category_provider/category_provider.dart';
import '../providers/notification_provider/notification_provider.dart';
import '../providers/order_provider/order_provider.dart';
import '../services/realtime_service/realtime_update_manager.dart';

/// Initializes the real-time update system and connects it to providers
class RealtimeInitializer {
  static bool _isInitialized = false;
  static final RealtimeUpdateManager _realtimeManager = RealtimeUpdateManager();

  /// Initialize the real-time update system with the application context
  static void initialize(BuildContext context) {
    if (_isInitialized) return;

    try {
      // Get required providers
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      // Get optional providers if they exist
      NotificationProvider? notificationProvider;
      OrderProvider? orderProvider;

      try {
        notificationProvider = Provider.of<NotificationProvider>(
          context,
          listen: false,
        );
      } catch (e) {
        developer.log(
          'NotificationProvider not available in context',
          name: 'RealtimeInitializer',
        );
      }

      try {
        orderProvider = Provider.of<OrderProvider>(context, listen: false);
      } catch (e) {
        developer.log(
          'OrderProvider not available in context',
          name: 'RealtimeInitializer',
        );
      }

      // Initialize the real-time update manager with providers
      _realtimeManager.initialize(
        courseProvider: courseProvider,
        categoryProvider: categoryProvider,
        notificationProvider: notificationProvider,
        orderProvider: orderProvider,
      );

      _isInitialized = true;
      developer.log(
        'RealtimeInitializer initialized successfully',
        name: 'RealtimeInitializer',
      );
    } catch (e) {
      developer.log(
        'Error initializing RealtimeInitializer: $e',
        name: 'RealtimeInitializer',
      );
    }
  }

  /// Force an immediate poll for updates
  static Future<void> forcePoll() async {
    if (!_isInitialized) {
      developer.log(
        'Cannot force poll - RealtimeInitializer not initialized',
        name: 'RealtimeInitializer',
      );
      return;
    }

    try {
      await _realtimeManager.forcePoll();
    } catch (e) {
      developer.log(
        'Error during forced polling: $e',
        name: 'RealtimeInitializer',
      );
    }
  }
}
