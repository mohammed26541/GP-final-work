import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/order_provider/order_provider.dart';

class EnrollmentHelper {
  /// Checks if the user has enrolled in the specified course
  static Future<bool> hasEnrolled(
    String courseId,
    AuthProvider authProvider,
    BuildContext context,
  ) async {
    if (authProvider.currentUser == null) return false;

    // Admin can access all courses
    if (authProvider.currentUser?.role == 'admin') return true;

    // Get OrderProvider before the async gap
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Refresh user data to get latest courses
    await authProvider.refreshCurrentUser();

    // Check if user is enrolled in this course
    final isEnrolled = authProvider.currentUser!.courses.contains(courseId);

    // Check for pending orders (orders that are not completed)
    final hasPendingOrder = orderProvider.orders.any(
      (order) => order.courseId == courseId && order.status != 'completed',
    );

    // Check for completed orders (user has already purchased the course)
    final hasCompletedOrder = orderProvider.orders.any(
      (order) => order.courseId == courseId && order.status == 'completed',
    );

    // Consider the user enrolled if:
    // 1. They have the course in their enrolled courses list, OR
    // 2. They have a completed order for this course
    // AND
    // 3. They don't have any pending orders for this course
    return (isEnrolled || hasCompletedOrder) && !hasPendingOrder;
  }
}
