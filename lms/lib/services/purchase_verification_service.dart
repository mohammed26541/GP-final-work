import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider/auth_provider.dart';
import '../providers/order_provider/order_provider.dart';
import '../models/order/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/app_constants.dart';
import '../models/user/user.dart';

/// Service to verify if a user has already purchased a course
class PurchaseVerificationService {
  /// Check if a user has already purchased a specific course
  ///
  /// Returns true if the user has the course in their enrolled courses list
  /// or if they have a completed order for the course
  static bool hasUserPurchasedCourse(
    String userId,
    String courseId,
    List<String> enrolledCourses,
    List<Order> userOrders,
  ) {
    // Check if the course is in the user's enrolled courses
    final bool isEnrolled = enrolledCourses.contains(courseId);
    print(
      '🔒 Course $courseId in enrolled courses? $isEnrolled (courses: ${enrolledCourses.join(", ")})',
    );

    // Check if the user has a completed order for this course
    final bool hasCompletedOrder = userOrders.any(
      (order) =>
          order.courseId == courseId &&
          order.userId == userId &&
          order.status == 'completed',
    );
    print(
      '🔒 User has completed order for course $courseId? $hasCompletedOrder',
    );

    // User has purchased the course if either condition is true
    return isEnrolled || hasCompletedOrder;
  }

  /// Check if the current user has already purchased a specific course
  /// using the context to access providers
  static Future<bool> hasCurrentUserPurchasedCourse(
    BuildContext context,
    String courseId,
  ) async {
    print('🔍 Verifying course purchase for course ID: $courseId');

    // Access all providers BEFORE async operations
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Store necessary user data before async operations
    final currentUser = authProvider.currentUser;

    // If user is not logged in, they haven't purchased anything
    if (currentUser == null) {
      print('❌ User not logged in, denying access');
      return false;
    }

    // Admin users have access to all courses
    if (currentUser.role == 'admin') {
      print('✅ User is admin, granting access to course');
      return true;
    }

    final String userId = currentUser.id;

    // First check - use the user data from the provider
    List<String> enrolledCourses = currentUser.courses;
    print(
      '📋 User enrolled courses from provider: ${enrolledCourses.join(", ")}',
    );

    // Second check - verify with the latest data from shared preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(AppConstants.userKey);

      if (userData != null) {
        final user = User.fromJson(json.decode(userData));
        // Use the most up-to-date list from storage
        enrolledCourses = user.courses;
        print(
          '📋 User enrolled courses from storage: ${enrolledCourses.join(", ")}',
        );
      }
    } catch (e) {
      print('⚠️ Error reading user data from storage: $e');
      // Continue with the provider data
    }

    // Make sure orders are loaded
    if (orderProvider.orders.isEmpty) {
      try {
        await orderProvider.fetchAllOrders();
        print(
          '📦 Orders loaded for verification: ${orderProvider.orders.length} orders',
        );
      } catch (e) {
        print('❌ Error loading orders: $e');
      }
    }

    final List<Order> userOrders =
        orderProvider.orders.where((order) => order.userId == userId).toList();
    print('📦 Found ${userOrders.length} orders for this user');

    // Print individual order details for debugging
    for (var order in userOrders) {
      print(
        '📦 Order: ID=${order.id}, CourseID=${order.courseId}, Status=${order.status}',
      );
    }

    final bool result = hasUserPurchasedCourse(
      userId,
      courseId,
      enrolledCourses,
      userOrders,
    );

    print(
      '🔍 Purchase verification result for user $userId, course $courseId: ${result ? "✅ Access granted" : "❌ Access denied"}',
    );
    return result;
  }

  /// Show a dialog informing the user they've already purchased the course
  static void showAlreadyPurchasedDialog(
    BuildContext context,
    String courseId,
    VoidCallback? onGoToCourse,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Already Purchased'),
            content: const Text(
              'You have already purchased this course. You can access it in your enrolled courses.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  if (onGoToCourse != null) {
                    onGoToCourse();
                  }
                },
                child: const Text('Go to Course'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
