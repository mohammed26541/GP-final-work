class Order {
  final String id;
  final String courseId;
  final String courseName;
  final String courseThumbnail;
  final String userId;
  final String userName;
  final String userEmail;
  final double price;
  final String paymentMethod;
  final String status; // pending, completed, failed
  final String transactionId;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.courseThumbnail,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.price,
    required this.paymentMethod,
    required this.status,
    required this.transactionId,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      courseId: json['courseId'] ?? '',
      courseName: json['courseName'] ?? '',
      courseThumbnail: json['courseThumbnail'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'stripe',
      status: json['status'] ?? 'pending',
      transactionId: json['transactionId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'courseId': courseId,
      'courseName': courseName,
      'courseThumbnail': courseThumbnail,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'price': price,
      'paymentMethod': paymentMethod,
      'status': status,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
