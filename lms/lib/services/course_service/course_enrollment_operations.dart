import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/app_constants.dart';
import '../../models/course/course.dart';
import '../../models/user/user.dart';
import '../api_service/api_service.dart';

/// Handles operations related to course enrollment and access
class CourseEnrollmentOperations {
  final ApiService _apiService;

  CourseEnrollmentOperations({required ApiService apiService})
    : _apiService = apiService;

  /// Get enrolled courses for the current user
  Future<List<Course>> getEnrolledCourses() async {
    try {
      print('🔍 Getting enrolled courses for current user');

      // First refresh user data from server
      final response = await _apiService.get(ApiEndpoints.loadUser);

      if (response is! Map<String, dynamic> || !response.containsKey('user')) {
        throw Exception('Invalid user data response');
      }

      final user = User.fromJson(response['user']);

      // Save updated user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userKey, jsonEncode(user));

      // Now proceed with getting enrolled courses
      // First try to get the current user data to check purchased courses
      final userData = prefs.getString(AppConstants.userKey);

      if (userData != null) {
        final user = User.fromJson(json.decode(userData));
        print('👤 Found user with ${user.courses.length} purchased courses');

        if (user.courses.isNotEmpty) {
          final purchasedCourses = <Course>[];
          final purchasedCourseIds = <String>{};

          // Fetch each course individually by ID
          for (String courseId in user.courses) {
            if (courseId.isNotEmpty && !purchasedCourseIds.contains(courseId)) {
              try {
                print(
                  '🔍 Fetching course details for purchased course ID: $courseId',
                );
                final course = await _getCourseById(courseId);

                // Mark as enrolled
                final enrolledCourse = Course(
                  id: course.id,
                  name: course.name,
                  description: course.description,
                  thumbnail: course.thumbnail,
                  instructor: course.instructor,
                  instructorName: course.instructorName,
                  tags: course.tags,
                  price: course.price,
                  discountedPrice: course.discountedPrice,
                  durationInWeeks: course.durationInWeeks,
                  content: course.content,
                  reviews: course.reviews,
                  rating: course.rating,
                  totalStudents: course.totalStudents,
                  isFeatured: course.isFeatured,
                  isEnrolled: true,
                  createdAt: course.createdAt,
                );

                purchasedCourseIds.add(courseId);
                purchasedCourses.add(enrolledCourse);
                print('✅ Added enrolled course: ${course.name}');
              } catch (e) {
                print('⚠️ Error fetching course details for ID $courseId: $e');
              }
            }
          }

          if (purchasedCourses.isNotEmpty) {
            print(
              '✅ Successfully loaded ${purchasedCourses.length} purchased courses',
            );
            return purchasedCourses;
          }
        }
      }

      // Try to fetch enrolled courses directly from the server
      try {
        print('🔄 Attempting to fetch enrolled courses from API');
        final enrolledResponse = await _apiService.get(
          ApiEndpoints.getEnrolledCourses,
          queryParameters: {'enrolled': 'true'},
        );

        if (enrolledResponse != null) {
          final enrolledCourses = <Course>[];
          List<dynamic>? coursesList;

          if (enrolledResponse is Map<String, dynamic>) {
            // Find courses in the response
            if (enrolledResponse.containsKey('courses')) {
              coursesList = enrolledResponse['courses'] as List;
            } else if (enrolledResponse.containsKey('data')) {
              coursesList = enrolledResponse['data'] as List;
            } else {
              // Try to find any list that could be courses
              for (var key in enrolledResponse.keys) {
                if (enrolledResponse[key] is List) {
                  coursesList = enrolledResponse[key] as List;
                  break;
                }
              }
            }
          } else if (enrolledResponse is List) {
            coursesList = enrolledResponse;
          }

          if (coursesList != null && coursesList.isNotEmpty) {
            print('🔍 Found ${coursesList.length} courses in API response');

            for (var courseData in coursesList) {
              if (courseData is Map<String, dynamic>) {
                try {
                  // Mark as enrolled
                  courseData['isEnrolled'] = true;
                  final course = Course.fromJson(courseData);
                  enrolledCourses.add(course);
                } catch (e) {
                  print('⚠️ Error parsing course from API: $e');
                }
              }
            }

            if (enrolledCourses.isNotEmpty) {
              print(
                '✅ Loaded ${enrolledCourses.length} enrolled courses from API',
              );
              return enrolledCourses;
            }
          }
        }
      } catch (e) {
        print('⚠️ Error fetching enrolled courses from API: $e');
      }

      // If no enrolled courses found, return an empty list
      print('ℹ️ No enrolled courses found for this user');
      return [];
    } catch (e) {
      print('❌ Error in getEnrolledCourses: $e');
      return [];
    }
  }

  /// Verify if user has access to a specific course
  Future<bool> verifyCourseAccess(String courseId) async {
    try {
      print('🔒 Verifying course access for course ID: $courseId');

      // Get the current user
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(AppConstants.userKey);

      if (userData == null) {
        print('❌ No user data found in local storage');
        return false;
      }

      final user = User.fromJson(json.decode(userData));
      print('👤 User role: ${user.role}, User ID: ${user.id}');
      print('👤 User courses: ${user.courses.join(", ")}');

      // If user is an admin, grant automatic access to all courses
      if (user.role == 'admin') {
        print(
          '✅ User is an admin, granting automatic access to course ID: $courseId',
        );
        return true;
      }

      // Check if the course ID exists in the user's purchased courses
      if (user.courses.contains(courseId)) {
        print('✅ User has purchased access to course ID: $courseId');
        return true;
      }

      // If the course ID is not in the user's courses, they don't have access
      print('❌ User does not have access to course ID: $courseId');
      return false;
    } catch (e) {
      print('❌ Error verifying course access: $e');
      return false;
    }
  }

  /// Get course by ID (helper method)
  Future<Course> _getCourseById(String courseId) async {
    final response = await _apiService.get(
      '${ApiEndpoints.getCourse}/$courseId',
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    if (!response.containsKey('course')) {
      throw Exception('Invalid response format: course not found');
    }

    return Course.fromJson(response['course']);
  }
}
