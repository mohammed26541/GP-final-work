import '../../constants/api_endpoints.dart';
import '../../models/course/course_question.dart';
import '../../models/course/course_review.dart';
import '../api_service/api_service.dart';
import '../../models/user/user.dart';

/// Handles operations related to course interactions (questions, reviews, replies)
class CourseInteractionOperations {
  final ApiService _apiService;

  CourseInteractionOperations({required ApiService apiService})
    : _apiService = apiService;

  /// Add question to course
  Future<CourseQuestion> addQuestion({
    required String courseId,
    required String contentId,
    required String question,
  }) async {
    try {
      final data = {
        'courseId': courseId,
        'contentId': contentId,
        'question': question,
      };

      print('📝 Adding question with data: $data');

      final response = await _apiService.put(
        ApiEndpoints.addQuestion,
        data: data,
      );

      print('📝 Add question response: $response');

      // Check response structure
      CourseQuestion? parsedQuestion;

      if (response is Map<String, dynamic>) {
        if (response.containsKey('question')) {
          parsedQuestion = CourseQuestion.fromJson(response['question']);
        } else if (response.containsKey('courseQuestion')) {
          parsedQuestion = CourseQuestion.fromJson(response['courseQuestion']);
        } else if (response.containsKey('data')) {
          parsedQuestion = CourseQuestion.fromJson(response['data']);
        } else {
          // Try to parse the entire response as a question
          try {
            parsedQuestion = CourseQuestion.fromJson(response);
          } catch (e) {
            print('❌ Could not parse response as question: $e');
          }
        }
      }

      if (parsedQuestion == null) {
        throw Exception('Invalid response format: question object not found');
      }

      return parsedQuestion;
    } catch (e) {
      print('❌ Add question error: $e');
      rethrow;
    }
  }

  /// Add answer to question
  Future<CourseAnswer> addAnswer({
    required String courseId,
    required String contentId,
    required String questionId,
    required String answer,
  }) async {
    try {
      final data = {
        'courseId': courseId,
        'contentId': contentId,
        'questionId': questionId,
        'answer': answer,
      };

      print('📝 Adding answer with data: $data');

      final response = await _apiService.put(
        ApiEndpoints.addAnswer,
        data: data,
      );

      print('📝 Add answer response: $response');

      // Check response structure
      CourseAnswer? parsedAnswer;

      if (response is Map<String, dynamic>) {
        if (response.containsKey('course') && response['success'] == true) {
          // Extract the course data
          final courseData = response['course'];

          // Find the content item
          final contentItem = courseData['courseData']?.firstWhere(
            (content) => content['_id'] == contentId,
            orElse: () => null,
          );

          if (contentItem != null) {
            // Find the question
            final question = contentItem['questions']?.firstWhere(
              (q) => q['_id'] == questionId,
              orElse: () => null,
            );

            if (question != null &&
                question['questionReplies'] is List &&
                question['questionReplies'].isNotEmpty) {
              // Get the last added answer
              final lastAnswer = question['questionReplies'].last;
              parsedAnswer = CourseAnswer.fromJson(lastAnswer);
            }
          }
        } else if (response.containsKey('answer')) {
          parsedAnswer = CourseAnswer.fromJson(response['answer']);
        } else if (response.containsKey('questionAnswer')) {
          parsedAnswer = CourseAnswer.fromJson(response['questionAnswer']);
        } else if (response.containsKey('data')) {
          parsedAnswer = CourseAnswer.fromJson(response['data']);
        } else {
          // Try to parse the entire response as an answer
          try {
            parsedAnswer = CourseAnswer.fromJson(response);
          } catch (e) {
            print('❌ Could not parse response as answer: $e');
          }
        }
      }

      if (parsedAnswer == null) {
        // Create a minimal answer object when response parsing fails
        // This ensures we at least have the answer data in the UI
        print('⚠️ Creating fallback answer object');
        parsedAnswer = CourseAnswer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          answer: answer,
          user: User(id: 'local-user', name: 'You', email: '', avatar: ''),
          createdAt: DateTime.now(),
        );
      }

      return parsedAnswer;
    } catch (e) {
      print('❌ Add answer error: $e');
      rethrow;
    }
  }

  /// Add review to course
  Future<bool> addReview({
    required String courseId,
    required String review,
    required double rating,
  }) async {
    try {
      final data = {'review': review, 'rating': rating};

      print('Adding review with data: $data');

      final response = await _apiService.put(
        ApiEndpoints.addReview(courseId),
        data: data,
      );

      print('Add review response: $response');

      if (response == null) {
        throw Exception('Invalid response: null');
      }

      return true;
    } catch (e) {
      print('Add review error: $e');
      return false;
    }
  }

  /// Add reply to review
  Future<CourseReviewReply> addReply({
    required String courseId,
    required String reviewId,
    required String reply,
  }) async {
    try {
      final data = {'courseId': courseId, 'reviewId': reviewId, 'reply': reply};

      print('Adding reply with data: $data');

      final response = await _apiService.put(ApiEndpoints.addReply, data: data);

      print('Add reply response: $response');

      if (!response.containsKey('reply')) {
        throw Exception('Invalid response format: reply object not found');
      }

      return CourseReviewReply.fromJson(response['reply']);
    } catch (e) {
      print('Add reply error: $e');
      rethrow;
    }
  }
}
