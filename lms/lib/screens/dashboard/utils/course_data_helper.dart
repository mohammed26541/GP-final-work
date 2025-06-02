import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/app_constants.dart';
import '../../../models/user/user.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/course_provider/course_provider.dart';

class CourseDataHelper {
  /// Fetches enrolled courses for the current user
  static Future<void> fetchEnrolledCourses(
    BuildContext context,
    Function setLoading,
    Function setError,
    Function clearError,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Check if user is authenticated
    if (authProvider.currentUser == null || !authProvider.isLoggedIn) {
      print('⚠️ User not authenticated, cannot fetch enrolled courses');
      return;
    }

    setLoading(true);
    clearError();

    try {
      // Refresh user data to get latest courses
      await authProvider.refreshCurrentUser();

      // Debug: Check user courses directly from storage
      await checkUserCoursesDirectly();

      await courseProvider.fetchMyCourses();

      print('✅ Fetched ${courseProvider.myCourses.length} enrolled courses');

      if (courseProvider.myCourses.isEmpty) {
        print('ℹ️ No enrolled courses found for the current user');

        // If this is after a purchase but courses are still empty, try refreshing auth
        if (authProvider.currentUser != null &&
            authProvider.currentUser!.courses.isNotEmpty) {
          print(
            '🔄 User has courses in auth but none loaded, refreshing user data',
          );
          await authProvider.initializeAuth();
          await courseProvider.fetchMyCourses();
        }
      }
    } catch (e) {
      print('❌ Error fetching enrolled courses: $e');
      setError('Failed to load your courses. Please try again.');

      // Create a function to retry fetching that can be passed to the SnackBar
      void retryFetching() {
        fetchEnrolledCourses(context, setLoading, setError, clearError);
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error loading courses: ${e.toString()}'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: retryFetching,
            textColor: Colors.white,
          ),
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  /// Debug method to check user courses directly from storage
  static Future<void> checkUserCoursesDirectly() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(AppConstants.userKey);

      if (userData != null) {
        final user = User.fromJson(json.decode(userData));
        print('👤 USER DEBUG - Role: ${user.role}');
        print('👤 USER DEBUG - ID: ${user.id}');
        print('👤 USER DEBUG - Courses count: ${user.courses.length}');
        print('👤 USER DEBUG - Course IDs: ${user.courses.join(", ")}');

        if (user.courses.isEmpty) {
          print('⚠️ USER DEBUG - No courses found in user data!');
        }
      } else {
        print('⚠️ USER DEBUG - No user data found in storage!');
      }
    } catch (e) {
      print('❌ USER DEBUG - Error checking user data: $e');
    }
  }
}
