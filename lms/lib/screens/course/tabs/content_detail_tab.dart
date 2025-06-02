import 'package:flutter/material.dart';
import '../../../models/course/course.dart';
import '../utils/format_utils.dart';

class ContentDetailTab extends StatelessWidget {
  final Course course;

  const ContentDetailTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    if (course.content.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'No content available for this course yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'The instructor is still preparing the course materials',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${course.content.length} Sections',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(course.content.length, (index) {
          final content = course.content[index];
          final videoLength = content.videoLength;
          final resourcesCount = content.resources.length;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Text(
                content.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${FormatUtils.formatDuration(videoLength)} • $resourcesCount resources',
                ),
              ),
              leading: const Icon(Icons.play_circle_outline),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(content.description),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
