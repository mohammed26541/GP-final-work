import 'course_resource.dart';
import 'course_question.dart';

class CourseContent {
  final String id;
  final String title;
  final String description;
  final int videoLength; // in seconds
  final String videoUrl;
  final String videoSection;
  final List<CourseResource> resources;
  final List<CourseQuestion> questions;

  CourseContent({
    required this.id,
    required this.title,
    required this.description,
    required this.videoLength,
    required this.videoUrl,
    this.videoSection = '',
    required this.resources,
    required this.questions,
  });

  factory CourseContent.fromJson(Map<String, dynamic> json) {
    return CourseContent(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoLength: json['videoLength'] ?? 0,
      videoUrl: json['videoUrl'] ?? '',
      videoSection: json['videoSection'] ?? '',
      resources:
          json['resources'] != null
              ? (json['resources'] as List)
                  .map((e) => CourseResource.fromJson(e))
                  .toList()
              : [],
      questions:
          json['questions'] != null
              ? (json['questions'] as List)
                  .map((e) => CourseQuestion.fromJson(e))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'videoLength': videoLength,
      'videoUrl': videoUrl,
      'videoSection': videoSection,
      'resources': resources.map((e) => e.toJson()).toList(),
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}
