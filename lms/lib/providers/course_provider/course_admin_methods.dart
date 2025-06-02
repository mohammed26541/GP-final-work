import '../../models/course/course.dart';
import '../../services/course_service/course_service.dart';

/// Admin-specific methods for course management
class CourseAdminMethods {
  final CourseService _courseService;
  
  CourseAdminMethods(this._courseService);
  
  /// Fetch admin courses
  Future<List<Course>> fetchAdminCourses() async {
    return await _courseService.getAdminCourses();
  }
  
  /// Create a new course
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
    return await _courseService.createCourse(
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
  
  /// Edit an existing course
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
    return await _courseService.editCourse(
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
  
  /// Delete a course
  Future<bool> deleteCourse(String courseId) async {
    return await _courseService.deleteCourse(courseId);
  }
}
