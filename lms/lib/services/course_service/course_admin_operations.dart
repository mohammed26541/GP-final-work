import 'dart:convert';
import '../../constants/api_endpoints.dart';
import '../../models/course/course.dart';
import '../api_service/api_service.dart';

/// Handles operations related to course administration (create, edit, delete)
class CourseAdminOperations {
  final ApiService _apiService;

  CourseAdminOperations({
    required ApiService apiService,
  }) : _apiService = apiService;

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
    try {
      final data = {
        'name': name,
        'description': description,
        'thumbnail': thumbnail,
        'tags': tags,
        'price': price,
        'discountedPrice': discountedPrice ?? price,
        'durationInWeeks': durationInWeeks,
        'content': content,
      };

      print('Creating course with data: ${jsonEncode(data)}');

      final response = await _apiService.post(
        ApiEndpoints.createCourse,
        data: data,
      );

      print('Create course response: $response');

      if (!response.containsKey('course')) {
        throw Exception('Invalid response format: course object not found');
      }

      return Course.fromJson(response['course']);
    } catch (e) {
      print('Create course error: $e');
      rethrow;
    }
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
    try {
      final data = <String, dynamic>{'courseId': courseId};

      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (thumbnail != null) data['thumbnail'] = thumbnail;
      if (tags != null) data['tags'] = tags;
      if (price != null) data['price'] = price;
      if (discountedPrice != null) data['discountedPrice'] = discountedPrice;
      if (durationInWeeks != null) data['durationInWeeks'] = durationInWeeks;
      if (content != null) data['content'] = content;

      print('Editing course with data: ${jsonEncode(data)}');

      final response = await _apiService.put(
        ApiEndpoints.editCourse,
        data: data,
      );

      print('Edit course response: $response');

      if (!response.containsKey('course')) {
        throw Exception('Invalid response format: course object not found');
      }

      return Course.fromJson(response['course']);
    } catch (e) {
      print('Edit course error: $e');
      rethrow;
    }
  }

  /// Delete course (admin/instructor)
  Future<bool> deleteCourse(String courseId) async {
    try {
      final data = {'courseId': courseId};

      print('Deleting course with ID: $courseId');

      final response = await _apiService.delete(
        ApiEndpoints.deleteCourse,
        data: data,
      );

      print('Delete course response: $response');

      if (!response.containsKey('success')) {
        throw Exception('Invalid response format: success flag not found');
      }

      return response['success'] ?? false;
    } catch (e) {
      print('Delete course error: $e');
      rethrow;
    }
  }
}
