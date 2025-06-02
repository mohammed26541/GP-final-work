import 'package:flutter/material.dart';
import '../../../models/course/course.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/course_card.dart';
import '../../../widgets/empty_state.dart';
import '../../course/course_detail_screen.dart';

class CourseListHorizontal extends StatelessWidget {
  final List<Course> courses;
  final bool isLoading;
  final String emptyMessage;
  final String? emptyStateAnimationAsset;

  const CourseListHorizontal({
    super.key,
    required this.courses,
    required this.isLoading,
    this.emptyMessage = 'No courses available',
    this.emptyStateAnimationAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return LoadingState(
        message: 'Loading courses...',
        animationAsset: 'assets/animations/loading.json',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust card height based on available width
        final deviceType = ResponsiveHelper.getDeviceType(context);
        final cardHeight = switch (deviceType) {
          DeviceType.desktop => 320.0,
          DeviceType.tablet => 300.0,
          DeviceType.mobile => 280.0,
        };

        // If no courses, show empty state
        if (courses.isEmpty) {
          return EmptyState(
            title: 'No Courses Found',
            message: emptyMessage,
            animationAsset:
                emptyStateAnimationAsset ??
                'assets/animations/empty_courses.json',
            icon: Icons.school_outlined,
            iconColor: colorScheme.primary,
          );
        }

        return SizedBox(
          height: cardHeight,
          child: ListView.builder(
            padding: ResponsiveHelper.getHorizontalPadding(context),
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final course = courses[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: SizedBox(
                  width: 280,
                  child: CourseCard(
                    course: course,
                    onTap: () {
                      // Navigate to course detail
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CourseDetailScreen(courseId: course.id),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
