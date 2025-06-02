import '../../models/course/course.dart';
import '../../models/course/course_content.dart';
import '../../models/course/course_question.dart';
import '../../models/course/course_review.dart';
import '../../constants/api_endpoints.dart';
import '../api_service/api_service.dart';
import 'course_admin_operations.dart';
import 'course_content_operations.dart';
import 'course_enrollment_operations.dart';
import 'course_fetching_operations.dart';
import 'course_interaction_operations.dart';

/// Main course service class that handles course-related operations
class CourseService {
  // Components
  final ApiService _apiService = ApiService();
  late final CourseFetchingOperations _fetchingOperations;
  late final CourseContentOperations _contentOperations;
  late final CourseInteractionOperations _interactionOperations;
  late final CourseAdminOperations _adminOperations;
  late final CourseEnrollmentOperations _enrollmentOperations;

  // Base URL for API
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Singleton pattern
  static final CourseService _instance = CourseService._internal();
  factory CourseService() => _instance;

  CourseService._internal() {
    _fetchingOperations = CourseFetchingOperations(apiService: _apiService);
    _contentOperations = CourseContentOperations(apiService: _apiService);
    _interactionOperations = CourseInteractionOperations(
      apiService: _apiService,
    );
    _adminOperations = CourseAdminOperations(apiService: _apiService);
    _enrollmentOperations = CourseEnrollmentOperations(apiService: _apiService);
  }

  // ======== Course Fetching Operations ========

  /// Get all courses with optional filters
  Future<List<Course>> getAllCourses({
    String? category,
    String? search,
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool? isFeatured,
  }) async {
    return _fetchingOperations.getAllCourses(
      category: category,
      search: search,
      page: page,
      limit: limit,
      sortBy: sortBy,
      isFeatured: isFeatured,
    );
  }

  /// Get recommended courses
  Future<List<Course>> getRecommendedCourses({int limit = 5}) async {
    return _fetchingOperations.getRecommendedCourses(limit: limit);
  }

  /// Get featured courses
  Future<List<Course>> getFeaturedCourses({int limit = 5}) async {
    return _fetchingOperations.getFeaturedCourses(limit: limit);
  }

  /// Get specific course by ID
  Future<Course> getCourseById(String courseId) async {
    return _fetchingOperations.getCourseById(courseId);
  }

  /// Get admin courses (admin/instructor)
  Future<List<Course>> getAdminCourses() async {
    return _fetchingOperations.getAdminCourses();
  }

  /// Get instructor courses
  Future<List<Course>> getInstructorCourses() async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.getAdminCourses}?role=instructor',
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (!response.containsKey('courses')) {
        throw Exception('Invalid response format: courses not found');
      }

      final coursesList =
          (response['courses'] as List)
              .map((courseJson) => Course.fromJson(courseJson))
              .toList();

      return coursesList;
    } catch (e) {
      print('Get instructor courses error: $e');
      return [];
    }
  }

  // ======== Course Content Operations ========

  /// Get course content by ID
  Future<List<CourseContent>> getCourseContent(String courseId) async {
    return _contentOperations.getCourseContent(courseId);
  }

  /// Generate video URL
  Future<String> generateVideoUrl(String videoId) async {
    return _contentOperations.generateVideoUrl(videoId);
  }

  // ======== Course Interaction Operations ========

  /// Add question to course
  Future<CourseQuestion> addQuestion({
    required String courseId,
    required String contentId,
    required String question,
  }) async {
    return _interactionOperations.addQuestion(
      courseId: courseId,
      contentId: contentId,
      question: question,
    );
  }

  /// Add answer to question
  Future<CourseAnswer> addAnswer({
    required String courseId,
    required String contentId,
    required String questionId,
    required String answer,
  }) async {
    return _interactionOperations.addAnswer(
      courseId: courseId,
      contentId: contentId,
      questionId: questionId,
      answer: answer,
    );
  }

  /// Add review to course
  Future<bool> addReview({
    required String courseId,
    required String review,
    required double rating,
  }) async {
    return _interactionOperations.addReview(
      courseId: courseId,
      review: review,
      rating: rating,
    );
  }

  /// Add reply to review
  Future<CourseReviewReply> addReply({
    required String courseId,
    required String reviewId,
    required String reply,
  }) async {
    return _interactionOperations.addReply(
      courseId: courseId,
      reviewId: reviewId,
      reply: reply,
    );
  }

  // ======== Course Admin Operations ========

  /// Create course (admin/instructor)
  Future<Course> createCourse({
    required String name,
    required String description,
    required String thumbnail,
    required List<String> tags,
    required double price,
    double? discountedPrice,
    required int durationInWeeks,
    required List<Map<String, dynamic>> content,
  }) async {
    return _adminOperations.createCourse(
      name: name,
      description: description,
      thumbnail: thumbnail,
      tags: tags,
      price: price,
      discountedPrice: discountedPrice,
      durationInWeeks: durationInWeeks,
      content: content,
    );
  }

  /// Edit course (admin/instructor)
  Future<Course> editCourse({
    required String courseId,
    String? name,
    String? description,
    String? thumbnail,
    List<String>? tags,
    double? price,
    double? discountedPrice,
    int? durationInWeeks,
    List<Map<String, dynamic>>? content,
  }) async {
    return _adminOperations.editCourse(
      courseId: courseId,
      name: name,
      description: description,
      thumbnail: thumbnail,
      tags: tags,
      price: price,
      discountedPrice: discountedPrice,
      durationInWeeks: durationInWeeks,
      content: content,
    );
  }

  /// Delete course (admin/instructor)
  Future<bool> deleteCourse(String courseId) async {
    return _adminOperations.deleteCourse(courseId);
  }

  // ======== Course Enrollment Operations ========

  /// Get enrolled courses for the current user
  Future<List<Course>> getEnrolledCourses() async {
    return _enrollmentOperations.getEnrolledCourses();
  }

  /// Verify if user has access to a specific course
  Future<bool> verifyCourseAccess(String courseId) async {
    return _enrollmentOperations.verifyCourseAccess(courseId);
  }
}
