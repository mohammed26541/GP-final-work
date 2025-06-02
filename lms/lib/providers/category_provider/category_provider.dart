import 'package:flutter/material.dart';
import '../../models/category/category.dart';
import '../../services/category_service/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all categories
  Future<void> fetchAllCategories() async {
    _setLoading(true);
    try {
      final categories = await _categoryService.fetchAllCategories();
      _categories = categories;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Fetch category by ID
  Future<Category?> fetchCategoryById(String categoryId) async {
    _setLoading(true);
    try {
      final category = await _categoryService.fetchCategoryById(categoryId);
      _setError(null);
      return category;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
