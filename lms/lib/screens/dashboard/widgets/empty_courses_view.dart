import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/course_provider/course_provider.dart';
import '../../../screens/main_navigation.dart';

class EmptyCoursesView extends StatelessWidget {
  const EmptyCoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, color: Colors.grey[400], size: 64),
            const SizedBox(height: 16),
            const Text(
              "You haven't enrolled in any courses yet",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              "Browse our catalog and enroll in a course to get started on your learning journey",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainNavigation(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              label: const Text(
                'Browse Courses',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              icon: const Icon(Icons.bug_report, size: 16),
              label: const Text('Show Sample Courses (Debug)'),
              onPressed: () {
                final courseProvider = Provider.of<CourseProvider>(
                  context,
                  listen: false,
                );
                courseProvider.setSampleMyCourses();
              },
            ),
          ],
        ),
      ),
    );
  }
}
