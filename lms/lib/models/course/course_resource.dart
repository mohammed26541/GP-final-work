class CourseResource {
  final String id;
  final String title;
  final String fileUrl;
  final String description;

  CourseResource({
    required this.id,
    required this.title,
    required this.fileUrl,
    this.description = '',
  });

  factory CourseResource.fromJson(Map<String, dynamic> json) {
    return CourseResource(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      fileUrl: json['fileUrl'] ?? json['url'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'fileUrl': fileUrl,
      'description': description,
    };
  }
}
