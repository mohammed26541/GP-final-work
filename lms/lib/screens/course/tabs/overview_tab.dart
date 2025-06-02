import 'package:flutter/material.dart';
import '../../../models/course/course_content.dart';
import '../../../providers/course_provider/course_provider.dart';

class OverviewTab extends StatelessWidget {
  final CourseProvider courseProvider;
  final Function(CourseContent, int) onSelectContent;

  const OverviewTab({
    super.key,
    required this.courseProvider,
    required this.onSelectContent,
  });

  @override
  Widget build(BuildContext context) {
    final course = courseProvider.selectedCourse;

    if (course == null) {
      return const Center(child: Text('Course information not available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Course',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(course.description),
          const SizedBox(height: 24),

          // Course details
          Text('Course Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildDetailItem(
            Icons.access_time,
            'Duration',
            '${course.durationInWeeks} weeks',
          ),
          _buildDetailItem(
            Icons.people,
            'Enrolled',
            '${course.totalStudents} students',
          ),
          _buildDetailItem(Icons.star, 'Rating', '${course.rating}/5.0'),

          const SizedBox(height: 24),

          // Content List as a preview
          Text('Course Content', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          if (courseProvider.courseContent.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No content available for this course yet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courseProvider.courseContent.length,
              itemBuilder: (context, index) {
                final content = courseProvider.courseContent[index];
                return ListTile(
                  title: Text(content.title),
                  subtitle: Text(_formatDuration(content.videoLength)),
                  leading: const Icon(Icons.play_circle_outline),
                  onTap: () {
                    onSelectContent(content, index);
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  // Helper for building detail items in overview
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, overflow: TextOverflow.ellipsis, maxLines: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to format duration
  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) {
      return '0:00';
    }
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
