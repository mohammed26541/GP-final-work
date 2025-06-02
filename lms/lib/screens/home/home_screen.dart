import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../providers/course_provider/course_provider.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_animation.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/course_card.dart';
import '../course/course_detail_screen.dart';
import 'utils/course_fetch_helper.dart';
import 'widgets/home_header.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_results.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _hasSearched = false; // Flag to track if a search has been performed

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Fetches featured and recommended courses
  Future<void> _fetchData() async {
    await CourseFetchHelper.fetchHomeData(context);
  }

  /// Handles course search
  Future<void> _searchCourses() async {
    await CourseFetchHelper.searchCourses(
      context,
      _searchController.text,
      (value) => setState(() => _isSearching = value),
      (value) => setState(() => _hasSearched = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ResponsiveScaffold(
      body: RefreshIndicator(
        color: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        onRefresh: _fetchData,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine if we should use a grid layout for larger screens
            final isLargeScreen = ResponsiveHelper.isDesktop(context);
            final isTablet = ResponsiveHelper.isTablet(context);

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar with Profile
                  HomeHeader(authProvider: authProvider),

                  // Search Bar
                  Padding(
                    padding: ResponsiveHelper.getHorizontalPadding(
                      context,
                    ).copyWith(top: 8, bottom: 16),
                    child: SearchBarWidget(
                      controller: _searchController,
                      onSearch: _searchCourses,
                      isSearching: _isSearching,
                    ),
                  ),

                  // Search Results (if any)
                  if (_hasSearched && _isSearching)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: PulsatingLoadingAnimation(
                          showLabel: true,
                          text: 'Searching courses...',
                        ),
                      ),
                    )
                  else if (_hasSearched && courseProvider.courses.isNotEmpty)
                    Padding(
                      padding: ResponsiveHelper.getHorizontalPadding(context),
                      child: SearchResults(
                        courses: courseProvider.courses,
                        isLargeScreen: isLargeScreen,
                        isTablet: isTablet,
                        searchQuery: _searchController.text,
                      ),
                    )
                  else if (_hasSearched && courseProvider.courses.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: EmptyState(
                        title: 'No Results Found',
                        message:
                            'No courses found for "${_searchController.text}"',
                        animationAsset: 'assets/animations/empty_search.json',
                        icon: Icons.search_off_outlined,
                        iconColor: colorScheme.primary,
                      ),
                    ),

                  // Only show Featured and Recommended sections if not searching
                  if (!_hasSearched || courseProvider.courses.isEmpty) ...[
                    // Featured Courses Section
                    CustomCardWithHeader(
                      title: 'Featured Courses',
                      leading: Icon(Icons.star, color: colorScheme.primary),
                      trailing: null,
                      margin: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.responsive(
                          context,
                          mobile: 16,
                          tablet: 24,
                          desktop: 32,
                        ),
                        vertical: 8,
                      ),
                      elevation: 0.5,
                      content: SizedBox(
                        height: ResponsiveHelper.responsive(
                          context,
                          mobile: 280,
                          tablet: 300,
                          desktop: 320,
                        ),
                        child:
                            courseProvider.isLoading
                                ? Center(
                                  child: LoadingAnimation(
                                    showLabel: true,
                                    text: 'Loading featured courses...',
                                    color: colorScheme.primary,
                                  ),
                                )
                                : courseProvider.featuredCourses.isEmpty
                                ? Center(
                                  child: Text(
                                    'No featured courses available',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      courseProvider.featuredCourses.length,
                                  itemBuilder: (context, index) {
                                    final course =
                                        courseProvider.featuredCourses[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: SizedBox(
                                        width: ResponsiveHelper.responsive(
                                          context,
                                          mobile: 220,
                                          tablet: 240,
                                          desktop: 260,
                                        ),
                                        child: CourseCard(
                                          course: course,
                                          onTap: () {
                                            // Navigate to course detail
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        CourseDetailScreen(
                                                          courseId: course.id,
                                                        ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Recommended Courses Section
                    CustomCardWithHeader(
                      title: 'Recommended For You',
                      leading: Icon(
                        Icons.recommend,
                        color: colorScheme.primary,
                      ),
                      trailing: null,
                      margin: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.responsive(
                          context,
                          mobile: 16,
                          tablet: 24,
                          desktop: 32,
                        ),
                        vertical: 8,
                      ),
                      elevation: 0.5,
                      content: SizedBox(
                        height: ResponsiveHelper.responsive(
                          context,
                          mobile: 280,
                          tablet: 300,
                          desktop: 320,
                        ),
                        child:
                            courseProvider.isLoading
                                ? Center(
                                  child: LoadingAnimation(
                                    showLabel: true,
                                    text: 'Loading recommended courses...',
                                    color: colorScheme.primary,
                                  ),
                                )
                                : courseProvider.recommendedCourses.isEmpty
                                ? Center(
                                  child: Text(
                                    'No recommended courses available',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      courseProvider.recommendedCourses.length,
                                  itemBuilder: (context, index) {
                                    final course =
                                        courseProvider
                                            .recommendedCourses[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: SizedBox(
                                        width: ResponsiveHelper.responsive(
                                          context,
                                          mobile: 220,
                                          tablet: 240,
                                          desktop: 260,
                                        ),
                                        child: CourseCard(
                                          course: course,
                                          onTap: () {
                                            // Navigate to course detail
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        CourseDetailScreen(
                                                          courseId: course.id,
                                                        ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
