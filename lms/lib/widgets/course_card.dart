import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/course/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final bool isHorizontal;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width:
                isHorizontal
                    ? double.infinity
                    : constraints.maxWidth > 300
                    ? 260
                    : 220,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child:
                isHorizontal
                    ? _buildHorizontalCard(context)
                    : _buildVerticalCard(context),
          );
        },
      ),
    );
  }

  Widget _buildVerticalCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Thumbnail with badge for featured courses
        Stack(
          children: [
            // Thumbnail
            Hero(
              tag: 'course_${course.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: course.thumbnail,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        height: 120,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        height: 120,
                        width: double.infinity,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                ),
              ),
            ),

            // Featured badge if applicable
            if (course.isFeatured)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Featured',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Course Details
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  course.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Instructor
                if (course.instructorName.isNotEmpty)
                  Text(
                    "by ${course.instructorName}",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),

                // Rating and enrollment
                Row(
                  children: [
                    // Rating
                    if (course.rating > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            course.rating.toStringAsFixed(1),
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),

                    if (course.rating > 0 && course.totalStudents > 0)
                      const SizedBox(width: 8),

                    // Enrollments
                    if (course.totalStudents > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatEnrollments(course.totalStudents),
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price or Free
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (course.price <= 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Free',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (course.price > 0)
                      Text(
                        '\$${course.price.toStringAsFixed(2)}',
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail
        Hero(
          tag: 'course_${course.id}_horizontal',
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: course.thumbnail,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    height: 120,
                    width: 120,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    height: 120,
                    width: 120,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
            ),
          ),
        ),

        // Course Details
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  course.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Instructor
                if (course.instructorName.isNotEmpty)
                  Text(
                    "by ${course.instructorName}",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                const Spacer(flex: 1),

                // Rating and enrollment
                Row(
                  children: [
                    // Rating
                    if (course.rating > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            course.rating.toStringAsFixed(1),
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),

                    if (course.rating > 0 && course.totalStudents > 0)
                      const SizedBox(width: 8),

                    // Enrollments
                    if (course.totalStudents > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatEnrollments(course.totalStudents),
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),

                    const Spacer(),

                    // Price or Free
                    if (course.price <= 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Free',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (course.price > 0)
                      Text(
                        '\$${course.price.toStringAsFixed(2)}',
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatEnrollments(int enrollments) {
    if (enrollments >= 1000) {
      return '${(enrollments / 1000).toStringAsFixed(1)}K';
    } else if (enrollments >= 100) {
      return '$enrollments';
    } else {
      return '$enrollments students';
    }
  }
}
