import 'package:flutter/material.dart';
import '../../models/course/course.dart';
import '../../models/course/course_content.dart';
import '../../services/course_service/course_service.dart';
import 'course_fetch_methods.dart';
import 'course_interaction_methods.dart';
import 'course_admin_methods.dart';
import 'course_helper_methods.dart';

/// Main course provider that manages course state and operations
class CourseProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  late final CourseFetchMethods _fetchMethods;
  late final CourseInteractionMethods _interactionMethods;
  late final CourseAdminMethods _adminMethods;
  late final CourseHelperMethods _helperMethods;

  List<Course> _courses = [];
  List<Course> _featuredCourses = [];
  List<Course> _recommendedCourses = [];
  List<Course> _myCourses = [];
  List<Course> _allCourses = [];
  List<Course> _coursesByCategory = [];
  Course? _selectedCourse;
  List<CourseContent> _courseContent = [];

  bool _isLoading = false;
  String? _error;

  CourseProvider() {
    _fetchMethods = CourseFetchMethods(_courseService);
    _interactionMethods = CourseInteractionMethods(_courseService);
    _adminMethods = CourseAdminMethods(_courseService);
    _helperMethods = CourseHelperMethods();
  }

  // Getters
  List<Course> get courses => _courses;
  List<Course> get featuredCourses => _featuredCourses;
  List<Course> get recommendedCourses => _recommendedCourses;
  List<Course> get myCourses => _myCourses;
  List<Course> get allCourses => _allCourses;
  List<Course> get coursesByCategory => _coursesByCategory;
  Course? get selectedCourse => _selectedCourse;
  List<CourseContent> get courseContent => _courseContent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all courses
  Future<List<Course>> fetchAllCourses({
    String? category,
    String? search,
    int page = 1,
    int limit = 10,
    String? sortBy,
  }) async {
    _setLoading(true);
    try {
      final courses = await _fetchMethods.fetchAllCourses(
        category: category,
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
      );

      _courses = courses;
      _allCourses = courses;
      _setError(null);
      return courses;
    } catch (e) {
      _setError(e.toString());
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Fetch courses by category
  Future<List<Course>> fetchCoursesByCategory(String categoryId) async {
    _setLoading(true);
    try {
      final courses = await _fetchMethods.fetchAllCourses(
        category: categoryId,
        limit: 100,
      );

      _coursesByCategory = courses;
      _setError(null);
      return courses;
    } catch (e) {
      _setError(e.toString());
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Sort courses by newest (most recently created)
  void sortByNewest() {
    _courses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _allCourses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _coursesByCategory.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  // Sort courses by rating (highest to lowest)
  void sortByRating() {
    _courses.sort((a, b) => b.rating.compareTo(a.rating));
    _allCourses.sort((a, b) => b.rating.compareTo(a.rating));
    _coursesByCategory.sort((a, b) => b.rating.compareTo(a.rating));
    notifyListeners();
  }

  // Sort courses by price (low to high)
  void sortByPriceLowToHigh() {
    _courses.sort((a, b) => a.price.compareTo(b.price));
    _allCourses.sort((a, b) => a.price.compareTo(b.price));
    _coursesByCategory.sort((a, b) => a.price.compareTo(b.price));
    notifyListeners();
  }

  // Sort courses by price (high to low)
  void sortByPriceHighToLow() {
    _courses.sort((a, b) => b.price.compareTo(a.price));
    _allCourses.sort((a, b) => b.price.compareTo(a.price));
    _coursesByCategory.sort((a, b) => b.price.compareTo(a.price));
    notifyListeners();
  }

  // Clear courses list
  void clearCourses() {
    _courses = [];
    notifyListeners();
  }

  // Fetch featured courses
  Future<void> fetchFeaturedCourses({int limit = 5}) async {
    _setLoading(true);
    try {
      final courses = await _fetchMethods.fetchFeaturedCourses(limit: limit);

      _featuredCourses = courses;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Fetch recommended courses
  Future<void> fetchRecommendedCourses({int limit = 5}) async {
    _setLoading(true);
    try {
      final courses = await _fetchMethods.fetchRecommendedCourses(limit: limit);

      _recommendedCourses = courses;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Fetch course by ID
  Future<void> fetchCourseById(String courseId) async {
    _setLoading(true);
    try {
      final course = await _fetchMethods.fetchCourseById(courseId);

      _selectedCourse = course;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Fetch course content
  Future<void> fetchCourseContent(String courseId) async {
    _setLoading(true);
    try {
      final content = await _fetchMethods.fetchCourseContent(courseId);
      _courseContent = content;
      _setError(null);
    } catch (e) {
      print('❌ Error fetching course content: $e');
      _setError('Failed to load course content: $e');
      // Don't clear _courseContent on error to preserve any previous content
    } finally {
      _setLoading(false);
    }
  }

  // Fetch my enrolled courses
  Future<void> fetchMyCourses() async {
    _setLoading(true);
    try {
      final courses = await _fetchMethods.fetchMyCourses();
      _myCourses = courses;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      print('❌ Error fetching my courses: $e');
      // Ensure _myCourses is not null even after an error
      _myCourses = [];
    } finally {
      _setLoading(false);
    }
  }

  // Add question to course
  Future<bool> addQuestion({
    required String courseId,
    required String contentId,
    required String question,
  }) async {
    _setLoading(true);
    try {
      final newQuestion = await _interactionMethods.addQuestion(
        courseId: courseId,
        contentId: contentId,
        question: question,
      );

      // Find the content item and update it with the new question
      final contentIndex = _courseContent.indexWhere(
        (content) => content.id == contentId,
      );

      if (contentIndex != -1) {
        final updatedContent = _interactionMethods.updateContentWithQuestion(
          _courseContent[contentIndex],
          newQuestion,
        );
        _courseContent[contentIndex] = updatedContent;
        notifyListeners();
      }

      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Add answer to question
  Future<bool> addAnswer({
    required String courseId,
    required String contentId,
    required String questionId,
    required String answer,
  }) async {
    _setLoading(true);
    try {
      final newAnswer = await _interactionMethods.addAnswer(
        courseId: courseId,
        contentId: contentId,
        questionId: questionId,
        answer: answer,
      );

      // Find the content item and update it with the new answer
      final contentIndex = _courseContent.indexWhere(
        (content) => content.id == contentId,
      );

      if (contentIndex != -1) {
        final updatedContent = _interactionMethods.updateContentWithAnswer(
          _courseContent[contentIndex],
          questionId,
          newAnswer,
        );
        _courseContent[contentIndex] = updatedContent;
        notifyListeners();
      }

      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Add review to course
  Future<bool> addReview({
    required String courseId,
    required String review,
    required double rating,
  }) async {
    try {
      final success = await _interactionMethods.addReview(
        courseId: courseId,
        review: review,
        rating: rating,
      );

      if (success) {
        // Refresh the selected course to include the new review
        await fetchCourseById(courseId);
        notifyListeners();
      }

      return success;
    } catch (e) {
      print('❌ Error adding review: $e');
      return false;
    }
  }

  // Generate video URL
  Future<String?> generateVideoUrl(String videoId) async {
    _setLoading(true);
    try {
      final url = await _fetchMethods.generateVideoUrl(videoId);

      _setError(null);
      return url;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Admin methods

  // Fetch admin courses
  Future<void> fetchAdminCourses() async {
    _setLoading(true);
    try {
      final courses = await _adminMethods.fetchAdminCourses();

      _myCourses = courses;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create course
  Future<bool> createCourse({
    required String name,
    required String description,
    required String thumbnail,
    required List<String> tags,
    required double price,
    double? discountedPrice,
    required int durationInWeeks,
    required List<Map<String, dynamic>> content,
  }) async {
    _setLoading(true);
    try {
      final course = await _adminMethods.createCourse(
        name: name,
        description: description,
        thumbnail: thumbnail,
        tags: tags,
        price: price,
        discountedPrice: discountedPrice,
        durationInWeeks: durationInWeeks,
        content: content,
      );

      // Add the new course to my courses
      _myCourses.add(course);

      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Edit course
  Future<bool> editCourse({
    required String courseId,
    String? name,
    String? description,
    String? thumbnail,
    List<String>? tags,
    double? price,
    double? discountedPrice,
    int? durationInWeeks,
    List<Map<String, dynamic>>? content,
  }) async {
    _setLoading(true);
    try {
      final course = await _adminMethods.editCourse(
        courseId: courseId,
        name: name,
        description: description,
        thumbnail: thumbnail,
        tags: tags,
        price: price,
        discountedPrice: discountedPrice,
        durationInWeeks: durationInWeeks,
        content: content,
      );

      // Update the course in myCourses
      _helperMethods.updateCourseInList(_myCourses, course);
      notifyListeners();

      // If this is the selected course, update it
      if (_selectedCourse?.id == courseId) {
        _selectedCourse = course;
      }

      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete course
  Future<bool> deleteCourse(String courseId) async {
    _setLoading(true);
    try {
      final success = await _adminMethods.deleteCourse(courseId);

      if (success) {
        // Remove the course from myCourses
        _myCourses.removeWhere((course) => course.id == courseId);

        // If this is the selected course, clear it
        if (_selectedCourse?.id == courseId) {
          _selectedCourse = null;
        }
      }

      _setError(null);
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Setter methods for testing and overriding
  void setFeaturedCourses(List<Course> courses) {
    _featuredCourses = courses;
    notifyListeners();
  }

  void setRecommendedCourses(List<Course> courses) {
    _recommendedCourses = courses;
    notifyListeners();
  }
  
  // Real-time update methods
  
  /// Add a new course to all relevant lists
  void addCourseToLists(Course course) {
    // Check if course already exists in any list
    if (_allCourses.any((c) => c.id == course.id)) {
      return; // Avoid duplicates
    }
    
    // Add to allCourses
    _allCourses.add(course);
    
    // Add to courses if it matches current filter criteria
    // This is a simplified approach - in a real app, you'd check against current filters
    _courses.add(course);
    
    // Add to featured courses if it's featured
    if (course.isFeatured) {
      _featuredCourses.add(course);
    }
    
    // Notify listeners of the change
    notifyListeners();
    print('✅ Added new course to lists: ${course.name}');
  }
  
  /// Update a course in all lists
  void updateCourseInLists(Course updatedCourse) {
    // Update in allCourses
    final allCoursesIndex = _allCourses.indexWhere((c) => c.id == updatedCourse.id);
    if (allCoursesIndex != -1) {
      _allCourses[allCoursesIndex] = updatedCourse;
    }
    
    // Update in courses
    final coursesIndex = _courses.indexWhere((c) => c.id == updatedCourse.id);
    if (coursesIndex != -1) {
      _courses[coursesIndex] = updatedCourse;
    }
    
    // Update in featuredCourses
    final featuredIndex = _featuredCourses.indexWhere((c) => c.id == updatedCourse.id);
    if (featuredIndex != -1) {
      if (updatedCourse.isFeatured) {
        _featuredCourses[featuredIndex] = updatedCourse;
      } else {
        // Remove from featured if no longer featured
        _featuredCourses.removeAt(featuredIndex);
      }
    } else if (updatedCourse.isFeatured) {
      // Add to featured if not there but now featured
      _featuredCourses.add(updatedCourse);
    }
    
    // Update in recommendedCourses
    final recommendedIndex = _recommendedCourses.indexWhere((c) => c.id == updatedCourse.id);
    if (recommendedIndex != -1) {
      _recommendedCourses[recommendedIndex] = updatedCourse;
    }
    
    // Update in coursesByCategory
    final categoryIndex = _coursesByCategory.indexWhere((c) => c.id == updatedCourse.id);
    if (categoryIndex != -1) {
      _coursesByCategory[categoryIndex] = updatedCourse;
    }
    
    // Update in myCourses
    final myCoursesIndex = _myCourses.indexWhere((c) => c.id == updatedCourse.id);
    if (myCoursesIndex != -1) {
      _myCourses[myCoursesIndex] = updatedCourse;
    }
    
    // Update selectedCourse if it's the same course
    if (_selectedCourse?.id == updatedCourse.id) {
      _selectedCourse = updatedCourse;
    }
    
    // Notify listeners of the change
    notifyListeners();
    print('✅ Updated course in lists: ${updatedCourse.name}');
  }
  
  /// Remove a course from all lists by ID
  void removeCourseFromLists(String courseId) {
    // Store course name for logging
    final courseName = _allCourses.firstWhere((c) => c.id == courseId, orElse: () => Course.empty()).name;
    
    // Remove from allCourses
    _allCourses.removeWhere((course) => course.id == courseId);
    
    // Remove from courses
    _courses.removeWhere((course) => course.id == courseId);
    
    // Remove from featuredCourses
    _featuredCourses.removeWhere((course) => course.id == courseId);
    
    // Remove from recommendedCourses
    _recommendedCourses.removeWhere((course) => course.id == courseId);
    
    // Remove from coursesByCategory
    _coursesByCategory.removeWhere((course) => course.id == courseId);
    
    // Remove from myCourses
    _myCourses.removeWhere((course) => course.id == courseId);
    
    // Clear selectedCourse if it's the same course
    if (_selectedCourse?.id == courseId) {
      _selectedCourse = null;
    }
    
    // Notify listeners of the change
    notifyListeners();
    print('✅ Removed course from lists: $courseName');
  }

  // Fallback method to set course content from the course object
  void setTempCourseContent(List<CourseContent> content) {
    print(
      '🔄 Setting temporary course content from course object: ${content.length} items',
    );
    _courseContent = content;
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool isLoading) {
    _helperMethods.setLoadingSafely(isLoading, _isLoading, () {
      _isLoading = isLoading;
      notifyListeners();
    });
  }

  void _setError(String? error) {
    _helperMethods.setErrorSafely(error, _error, () {
      _error = error;
      notifyListeners();
    });
  }

  // Set sample enrolled courses for debugging
  void setSampleMyCourses() {
    _myCourses = _helperMethods.getSampleEnrolledCourses();
    notifyListeners();
    print('✅ Set sample enrolled courses: ${_myCourses.length}');
  }

  // Verify access to a course
  Future<bool> verifyCourseAccess(String courseId) async {
    try {
      print('🔒 Provider checking course access for courseId: $courseId');

      // First check if the course is loaded in the provider
      if (_selectedCourse?.id == courseId) {
        print('✓ Course is already loaded in the provider');
      } else {
        // Need to fetch the course first
        print('⚙️ Course not loaded, fetching course details first');
        await fetchCourseById(courseId);

        if (_selectedCourse == null) {
          print('❌ Failed to fetch course with ID: $courseId');
          return false;
        }
      }

      // Use the fetch methods to verify access (this handles admin access too)
      final hasAccess = await _fetchMethods.verifyCourseAccess(courseId);

      print('🔒 Course access result from service: $hasAccess');
      return hasAccess;
    } catch (e) {
      print('❌ Error verifying course access in provider: $e');
      return false;
    }
  }
}
