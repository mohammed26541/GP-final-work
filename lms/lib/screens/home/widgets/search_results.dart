import 'package:flutter/material.dart';
import '../../../models/course/course.dart';
import '../../../widgets/course_card.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/empty_state.dart';
import '../../course/course_detail_screen.dart';

class SearchResults extends StatelessWidget {
  final List<Course> courses;
  final bool isLargeScreen;
  final bool isTablet;
  final bool isLoading;
  final String? searchQuery;

  const SearchResults({
    super.key,
    required this.courses,
    this.isLargeScreen = false,
    this.isTablet = false,
    this.isLoading = false,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Handle loading state
    if (isLoading) {
      return LoadingState(
        message: 'Searching courses...',
        animationAsset: 'assets/animations/loading.json',
      );
    }

    // Handle empty results
    if (courses.isEmpty) {
      return EmptyState(
        title: 'No Results Found',
        message:
            searchQuery != null && searchQuery!.isNotEmpty
                ? 'No courses found for "$searchQuery"'
                : 'No courses match your search criteria',
        animationAsset: 'assets/animations/empty_search.json',
        icon: Icons.search_off_outlined,
        iconColor: colorScheme.primary,
      );
    }

    return CustomCardWithHeader(
      title: 'Search Results',
      subtitle: '${courses.length} courses found',
      leading: Icon(Icons.search, color: colorScheme.primary),
      content: _buildContent(context),
      elevation: 0.5,
      borderRadius: BorderRadius.circular(16),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLargeScreen || isTablet) {
      return _buildGridView(context);
    } else {
      return _buildListView(context);
    }
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CourseCard(
            course: course,
            isHorizontal: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(courseId: course.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context) {
    final crossAxisCount = isLargeScreen ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseCard(
          course: course,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(courseId: course.id),
              ),
            );
          },
        );
      },
    );
  }
}
