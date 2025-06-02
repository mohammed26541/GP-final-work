import '../../models/course/course.dart';
import '../../models/course/course_content.dart';
import '../../models/user/user.dart';
import '../../services/course_service/course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../constants/app_constants.dart';

/// Methods for fetching course data
class CourseFetchMethods {
  final CourseService _courseService;

  CourseFetchMethods(this._courseService);

  /// Fetch all courses
  Future<List<Course>> fetchAllCourses({
    String? category,
    String? search,
    int page = 1,
    int limit = 10,
    String? sortBy,
  }) async {
    return await _courseService.getAllCourses(
      category: category,
      search: search,
      page: page,
      limit: limit,
      sortBy: sortBy,
    );
  }

  /// Fetch featured courses
  Future<List<Course>> fetchFeaturedCourses({int limit = 5}) async {
    return await _courseService.getFeaturedCourses(limit: limit);
  }

  /// Fetch recommended courses
  Future<List<Course>> fetchRecommendedCourses({int limit = 5}) async {
    return await _courseService.getRecommendedCourses(limit: limit);
  }

  /// Fetch course by ID
  Future<Course> fetchCourseById(String courseId) async {
    return await _courseService.getCourseById(courseId);
  }

  /// Fetch course content
  Future<List<CourseContent>> fetchCourseContent(String courseId) async {
    print('🔍 Fetching course content for course ID: $courseId');

    // First verify that the user has purchased this course
    final hasAccess = await verifyCourseAccess(courseId);
    if (!hasAccess) {
      print(
        '❌ Access verification failed - user has not purchased this course',
      );
      throw Exception('You do not have access to this course content');
    }

    final content = await _courseService.getCourseContent(courseId);

    if (content.isEmpty) {
      print('⚠️ Warning: Course content is empty for course ID: $courseId');
      // This might not be an error - could be a new course without content
    } else {
      print(
        '✅ Successfully fetched ${content.length} content items for course ID: $courseId',
      );
      for (var i = 0; i < content.length; i++) {
        print(
          '  📝 Content #${i + 1}: "${content[i].title}" - ${content[i].videoUrl.isNotEmpty ? 'Has video' : 'No video'}',
        );
      }
    }

    return content;
  }

  /// Fetch my enrolled courses
  Future<List<Course>> fetchMyCourses() async {
    print('📚 Fetching enrolled courses for current user');

    // Get current user to check if admin
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(AppConstants.userKey);

    if (userData != null) {
      final user = User.fromJson(json.decode(userData));
      print('👤 User role: ${user.role}, courses: ${user.courses.length}');

      // For admin, they have access to all courses
      if (user.role == 'admin') {
        print('🔑 User is admin, fetching all courses');
        // If admin, get all courses
        try {
          final allCourses = await _courseService.getAllCourses();
          // Mark all courses as enrolled for admin
          final enrolledCourses =
              allCourses
                  .map(
                    (course) => Course(
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
                    ),
                  )
                  .toList();

          print('✅ Admin access: loaded ${enrolledCourses.length} courses');
          return enrolledCourses;
        } catch (e) {
          print('⚠️ Error fetching all courses for admin: $e');
          // Continue to try other methods
        }
      }
    }

    // For regular users or if admin method failed, use the dedicated method to fetch enrolled courses
    final courses = await _courseService.getEnrolledCourses();

    if (courses.isNotEmpty) {
      // Set all courses as enrolled to be sure
      final enrolledCourses =
          courses
              .map(
                (course) => Course(
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
                ),
              )
              .toList();

      print('✅ Loaded ${enrolledCourses.length} enrolled courses for user');
      return enrolledCourses;
    } else {
      print('ℹ️ No enrolled courses found for this user');
      // Return empty list to ensure UI shows the empty state
      return [];
    }
  }

  /// Generate video URL
  Future<String?> generateVideoUrl(String videoId) async {
    return await _courseService.generateVideoUrl(videoId);
  }

  /// Verify access to a course
  Future<bool> verifyCourseAccess(String courseId) async {
    try {
      print('🔒 Verifying course access for courseId: $courseId');

      // Get current user data from storage
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(AppConstants.userKey);

      if (userData == null) {
        print('❌ No user data found in storage, denying access');
        return false;
      }

      final user = User.fromJson(json.decode(userData));
      print('👤 User ID: ${user.id}, Role: ${user.role}');
      print('👤 User courses: ${user.courses.join(", ")}');

      // Admin users have access to all courses
      if (user.role == 'admin') {
        print('✅ Admin user, granting access');
        return true;
      }

      // Check if course is in user's courses list
      final hasAccess = user.courses.contains(courseId);
      print(
        '🔒 Course access verification result: ${hasAccess ? "Access granted" : "Access denied"}',
      );

      return hasAccess;
    } catch (e) {
      print('❌ Error verifying course access: $e');
      return false;
    }
  }
}
