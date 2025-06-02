import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../../models/user/user.dart';

/// Handles user data storage and retrieval from local storage
class UserStorage {
  /// Save authentication token to local storage
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
  }

  /// Save user data to local storage
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
  }

  /// Clear authentication data from local storage
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
  }

  /// Clear temporary password from local storage
  Future<void> clearTempPassword() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('temp_password');
  }

  /// Get current user from local storage
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(AppConstants.userKey);

    if (userString != null) {
      try {
        return User.fromJson(jsonDecode(userString));
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }

    return null;
  }

  /// Check if there is a valid token in local storage
  Future<bool> hasValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Get authentication token from local storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  /// Get temporary password from local storage
  Future<String?> getTempPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('temp_password');
  }
}
