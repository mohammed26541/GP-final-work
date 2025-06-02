import '../user/user.dart';

class CourseReview {
  final String id;
  final String comment;
  final double rating;
  final User user;
  final DateTime createdAt;

  CourseReview({
    required this.id,
    required this.comment,
    required this.rating,
    required this.user,
    required this.createdAt,
  });

  factory CourseReview.fromJson(Map<String, dynamic> json) {
    try {
      // Extract user data
      User reviewUser;
      if (json['user'] != null) {
        reviewUser = User.fromJson(json['user']);
      } else {
        reviewUser = User(
          id: json['userId'] ?? '',
          name: json['userName'] ?? 'Anonymous',
          email: '',
          avatar: json['userAvatar'] ?? '',
        );
      }

      return CourseReview(
        id: json['_id'] ?? json['id'] ?? '',
        comment: json['comment'] ?? json['review'] ?? '',
        rating: (json['rating'] ?? 0).toDouble(),
        user: reviewUser,
        createdAt:
            json['createdAt'] != null
                ? DateTime.parse(json['createdAt'])
                : DateTime.now(),
      );
    } catch (e) {
      print('❌ Error creating CourseReview from JSON: $e');
      print('❌ Problematic JSON: $json');
      return CourseReview(
        id: json['_id'] ?? json['id'] ?? 'error',
        comment: 'Error loading review',
        rating: 0.0,
        user: User(id: '', name: 'Unknown User', email: ''),
        createdAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'comment': comment,
      'rating': rating,
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class CourseReviewReply {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String reply;
  final DateTime createdAt;

  CourseReviewReply({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.reply,
    required this.createdAt,
  });

  factory CourseReviewReply.fromJson(Map<String, dynamic> json) {
    return CourseReviewReply(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      reply: json['reply'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'reply': reply,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
