import 'package:flutter/material.dart';
import '../../../models/course/course.dart';
import '../../../screens/course/course_content_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onCourseOpened;

  const CourseCard({
    super.key,
    required this.course,
    required this.onCourseOpened,
  });

  @override
  Widget build(BuildContext context) {
    final progress = 0.0; // In a real app, you would track actual progress

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (course.id.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CourseContentScreen(courseId: course.id),
                ),
              ).then((_) => onCourseOpened());
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course title section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16.0, color: Colors.grey[600]),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            'Instructor: ${course.instructorName}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            '${course.durationInWeeks} weeks',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Icon(Icons.people, size: 16.0, color: Colors.grey[600]),
                        const SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            '${course.totalStudents} students',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),

                    // Progress bar
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          progress > 0
                              ? '${(progress * 100).toInt()}% Complete'
                              : 'Not started',
                          style: TextStyle(
                            fontSize: 12.0,
                            color:
                                progress > 0
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[600],
                          ),
                        ),
                        if (progress >= 1.0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Continue button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(25),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('Continue Learning'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CourseContentScreen(courseId: course.id),
                        ),
                      ).then((_) => onCourseOpened());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
