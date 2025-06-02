import 'package:flutter/material.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/course_provider/course_provider.dart';
import '../../../services/purchase_verification_service.dart';
import '../../../constants/app_constants.dart';

/// Helper methods for checking course access and content
class CourseAccessHelper {
  /// Verify if user has access to a course and fetch basic course data
  static Future<bool> verifyCourseAccess(
    BuildContext context,
    String courseId,
    CourseProvider courseProvider,
    AuthProvider authProvider,
  ) async {
    print('🔒 Verifying course access for ID: $courseId');

    // First fetch the basic course information (this should always succeed regardless of purchase status)
    try {
      await courseProvider.fetchCourseById(courseId);
      if (courseProvider.selectedCourse == null) {
        print('❌ Course not found with ID: $courseId');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Course not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    } catch (e) {
      print('❌ Error fetching course: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading course: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    // Check if user is logged in
    if (authProvider.currentUser == null) {
      print('❌ User not logged in, cannot access course content');
      if (context.mounted) {
        _showAccessDeniedDialog(context, 'Please login to access this course');
      }
      return false;
    }

    // Then check course purchase status (only needed for full content access)
    try {
      // Store needed provider values before async gap
      final isAdmin = authProvider.currentUser?.role == 'admin';
      print('👤 User role: ${isAdmin ? "admin" : "regular user"}');

      // Get user access status
      final bool hasAccess;
      if (context.mounted) {
        hasAccess =
            await PurchaseVerificationService.hasCurrentUserPurchasedCourse(
              context,
              courseId,
            );
      } else {
        return false;
      }

      // Verify context is still valid after the async operation
      if (!context.mounted) return false;

      // Final access check using previously stored admin status
      final bool canAccess = hasAccess || isAdmin;

      if (!canAccess) {
        print('🔒 User does not have access to this course');
        // Show access denied dialog
        _showAccessDeniedDialog(
          context,
          'You need to purchase this course to access its content',
        );
      }

      return canAccess;
    } catch (e) {
      print('❌ Error verifying course access: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error verifying course access: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  /// Show a dialog when access is denied
  static void _showAccessDeniedDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Access Denied'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to previous screen
                },
                child: const Text('Go Back'),
              ),
              if (message.contains(
                'purchase',
              )) // Show "Purchase" button if relevant
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to details screen
                    // Purchase flow will be handled on the details screen
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.primaryLight,
                  ),
                  child: const Text('Purchase Course'),
                ),
            ],
          ),
    );
  }

  /// Fetch course content for users with access
  static Future<bool> fetchCourseContent(
    BuildContext context,
    String courseId,
    CourseProvider courseProvider,
  ) async {
    try {
      await courseProvider.fetchCourseContent(courseId);
      return true;
    } catch (e) {
      print('❌ Error fetching course content: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading course content: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  /// Check if the course has content data (safe check)
  static bool checkCourseHasContent(
    BuildContext context,
    CourseProvider courseProvider,
  ) {
    final course = courseProvider.selectedCourse;

    // First check if we have course data
    if (course == null) {
      return false;
    }

    // If the provider has course content, that's good
    if (courseProvider.courseContent.isNotEmpty) {
      return true;
    }

    // Fallback: check if the course object has content data
    // This might be used when full course content access is restricted
    if (course.content.isNotEmpty) {
      // Set temporary content (without making API calls)
      print('📚 Setting fallback content from course.content');
      courseProvider.setTempCourseContent(course.content);
      return true;
    }

    // No content available
    return false;
  }
}
