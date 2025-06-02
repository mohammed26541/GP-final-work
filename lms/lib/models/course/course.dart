import 'course_content.dart';
import 'course_review.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final String thumbnail;
  final String instructor;
  final String instructorName;
  final List<String> tags;
  final double price;
  final double discountedPrice;
  final int durationInWeeks;
  final List<CourseContent> content;
  final List<CourseReview> reviews;
  final double rating;
  final int totalStudents;
  final bool isFeatured;
  final bool isEnrolled;
  final DateTime createdAt;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.instructor,
    required this.instructorName,
    required this.tags,
    required this.price,
    required this.discountedPrice,
    required this.durationInWeeks,
    required this.content,
    required this.reviews,
    required this.rating,
    required this.totalStudents,
    required this.isFeatured,
    this.isEnrolled = false,
    required this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    try {
      // Debug raw data
      print('🔄 Parsing course: ${json['_id'] ?? json['id'] ?? 'unknown id'}');

      // Extract thumbnail URL handling different formats
      String extractThumbnail() {
        if (json['thumbnail'] is String) {
          return json['thumbnail'];
        } else if (json['thumbnail'] is Map) {
          final thumbMap = json['thumbnail'] as Map;
          if (thumbMap.containsKey('url')) {
            return thumbMap['url'] as String;
          }
        }
        return json['image'] ?? '';
      }

      // Handle tags/categories that can be either string or list
      List<String> extractTags() {
        // Handle tags
        if (json['tags'] != null) {
          if (json['tags'] is String) {
            // If tags is a string, split by commas or return as a single-item list
            return json['tags'].toString().contains(',')
                ? json['tags']
                    .toString()
                    .split(',')
                    .map((e) => e.trim())
                    .toList()
                : [json['tags'].toString()];
          } else if (json['tags'] is List) {
            return (json['tags'] as List).map((e) => e.toString()).toList();
          }
        }

        // Handle categories as fallback
        if (json['categories'] != null) {
          if (json['categories'] is String) {
            // If categories is a string, split by commas or return as a single-item list
            return json['categories'].toString().contains(',')
                ? json['categories']
                    .toString()
                    .split(',')
                    .map((e) => e.trim())
                    .toList()
                : [json['categories'].toString()];
          } else if (json['categories'] is List) {
            return (json['categories'] as List)
                .map((e) => e.toString())
                .toList();
          }
        }

        return []; // Empty list as fallback
      }

      // Extract instructor information
      String extractInstructorName() {
        // Check different possible fields for instructor name
        if (json['instructorName'] is String &&
            json['instructorName'].isNotEmpty) {
          return json['instructorName'];
        }

        // Check for instructor object with name property
        if (json['instructor'] is Map<String, dynamic>) {
          final instructorObj = json['instructor'] as Map<String, dynamic>;
          if (instructorObj.containsKey('name') &&
              instructorObj['name'] is String) {
            return instructorObj['name'];
          }
        }

        // Check for creator/owner object
        if (json['createdBy'] is Map<String, dynamic>) {
          final creatorObj = json['createdBy'] as Map<String, dynamic>;
          if (creatorObj.containsKey('name') && creatorObj['name'] is String) {
            return creatorObj['name'];
          }
        }

        // Check for user object
        if (json['user'] is Map<String, dynamic>) {
          final userObj = json['user'] as Map<String, dynamic>;
          if (userObj.containsKey('name') && userObj['name'] is String) {
            return userObj['name'];
          }
        }

        // Try plain instructor field as string
        if (json['instructor'] is String && json['instructor'].isNotEmpty) {
          return json['instructor'];
        }

        // Try other possible fields
        if (json['createdByName'] is String &&
            json['createdByName'].isNotEmpty) {
          return json['createdByName'];
        }

        if (json['owner'] is String && json['owner'].isNotEmpty) {
          return json['owner'];
        }

        // Return empty string if nothing found
        return '';
      }

      // Parse content data safely
      List<CourseContent> parseContent() {
        try {
          if (json['courseData'] != null) {
            if (json['courseData'] is List) {
              return (json['courseData'] as List)
                  .where((e) => e != null)
                  .map((e) => CourseContent.fromJson(e))
                  .toList();
            }
          } else if (json['content'] != null) {
            if (json['content'] is List) {
              return (json['content'] as List)
                  .where((e) => e != null)
                  .map((e) => CourseContent.fromJson(e))
                  .toList();
            }
          }
          return [];
        } catch (e) {
          print('⚠️ Error parsing course content: $e');
          return [];
        }
      }

      // Parse reviews data safely
      List<CourseReview> parseReviews() {
        try {
          if (json['reviews'] != null && json['reviews'] is List) {
            return (json['reviews'] as List)
                .where((e) => e != null)
                .map((e) => CourseReview.fromJson(e))
                .toList();
          }
          return [];
        } catch (e) {
          print('⚠️ Error parsing course reviews: $e');
          return [];
        }
      }

      return Course(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? json['title'] ?? '',
        description: json['description'] ?? '',
        thumbnail: extractThumbnail(),
        instructor:
            json['instructor'] ??
            json['instructorId'] ??
            json['createdBy'] ??
            '',
        instructorName: extractInstructorName(),
        tags: extractTags(),
        price: (json['price'] ?? 0).toDouble(),
        discountedPrice:
            (json['discountedPrice'] ??
                    json['estimatedPrice'] ??
                    json['discounted'] ??
                    0)
                .toDouble(),
        durationInWeeks: json['durationInWeeks'] ?? json['duration'] ?? 0,
        content: parseContent(),
        reviews: parseReviews(),
        rating:
            (json['rating'] ?? json['ratings'] ?? json['averageRating'] ?? 0)
                .toDouble(),
        totalStudents:
            json['totalStudents'] ??
            json['students'] ??
            json['purchased'] ??
            json['enrollments'] ??
            0,
        isFeatured: json['isFeatured'] ?? json['featured'] ?? false,
        isEnrolled: json['isEnrolled'] ?? json['enrolled'] ?? false,
        createdAt:
            json['createdAt'] != null
                ? DateTime.parse(json['createdAt'])
                : (json['created'] != null
                    ? DateTime.parse(json['created'])
                    : DateTime.now()),
      );
    } catch (e) {
      print('❌ Error creating Course from JSON: $e');
      print('❌ Problematic JSON: $json');

      // Return a fallback Course object with minimal data to prevent crashes
      return Course(
        id: json['_id'] ?? json['id'] ?? 'error-id',
        name: json['name'] ?? json['title'] ?? 'Error Loading Course',
        description: 'There was an error loading this course.',
        thumbnail: '',
        instructor: '',
        instructorName: 'Unknown',
        tags: [],
        price: 0.0,
        discountedPrice: 0.0,
        durationInWeeks: 0,
        content: [],
        reviews: [],
        rating: 0.0,
        totalStudents: 0,
        isFeatured: false,
        isEnrolled: true,
        createdAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
      'instructor': instructor,
      'instructorName': instructorName,
      'tags': tags,
      'price': price,
      'discountedPrice': discountedPrice,
      'durationInWeeks': durationInWeeks,
      'content': content.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'rating': rating,
      'totalStudents': totalStudents,
      'isFeatured': isFeatured,
      'isEnrolled': isEnrolled,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  /// Creates an empty Course object for fallback purposes
  factory Course.empty() {
    return Course(
      id: 'empty-id',
      name: 'Unknown Course',
      description: 'No description available',
      thumbnail: '',
      instructor: '',
      instructorName: 'Unknown',
      tags: [],
      price: 0.0,
      discountedPrice: 0.0,
      durationInWeeks: 0,
      content: [],
      reviews: [],
      rating: 0.0,
      totalStudents: 0,
      isFeatured: false,
      isEnrolled: false,
      createdAt: DateTime.now(),
    );
  }
}
