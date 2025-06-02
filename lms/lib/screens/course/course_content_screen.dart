import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/course_provider/course_provider.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../models/course/course_content.dart';

import 'tabs/overview_tab.dart';
import 'tabs/resources_tab.dart';
import 'tabs/qa_tab.dart';
import 'tabs/reviews_tab.dart';
import 'utils/course_access_helper.dart';
import 'widgets/no_content_view.dart';
import 'widgets/video_player_widget.dart';

class CourseContentScreen extends StatefulWidget {
  final String courseId;

  const CourseContentScreen({super.key, required this.courseId});

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  int _selectedContentIndex = 0;
  int _selectedRating = 5;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _verifyCourseAccess();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _verifyCourseAccess() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final hasAccess = await CourseAccessHelper.verifyCourseAccess(
        context,
        widget.courseId,
        courseProvider,
        authProvider,
      );

      if (hasAccess && mounted) {
        // If user has access, fetch detailed course content
        await CourseAccessHelper.fetchCourseContent(
          context,
          widget.courseId,
          courseProvider,
        );
      } else if (mounted) {
        // User doesn't have access to content, but we still have the basic course data
        print(
          '🚧 User doesn\'t have access to course content, showing overview only',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectContent(CourseContent content, int index) async {
    if (index < 0 ||
        index >=
            Provider.of<CourseProvider>(
              context,
              listen: false,
            ).courseContent.length) {
      print('⚠️ Attempted to select content with invalid index: $index');
      return;
    }

    setState(() {
      _selectedContentIndex = index;
    });

    // await _initializeVideoPlayer(content);
  }

  Future<void> _submitQuestion() async {
    if (_questionController.text.isEmpty) return;

    try {
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );

      // Check if content is available
      if (courseProvider.courseContent.isEmpty ||
          _selectedContentIndex >= courseProvider.courseContent.length) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot submit question: content not available'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final content = courseProvider.courseContent[_selectedContentIndex];

      final success = await courseProvider.addQuestion(
        courseId: widget.courseId,
        contentId: content.id,
        question: _questionController.text.trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Question submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _questionController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting question: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitAnswer(String questionId) async {
    if (_answerController.text.isEmpty) return;

    try {
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );

      // Check if content is available
      if (courseProvider.courseContent.isEmpty ||
          _selectedContentIndex >= courseProvider.courseContent.length) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot submit answer: content not available'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final content = courseProvider.courseContent[_selectedContentIndex];

      final success = await courseProvider.addAnswer(
        courseId: widget.courseId,
        contentId: content.id,
        questionId: questionId,
        answer: _answerController.text.trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Answer submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _answerController.clear();

        // Refresh course content to ensure answers are persisted
        await courseProvider.fetchCourseContent(widget.courseId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting answer: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty) return;

    try {
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );

      final success = await courseProvider.addReview(
        courseId: widget.courseId,
        review: _reviewController.text.trim(),
        rating: _selectedRating.toDouble(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _reviewController.clear();
        _selectedRating = 5;

        // Refresh course data to show the new review
        await courseProvider.fetchCourseById(widget.courseId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting review: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateRating(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final List<CourseContent> courseContents = courseProvider.courseContent;
    final bool isAdmin = authProvider.currentUser?.role == 'admin';

    // Check if we need to use the fallback method
    final hasContent =
        _isLoading
            ? false
            : (CourseAccessHelper.checkCourseHasContent(
                  context,
                  courseProvider,
                ) ||
                courseContents.isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          courseProvider.selectedCourse?.name ?? 'Course Content',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                backgroundColor: Colors.red[100],
                avatar: const Icon(
                  Icons.admin_panel_settings,
                  size: 16,
                  color: Colors.red,
                ),
                label: const Text(
                  'Admin Access',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : !hasContent
              ? NoContentView(onRefresh: _verifyCourseAccess)
              : _buildContentView(courseProvider),
    );
  }

  Widget _buildContentView(CourseProvider courseProvider) {
    final course = courseProvider.selectedCourse;
    final courseContents = courseProvider.courseContent;

    // Guard against empty content
    if (courseContents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'No content available for this course',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The course content might be under development',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Safe way to get the selected content
    final selectedContentIndex =
        _selectedContentIndex < courseContents.length
            ? _selectedContentIndex
            : 0;
    final selectedContent =
        courseContents.isNotEmpty ? courseContents[selectedContentIndex] : null;

    // Using NestedScrollView to enable proper scrolling behavior
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // Video section as a SliverToBoxAdapter
          SliverToBoxAdapter(
            child: VideoPlayerWidget(videoId: selectedContent?.videoUrl ?? ''),
          ),

          // Course details section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withAlpha(25),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (courseContents.isNotEmpty &&
                      courseContents.length > selectedContentIndex)
                    Text(
                      courseContents[selectedContentIndex].title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (course != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          /*Text(
                            'Instructor: ${course.instructorName}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),*/
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Tab bar as a SliverAppBar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Resources'),
                  Tab(text: 'Q&A'),
                  Tab(text: 'Reviews'),
                ],
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ];
      },
      // Using TabBarView as the body to maintain the tabs functionality
      body: TabBarView(
        controller: _tabController,
        children: [
          // Overview Tab - scrollable by itself
          OverviewTab(
            courseProvider: courseProvider,
            onSelectContent: _selectContent,
          ),

          // Resources Tab - scrollable by itself
          ResourcesTab(
            courseProvider: courseProvider,
            selectedContentIndex: selectedContentIndex,
          ),

          // Q&A Tab - scrollable by itself
          QATab(
            courseProvider: courseProvider,
            selectedContentIndex: selectedContentIndex,
            questionController: _questionController,
            answerController: _answerController,
            onSubmitQuestion: _submitQuestion,
            onSubmitAnswer: _submitAnswer,
          ),

          // Reviews Tab - scrollable by itself
          ReviewsTab(
            courseProvider: courseProvider,
            reviewController: _reviewController,
            selectedRating: _selectedRating,
            onSubmitReview: _submitReview,
            onRatingChanged: _updateRating,
          ),
        ],
      ),
    );
  }
}

// Custom SliverPersistentHeaderDelegate for the TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar, {this.backgroundColor});

  final TabBar tabBar;
  final Color? backgroundColor;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor ?? Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
