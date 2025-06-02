import '../../constants/api_endpoints.dart';
import '../../models/course/course.dart';
import '../api_service/api_service.dart';

/// Handles operations related to fetching courses
class CourseFetchingOperations {
  final ApiService _apiService;

  CourseFetchingOperations({
    required ApiService apiService,
  }) : _apiService = apiService;

  /// Get all courses with optional filters
  Future<List<Course>> getAllCourses({
    String? category,
    String? search,
    int page = 1,
    int limit = 10,
    String? sortBy,
    bool? isFeatured,
  }) async {
    try {
      final queryParams = {'page': page.toString(), 'limit': limit.toString()};

      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (sortBy != null) queryParams['sort'] = sortBy;
      if (isFeatured != null) queryParams['isFeatured'] = isFeatured.toString();

      print('Getting all courses with params: $queryParams');

      final response = await _apiService.get(
        ApiEndpoints.getAllCourses,
        queryParameters: queryParams,
      );

      print('Get all courses response TYPE: ${response.runtimeType}');
      print('Get all courses response: $response');

      // Enhanced response handling to be more flexible
      if (response is Map<String, dynamic>) {
        // Try different possible response formats
        List<dynamic>? coursesList;

        if (response.containsKey('courses')) {
          coursesList = response['courses'] as List;
        } else if (response.containsKey('data')) {
          coursesList = response['data'] as List;
        } else if (response.containsKey('result')) {
          coursesList = response['result'] as List;
        } else {
          // Try to find any key that contains a list
          for (var key in response.keys) {
            if (response[key] is List && (response[key] as List).isNotEmpty) {
              coursesList = response[key] as List;
              print('Found courses list in response key: $key');
              break;
            }
          }
        }

        if (coursesList == null) {
          print('No courses list found in response: $response');
          throw Exception('Invalid response format: courses array not found');
        }

        // Convert to Course objects
        var courses =
            coursesList.map((course) => Course.fromJson(course)).toList();

        // Apply client-side filtering if search term was provided (as a backup in case server-side filtering fails)
        if (search != null && search.isNotEmpty) {
          final searchLower = search.toLowerCase();
          print('Applying client-side filtering for search term: $searchLower');

          courses =
              courses.where((course) {
                final titleMatch = course.name.toLowerCase().contains(
                  searchLower,
                );
                final descriptionMatch = course.description
                    .toLowerCase()
                    .contains(searchLower);
                final instructorMatch = course.instructor
                    .toLowerCase()
                    .contains(searchLower);

                return titleMatch || descriptionMatch || instructorMatch;
              }).toList();

          print('After client-side filtering: ${courses.length} results');
        }

        return courses;
      } else if (response is List) {
        // Handle the case where the API directly returns an array
        var courses =
            response.map((course) => Course.fromJson(course)).toList();

        // Apply client-side filtering here too
        if (search != null && search.isNotEmpty) {
          final searchLower = search.toLowerCase();
          print(
            'Applying client-side filtering for search term: $searchLower (list response)',
          );

          courses =
              courses.where((course) {
                final titleMatch = course.name.toLowerCase().contains(
                  searchLower,
                );
                final descriptionMatch = course.description
                    .toLowerCase()
                    .contains(searchLower);
                final instructorMatch = course.instructor
                    .toLowerCase()
                    .contains(searchLower);

                return titleMatch || descriptionMatch || instructorMatch;
              }).toList();

          print(
            'After client-side filtering: ${courses.length} results (list response)',
          );
        }

        return courses;
      } else {
        throw Exception('Invalid response format: expected Map or List');
      }
    } catch (e) {
      print('Get all courses error: $e');
      rethrow;
    }
  }

  /// Get recommended courses
  Future<List<Course>> getRecommendedCourses({int limit = 5}) async {
    try {
      final queryParams = {'limit': limit.toString(), 'recommended': 'true'};

      print('Getting recommended courses with params: $queryParams');

      final response = await _apiService.get(
        ApiEndpoints.getAllCourses,
        queryParameters: queryParams,
      );

      print('Get recommended courses response: $response');

      // Enhanced response handling to be more flexible
      if (response is Map<String, dynamic>) {
        // Try different possible response formats
        List<dynamic>? coursesList;

        if (response.containsKey('courses')) {
          coursesList = response['courses'] as List;
        } else if (response.containsKey('data')) {
          coursesList = response['data'] as List;
        } else if (response.containsKey('result')) {
          coursesList = response['result'] as List;
        } else {
          // Try to find any key that contains a list
          for (var key in response.keys) {
            if (response[key] is List && (response[key] as List).isNotEmpty) {
              coursesList = response[key] as List;
              print('Found courses list in response key: $key');
              break;
            }
          }
        }

        if (coursesList == null) {
          print('No courses list found in response: $response');
          throw Exception('Invalid response format: courses array not found');
        }

        return coursesList.map((course) => Course.fromJson(course)).toList();
      } else if (response is List) {
        // Handle the case where the API directly returns an array
        return response.map((course) => Course.fromJson(course)).toList();
      } else {
        throw Exception('Invalid response format: expected Map or List');
      }
    } catch (e) {
      print('Get recommended courses error: $e');
      rethrow;
    }
  }

  /// Get featured courses
  Future<List<Course>> getFeaturedCourses({int limit = 5}) async {
    try {
      final queryParams = {'limit': limit.toString(), 'isFeatured': 'true'};

      print('Getting featured courses with params: $queryParams');

      final response = await _apiService.get(
        ApiEndpoints.getAllCourses,
        queryParameters: queryParams,
      );

      print('Get featured courses response TYPE: ${response.runtimeType}');
      print('Get featured courses response: $response');

      // Enhanced response handling to be more flexible
      if (response is Map<String, dynamic>) {
        // Try different possible response formats
        List<dynamic>? coursesList;

        if (response.containsKey('courses')) {
          print('Found courses in response');
          coursesList = response['courses'] as List;
        } else if (response.containsKey('data')) {
          print('Found data in response');
          coursesList = response['data'] as List;
        } else if (response.containsKey('result')) {
          print('Found result in response');
          coursesList = response['result'] as List;
        } else {
          // Try to find any key that contains a list
          for (var key in response.keys) {
            print('Checking key: $key');
            if (response[key] is List && (response[key] as List).isNotEmpty) {
              coursesList = response[key] as List;
              print('Found courses list in response key: $key');
              break;
            }
          }
        }

        if (coursesList == null) {
          print('No courses list found in response: $response');
          return []; // Return empty list instead of throwing
        }

        print('Courses list length: ${coursesList.length}');
        if (coursesList.isNotEmpty) {
          print('First course: ${coursesList[0]}');
        }

        try {
          final parsedCourses =
              coursesList
                  .map((courseData) {
                    print('Parsing course: $courseData');
                    try {
                      return Course.fromJson(courseData);
                    } catch (e) {
                      print('Error parsing individual course: $e');
                      return null;
                    }
                  })
                  .whereType<Course>()
                  .toList();

          print('Successfully parsed ${parsedCourses.length} courses');
          return parsedCourses;
        } catch (e) {
          print('Error parsing courses list: $e');
          return [];
        }
      } else if (response is List) {
        // Handle the case where the API directly returns an array
        print('Response is a List of length: ${response.length}');
        try {
          final parsedCourses =
              response
                  .map((courseData) {
                    try {
                      return Course.fromJson(courseData);
                    } catch (e) {
                      print('Error parsing course in list response: $e');
                      return null;
                    }
                  })
                  .whereType<Course>()
                  .toList();

          print(
            'Successfully parsed ${parsedCourses.length} courses from list',
          );
          return parsedCourses;
        } catch (e) {
          print('Error parsing courses from list: $e');
          return [];
        }
      } else {
        print('Invalid response format: $response');
        throw Exception('Invalid response format: expected Map or List');
      }
    } catch (e) {
      print('Get featured courses error: $e');
      rethrow;
    }
  }

  /// Get specific course by ID
  Future<Course> getCourseById(String courseId) async {
    try {
      print('Getting course by ID: $courseId');

      // Use the getAllCourses endpoint but with a specific courseId as filter
      final queryParams = {
        'id':
            courseId, // Changed from 'courseId' to 'id' which is likely the parameter name expected by the API
      };

      // Log the complete URL that will be requested
      print(
        'Request URL will be: ${ApiEndpoints.getAllCourses} with params: $queryParams',
      );

      final response = await _apiService.get(
        ApiEndpoints.getAllCourses,
        queryParameters: queryParams,
      );

      print('Get course by ID response TYPE: ${response.runtimeType}');
      print('Get course by ID response: $response');

      // Enhanced response handling to be more flexible
      if (response is Map<String, dynamic>) {
        // Try different possible response formats
        dynamic courseData;

        // First check if response contains a list of courses
        if (response.containsKey('courses')) {
          print('Found courses list in response');
          final coursesList = response['courses'] as List;
          if (coursesList.isNotEmpty) {
            // Look for the specific course with the matching ID
            for (var course in coursesList) {
              if (course is Map<String, dynamic> &&
                  (course['_id'] == courseId || course['id'] == courseId)) {
                print('Found exact matching course by ID');
                courseData = course;
                break;
              }
            }
            // If no exact match found, use the first course as fallback
            if (courseData == null && coursesList.isNotEmpty) {
              print('No exact match found, using first course as fallback');
              courseData = coursesList[0];
            }
          }
        } else if (response.containsKey('course')) {
          print('Found course in response');
          courseData = response['course'];
        } else if (response.containsKey('data')) {
          print('Found data in response');
          // Check if data is a list or a single object
          if (response['data'] is List) {
            final dataList = response['data'] as List;
            if (dataList.isNotEmpty) {
              // Look for the specific course with the matching ID
              for (var course in dataList) {
                if (course is Map<String, dynamic> &&
                    (course['_id'] == courseId || course['id'] == courseId)) {
                  print('Found exact matching course by ID in data list');
                  courseData = course;
                  break;
                }
              }
              // If no exact match found, use the first item as fallback
              if (courseData == null && dataList.isNotEmpty) {
                courseData = dataList[0];
              }
            }
          } else {
            courseData = response['data'];
          }
        } else if (response.containsKey('result')) {
          print('Found result in response');
          if (response['result'] is List) {
            final resultList = response['result'] as List;
            if (resultList.isNotEmpty) {
              // Look for the specific course with the matching ID
              for (var course in resultList) {
                if (course is Map<String, dynamic> &&
                    (course['_id'] == courseId || course['id'] == courseId)) {
                  print('Found exact matching course by ID in result list');
                  courseData = course;
                  break;
                }
              }
              // If no exact match found, use the first item as fallback
              if (courseData == null && resultList.isNotEmpty) {
                courseData = resultList[0];
              }
            }
          } else {
            courseData = response['result'];
          }
        } else if (response.containsKey('success') &&
            response['success'] == true) {
          // Check if the response itself might be the course data
          print('Found success=true, checking if response has course fields');
          if (response.containsKey('_id') ||
              response.containsKey('id') ||
              response.containsKey('name') ||
              response.containsKey('title')) {
            courseData = response;
          }
        } else {
          // Try to find any key that might contain course data or a list of courses
          for (var key in response.keys) {
            print('Checking key: $key');
            if (response[key] is Map<String, dynamic>) {
              final mapData = response[key] as Map<String, dynamic>;
              if (mapData.containsKey('_id') ||
                  mapData.containsKey('id') ||
                  mapData.containsKey('name') ||
                  mapData.containsKey('title')) {
                courseData = mapData;
                print('Found course data in response key: $key');
                break;
              }
            } else if (response[key] is List &&
                (response[key] as List).isNotEmpty) {
              // If key contains a list, check each item for a match
              final listData = response[key] as List;
              for (var item in listData) {
                if (item is Map<String, dynamic>) {
                  if ((item.containsKey('_id') && item['_id'] == courseId) ||
                      (item.containsKey('id') && item['id'] == courseId)) {
                    courseData = item;
                    print(
                      'Found exact matching course by ID in list of key: $key',
                    );
                    break;
                  }
                }
              }

              // If no exact match found, check if any item might be a course
              if (courseData == null) {
                for (var item in listData) {
                  if (item is Map<String, dynamic>) {
                    if (item.containsKey('_id') ||
                        item.containsKey('id') ||
                        item.containsKey('name') ||
                        item.containsKey('title')) {
                      courseData = item;
                      print(
                        'Found course data in first item of list in key: $key',
                      );
                      break;
                    }
                  }
                }
              }
            }
          }
        }

        if (courseData == null) {
          print('No course data found in response: $response');
          throw Exception('Course with ID $courseId not found');
        }

        print('Course data: $courseData');
        return Course.fromJson(courseData);
      } else if (response is List) {
        // Handle the case where the API directly returns an array
        print('Response is a list of length: ${response.length}');

        // Try to find the specific course in the list
        for (var item in response) {
          if (item is Map<String, dynamic>) {
            if ((item.containsKey('_id') && item['_id'] == courseId) ||
                (item.containsKey('id') && item['id'] == courseId)) {
              print(
                'Found exact matching course by ID in direct list response',
              );
              return Course.fromJson(item);
            }
          }
        }

        // If no exact match found but list is not empty, return the first item
        if (response.isNotEmpty) {
          print('No exact match found in list, using first item as fallback');
          return Course.fromJson(response[0]);
        }

        throw Exception('Course with ID $courseId not found in list response');
      } else {
        throw Exception(
          'Invalid response format: expected Map or non-empty List but got ${response.runtimeType}',
        );
      }
    } catch (e) {
      print('Get course by ID error: $e');
      rethrow;
    }
  }

  /// Get admin courses (admin/instructor)
  Future<List<Course>> getAdminCourses() async {
    try {
      print('Getting admin courses');

      final response = await _apiService.get(ApiEndpoints.getAdminCourses);

      print('Get admin courses response: $response');

      if (!response.containsKey('courses')) {
        throw Exception('Invalid response format: courses array not found');
      }

      final List<Course> courses =
          (response['courses'] as List)
              .map((course) => Course.fromJson(course))
              .toList();

      return courses;
    } catch (e) {
      print('Get admin courses error: $e');
      rethrow;
    }
  }
}
