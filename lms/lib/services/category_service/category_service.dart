import 'dart:convert';
import '../../models/category/category.dart';
import '../../constants/api_constants.dart';
import '../../utils/http_helper.dart';

class CategoryService {
  final HttpHelper _httpHelper = HttpHelper();

  // Fetch all categories
  Future<List<Category>> fetchAllCategories() async {
    try {
      final response = await _httpHelper.get(
        '${ApiConstants.baseUrl}/categories',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, return mock data if API call fails
      return _getMockCategories();
    }
  }

  // Fetch category by ID
  Future<Category> fetchCategoryById(String categoryId) async {
    try {
      final response = await _httpHelper.get(
        '${ApiConstants.baseUrl}/categories/$categoryId',
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body)['data'];
        return Category.fromJson(data);
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, return a mock category if API call fails
      return _getMockCategories().firstWhere(
        (category) => category.id == categoryId,
        orElse: () => _getMockCategories().first,
      );
    }
  }

  // Mock data for development and testing
  List<Category> _getMockCategories() {
    return [
      Category(
        id: '1',
        name: 'Web Development',
        description:
            'Learn web development with HTML, CSS, JavaScript, and more',
        courseCount: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Category(
        id: '2',
        name: 'Mobile Development',
        description: 'Build mobile apps for iOS and Android',
        courseCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Category(
        id: '3',
        name: 'Data Science',
        description: 'Learn data analysis, machine learning, and AI',
        courseCount: 10,
        createdAt: DateTime.now().subtract(const Duration(days: 80)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Category(
        id: '4',
        name: 'Business',
        description: 'Develop business skills and entrepreneurship',
        courseCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 70)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Category(
        id: '5',
        name: 'Design',
        description: 'Learn graphic design, UI/UX, and more',
        courseCount: 9,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '6',
        name: 'Marketing',
        description: 'Master digital marketing and growth strategies',
        courseCount: 7,
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
