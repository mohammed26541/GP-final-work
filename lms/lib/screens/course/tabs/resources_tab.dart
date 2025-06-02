import 'package:flutter/material.dart';
import '../../../providers/course_provider/course_provider.dart';

class ResourcesTab extends StatelessWidget {
  final CourseProvider courseProvider;
  final int selectedContentIndex;

  const ResourcesTab({
    super.key,
    required this.courseProvider,
    required this.selectedContentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final courseContent = courseProvider.courseContent;

    // Check if courseContent is empty
    if (courseContent.isEmpty) {
      return const Center(child: Text('No resources available'));
    }

    // Validate the selectedContentIndex is within bounds
    if (selectedContentIndex < 0 ||
        selectedContentIndex >= courseContent.length) {
      return const Center(child: Text('Invalid content selection'));
    }

    final content = courseContent[selectedContentIndex];

    if (content.resources.isEmpty) {
      return const Center(
        child: Text('No resources available for this lesson'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: content.resources.length,
      itemBuilder: (context, index) {
        final resource = content.resources[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(resource.title),
            subtitle: Text(resource.description),
            trailing: const Icon(Icons.download),
            onTap: () {
              // Implement resource download logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading ${resource.title}...'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
