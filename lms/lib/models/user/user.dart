class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String role;
  final bool isVerified;
  final List<String> courses;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar = '',
    this.role = 'student',
    this.isVerified = false,
    this.courses = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    // Handle avatar which might be a string or an object
    String avatarUrl = '';
    if (json['avatar'] != null) {
      if (json['avatar'] is String) {
        avatarUrl = json['avatar'];
      } else if (json['avatar'] is Map) {
        avatarUrl = json['avatar']['url'] ?? '';
      }
    }

    // Handle courses which might be a list of strings or a list of objects
    List<String> coursesList = [];
    if (json['courses'] != null) {
      if (json['courses'] is List) {
        coursesList = (json['courses'] as List).map((course) {
          if (course is String) {
            return course;
          } else if (course is Map) {
            // Check for both _id and id fields
            return (course['_id'] ?? course['id'] ?? '').toString();
          }
          return '';
        }).where((id) => id.isNotEmpty).toList();
      }
    }

    // Extract id (might be _id or id)
    String userId = '';
    if (json.containsKey('_id')) {
      userId = json['_id'].toString();
    } else if (json.containsKey('id')) {
      userId = json['id'].toString();
    }

    return User(
      id: userId,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: avatarUrl,
      role: json['role'] ?? 'student',
      isVerified: json['isVerified'] ?? false,
      courses: coursesList,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
      'isVerified': isVerified,
      'courses': courses,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a copy of the user with some updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? role,
    bool? isVerified,
    List<String>? courses,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      courses: courses ?? this.courses,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
