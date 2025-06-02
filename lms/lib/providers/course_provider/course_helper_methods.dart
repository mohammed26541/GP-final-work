import '../../models/course/course.dart';
import 'package:flutter/material.dart';

/// Helper methods and sample data for CourseProvider
class CourseHelperMethods {
  /// Update a course in a list
  void updateCourseInList(List<Course> courseList, Course updatedCourse) {
    final index = courseList.indexWhere(
      (course) => course.id == updatedCourse.id,
    );

    if (index != -1) {
      courseList[index] = updatedCourse;
    }
  }

  /// Create sample enrolled courses for testing
  List<Course> getSampleEnrolledCourses() {
    final now = DateTime.now();

    return [
      Course(
        id: 'sample-course-1',
        name: 'Flutter Development Masterclass',
        description:
            'Learn to build beautiful mobile apps with Flutter and Dart.',
        thumbnail:
            'https://cdn.pixabay.com/photo/2022/02/19/22/49/app-development-7023953_1280.jpg',
        instructor: 'sample-instructor-1',
        instructorName: 'John Developer',
        tags: ['Flutter', 'Mobile Development', 'Dart'],
        price: 49.99,
        discountedPrice: 39.99,
        durationInWeeks: 8,
        content: [],
        reviews: [],
        rating: 4.7,
        totalStudents: 1250,
        isFeatured: true,
        isEnrolled: true,
        createdAt: now.subtract(const Duration(days: 120)),
      ),
      Course(
        id: 'sample-course-2',
        name: 'React for Beginners',
        description:
            'A comprehensive guide to building web applications with React.',
        thumbnail:
            'https://cdn.pixabay.com/photo/2018/06/08/00/48/developer-3461405_1280.png',
        instructor: 'sample-instructor-2',
        instructorName: 'Sarah Web',
        tags: ['React', 'JavaScript', 'Web Development'],
        price: 59.99,
        discountedPrice: 49.99,
        durationInWeeks: 6,
        content: [],
        reviews: [],
        rating: 4.8,
        totalStudents: 2340,
        isFeatured: true,
        isEnrolled: true,
        createdAt: now.subtract(const Duration(days: 90)),
      ),
      Course(
        id: 'sample-course-3',
        name: 'Python Data Science',
        description:
            'Master data analysis, visualization, and machine learning with Python.',
        thumbnail:
            'https://cdn.pixabay.com/photo/2020/01/26/20/14/computer-4795762_1280.jpg',
        instructor: 'sample-instructor-3',
        instructorName: 'Michael Data',
        tags: ['Python', 'Data Science', 'Machine Learning'],
        price: 69.99,
        discountedPrice: 59.99,
        durationInWeeks: 10,
        content: [],
        reviews: [],
        rating: 4.9,
        totalStudents: 3150,
        isFeatured: false,
        isEnrolled: true,
        createdAt: now.subtract(const Duration(days: 60)),
      ),
    ];
  }

  /// Helper method to safely set loading state with post-frame callback
  void setLoadingSafely(
    bool isLoading,
    bool currentIsLoading,
    Function notifyListeners,
  ) {
    if (currentIsLoading == isLoading) return; // Prevent unnecessary updates

    // Use post-frame callback to avoid build-time notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Helper method to safely set error state with post-frame callback
  void setErrorSafely(
    String? error,
    String? currentError,
    Function notifyListeners,
  ) {
    if (currentError == error) return; // Prevent unnecessary updates

    // Use post-frame callback to avoid build-time notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
