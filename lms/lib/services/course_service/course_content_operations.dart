import '../../constants/api_endpoints.dart';
import '../../models/course/course_content.dart';
import '../api_service/api_service.dart';

/// Handles operations related to course content and learning materials
class CourseContentOperations {
  final ApiService _apiService;

  CourseContentOperations({
    required ApiService apiService,
  }) : _apiService = apiService;

  /// Get course content by ID
  Future<List<CourseContent>> getCourseContent(String courseId) async {
    try {
      print('🔍 Getting course content for course ID: $courseId');

      // Use the same endpoint format as the web application
      final url = '${ApiEndpoints.getCourseContent}/$courseId';
      print('🔗 Using URL: $url');

      final response = await _apiService.get(url);

      print('📦 Course content response TYPE: ${response.runtimeType}');
      print('📦 Course content response: $response');

      // Enhanced response handling to be more flexible
      if (response is Map<String, dynamic>) {
        // Try different possible response formats
        List<dynamic>? contentList;

        if (response.containsKey('courseData') ||
            response.containsKey('content')) {
          // This format matches the web app's API response structure
          contentList =
              response.containsKey('courseData')
                  ? response['courseData'] as List
                  : response['content'] as List;
          print(
            '📦 Found content using web app format: ${contentList.length} items',
          );
        } else if (response.containsKey('data')) {
          contentList = response['data'] as List;
          print('📦 Found data in response');
        } else if (response.containsKey('lectures')) {
          contentList = response['lectures'] as List;
          print('📦 Found lectures in response');
        } else {
          // Try to find any key that contains a list
          for (var key in response.keys) {
            print('📦 Checking key: $key');
            if (response[key] is List && (response[key] as List).isNotEmpty) {
              contentList = response[key] as List;
              print('📦 Found content list in response key: $key');
              break;
            }
          }
        }

        if (contentList == null) {
          print('❌ No content list found in response: $response');

          // Try fallback to the regular endpoint with query parameter
          print('🔄 Trying fallback with query parameter...');
          final fallbackResponse = await _apiService.get(
            ApiEndpoints.getCourseContent,
            queryParameters: {'courseId': courseId},
          );

          print('📦 Fallback response: $fallbackResponse');

          if (fallbackResponse is Map<String, dynamic>) {
            // Check if fallback response has content
            for (var key in fallbackResponse.keys) {
              if (fallbackResponse[key] is List &&
                  (fallbackResponse[key] as List).isNotEmpty) {
                contentList = fallbackResponse[key] as List;
                print('✅ Found content in fallback response key: $key');
                break;
              }
            }
          } else if (fallbackResponse is List) {
            contentList = fallbackResponse;
            print('✅ Fallback response is a list of content');
          }

          if (contentList == null) {
            print('❌ Fallback also failed. No content found.');
            return []; // Return empty list as last resort
          }
        }

        print('📦 Content list length: ${contentList.length}');
        try {
          final parsedContent =
              contentList.map((item) => CourseContent.fromJson(item)).toList();
          print('✅ Successfully parsed ${parsedContent.length} content items');
          return parsedContent;
        } catch (e) {
          print('❌ Error parsing content items: $e');
          return [];
        }
      } else if (response is List) {
        // Handle the case where the API directly returns an array
        print('📦 Response is a list of length: ${response.length}');
        try {
          final parsedContent =
              response.map((item) => CourseContent.fromJson(item)).toList();
          print(
            '✅ Successfully parsed ${parsedContent.length} content items from direct list',
          );
          return parsedContent;
        } catch (e) {
          print('❌ Error parsing content items from direct list: $e');
          return [];
        }
      } else {
        print('❌ Invalid response format: ${response.runtimeType}');
        return []; // Return empty list
      }
    } catch (e) {
      print('❌ Error in getCourseContent: $e');
      return []; // Return empty list on error
    }
  }

  /// Generate video URL for playback
  Future<String> generateVideoUrl(String videoId) async {
    try {
      final data = {'videoId': videoId};

      print('Generating video URL with data: $data');

      final response = await _apiService.post(
        ApiEndpoints.generateVideoUrl,
        data: data,
      );

      print('Generate video URL response: $response');

      if (!response.containsKey('playbackUrl')) {
        throw Exception('Invalid response format: playbackUrl not found');
      }

      return response['playbackUrl'];
    } catch (e) {
      print('Generate video URL error: $e');
      rethrow;
    }
  }
}
