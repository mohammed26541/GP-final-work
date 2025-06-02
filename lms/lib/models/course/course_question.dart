import '../user/user.dart';

class CourseQuestion {
  final String id;
  final String question;
  final User user;
  final DateTime createdAt;
  final List<CourseAnswer> answers;

  CourseQuestion({
    required this.id,
    required this.question,
    required this.user,
    required this.createdAt,
    required this.answers,
  });

  factory CourseQuestion.fromJson(Map<String, dynamic> json) {
    try {
      // Extract user data
      User questionUser;
      if (json['user'] != null) {
        questionUser = User.fromJson(json['user']);
      } else {
        questionUser = User(
          id: json['userId'] ?? '',
          name: json['userName'] ?? 'Anonymous',
          email: '',
          avatar: json['userAvatar'] ?? '',
        );
      }

      return CourseQuestion(
        id: json['_id'] ?? json['id'] ?? '',
        question: json['question'] ?? '',
        user: questionUser,
        createdAt:
            json['createdAt'] != null
                ? DateTime.parse(json['createdAt'])
                : DateTime.now(),
        answers:
            json['answers'] != null
                ? (json['answers'] as List)
                    .map((answer) => CourseAnswer.fromJson(answer))
                    .toList()
                : [],
      );
    } catch (e) {
      print('❌ Error creating CourseQuestion from JSON: $e');
      print('❌ Problematic JSON: $json');
      return CourseQuestion(
        id: json['_id'] ?? json['id'] ?? 'error',
        question: json['question'] ?? 'Error loading question',
        user: User(id: '', name: 'Unknown User', email: ''),
        createdAt: DateTime.now(),
        answers: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class CourseAnswer {
  final String id;
  final String answer;
  final User user;
  final DateTime createdAt;

  CourseAnswer({
    required this.id,
    required this.answer,
    required this.user,
    required this.createdAt,
  });

  factory CourseAnswer.fromJson(Map<String, dynamic> json) {
    try {
      // Extract user data
      User answerUser;
      if (json['user'] != null) {
        answerUser = User.fromJson(json['user']);
      } else {
        answerUser = User(
          id: json['userId'] ?? '',
          name: json['userName'] ?? 'Anonymous',
          email: '',
          avatar: json['userAvatar'] ?? '',
        );
      }

      return CourseAnswer(
        id: json['_id'] ?? json['id'] ?? '',
        answer: json['answer'] ?? '',
        user: answerUser,
        createdAt:
            json['createdAt'] != null
                ? DateTime.parse(json['createdAt'])
                : DateTime.now(),
      );
    } catch (e) {
      print('❌ Error creating CourseAnswer from JSON: $e');
      print('❌ Problematic JSON: $json');
      return CourseAnswer(
        id: json['_id'] ?? json['id'] ?? 'error',
        answer: json['answer'] ?? 'Error loading answer',
        user: User(id: '', name: 'Unknown User', email: ''),
        createdAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'answer': answer,
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
