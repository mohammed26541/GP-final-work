import 'package:flutter/material.dart';
import '../../../models/course/course.dart';
import 'course_card.dart';

class CoursesList extends StatelessWidget {
  final List<Course> courses;
  final VoidCallback onCourseOpened;
  
  const CoursesList({
    super.key,
    required this.courses,
    required this.onCourseOpened,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseCard(
          course: course,
          onCourseOpened: onCourseOpened,
        );
      },
    );
  }
}
