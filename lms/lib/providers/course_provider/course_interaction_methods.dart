import '../../models/course/course_question.dart';
import '../../models/course/course_content.dart';
import '../../services/course_service/course_service.dart';

/// Methods for interacting with course content (questions, answers, reviews)
class CourseInteractionMethods {
  final CourseService _courseService;
  
  CourseInteractionMethods(this._courseService);
  
  /// Add question to course
  Future<CourseQuestion> addQuestion({
    required String courseId,
    required String contentId,
    required String question,
  }) async {
    return await _courseService.addQuestion(
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
    return await _courseService.addAnswer(
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
    return await _courseService.addReview(
      courseId: courseId,
      review: review,
      rating: rating,
    );
  }
  
  /// Helper method to update course content with a new question
  CourseContent updateContentWithQuestion(
    CourseContent content,
    CourseQuestion question,
  ) {
    final updatedQuestions = [...content.questions, question];
    
    return CourseContent(
      id: content.id,
      title: content.title,
      description: content.description,
      videoLength: content.videoLength,
      videoUrl: content.videoUrl,
      resources: content.resources,
      questions: updatedQuestions,
    );
  }
  
  /// Helper method to update course content with a new answer
  CourseContent updateContentWithAnswer(
    CourseContent content,
    String questionId,
    CourseAnswer answer,
  ) {
    final questionIndex = content.questions.indexWhere(
      (q) => q.id == questionId,
    );
    
    if (questionIndex == -1) {
      // Question not found, return unchanged content
      return content;
    }
    
    final question = content.questions[questionIndex];
    final updatedAnswers = [...question.answers, answer];
    
    final updatedQuestion = CourseQuestion(
      id: question.id,
      question: question.question,
      user: question.user,
      createdAt: question.createdAt,
      answers: updatedAnswers,
    );
    
    final updatedQuestions = [...content.questions];
    updatedQuestions[questionIndex] = updatedQuestion;
    
    return CourseContent(
      id: content.id,
      title: content.title,
      description: content.description,
      videoLength: content.videoLength,
      videoUrl: content.videoUrl,
      resources: content.resources,
      questions: updatedQuestions,
    );
  }
}
