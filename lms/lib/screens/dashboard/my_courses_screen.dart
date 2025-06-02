import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../providers/course_provider/course_provider.dart';

// Import widgets
import 'widgets/login_prompt_view.dart';
import 'widgets/error_view.dart';
import 'widgets/empty_courses_view.dart';
import 'widgets/courses_list.dart';

// Import utilities
import 'utils/course_data_helper.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load courses after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchEnrolledCourses();
    });
  }

  void _setLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }

  void _setError(String message) {
    if (mounted) {
      setState(() {
        _hasError = true;
        _errorMessage = message;
      });
    }
  }

  void _clearError() {
    if (mounted) {
      setState(() {
        _hasError = false;
        _errorMessage = null;
      });
    }
  }

  Future<void> _fetchEnrolledCourses() async {
    await CourseDataHelper.fetchEnrolledCourses(
      context,
      _setLoading,
      _setError,
      _clearError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    final theme = Theme.of(context);

    if (authProvider.currentUser == null) {
      return const LoginPromptView();
    }

    // Get enrolled courses from the provider - these should ONLY be purchased courses
    final enrolledCourses = courseProvider.myCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchEnrolledCourses,
            tooltip: 'Refresh courses',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withAlpha(13),
              Colors.white,
            ],
          ),
        ),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: _fetchEnrolledCourses,
                  child:
                      _hasError
                          ? ErrorView(
                              errorMessage: _errorMessage,
                              onRetry: _fetchEnrolledCourses,
                            )
                          : enrolledCourses.isEmpty
                          ? const EmptyCoursesView()
                          : CoursesList(
                              courses: enrolledCourses,
                              onCourseOpened: _fetchEnrolledCourses,
                            ),
                ),
      ),
    );
  }
}
