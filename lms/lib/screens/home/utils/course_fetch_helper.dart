import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/course_provider/course_provider.dart';

/// Helper class for fetching course data for the home screen
class CourseFetchHelper {
  /// Fetches featured and recommended courses for the home screen
  static Future<void> fetchHomeData(BuildContext context) async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    
    // Add more detailed error logging
    try {
      print('🔄 Fetching featured and recommended courses...');
      
      // Only fetch featured and recommended courses, not all courses
      await courseProvider.fetchFeaturedCourses(limit: 10);
      await courseProvider.fetchRecommendedCourses(limit: 10);
      
      // Clear the general courses list to ensure search results don't show by default
      courseProvider.clearCourses();
      
      print('✅ Featured courses: ${courseProvider.featuredCourses.length}');
      print('✅ Recommended courses: ${courseProvider.recommendedCourses.length}');
      
      // If the API isn't returning proper featured/recommended courses, use this fallback
      if (courseProvider.featuredCourses.isEmpty && courseProvider.recommendedCourses.isEmpty) {
        print('⚠️ No featured or recommended courses - fetching some courses as fallback');
        final tempCourses = await courseProvider.fetchAllCourses(limit: 10);
        
        if (tempCourses.isNotEmpty) {
          courseProvider.setFeaturedCourses(tempCourses);
          courseProvider.setRecommendedCourses(tempCourses);
          
          // Clear the general courses list again to ensure search results don't show
          courseProvider.clearCourses();
          
          print('✅ Set featured and recommended courses from fallback');
        }
      }
    } catch (e) {
      print('❌ Error fetching course data: $e');
    }
  }

  /// Searches for courses based on the provided query
  static Future<void> searchCourses(
    BuildContext context, 
    String query,
    Function setIsSearching,
    Function setHasSearched,
  ) async {
    if (query.isEmpty) {
      // If search field is empty, clear the search results
      setIsSearching(false);
      setHasSearched(false);
      
      // Clear the course list
      Provider.of<CourseProvider>(context, listen: false).clearCourses();
      return;
    }
    
    setIsSearching(true);
    setHasSearched(true); // Mark that a search has been performed
    
    try {
      await Provider.of<CourseProvider>(context, listen: false).fetchAllCourses(
        search: query,
      );
    } catch (e) {
      print('❌ Error searching courses: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching courses: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setIsSearching(false);
      }
    }
  }
}
