import '../../constants/api_endpoints.dart';
import '../../models/user/user.dart';
import '../api_service/api_service.dart';
import 'user_storage.dart';

/// Handles user profile operations like updating user info, avatar, and password
class UserProfileOperations {
  final ApiService _apiService;
  final UserStorage _userStorage;

  UserProfileOperations({
    required ApiService apiService,
    required UserStorage userStorage,
  }) : _apiService = apiService,
       _userStorage = userStorage;

  /// Update user information
  Future<User> updateUserInfo({
    required String name,
    required String email,
    String? avatar,
  }) async {
    try {
      final data = {'name': name, 'email': email};

      // Only add avatar to the request if it's provided
      if (avatar != null && avatar.isNotEmpty) {
        data['avatar'] = avatar;
      }

      final response = await _apiService.put(
        ApiEndpoints.updateUserInfo,
        data: data,
      );

      // Debug log to see what the response looks like
      print('Update user info response: $response');

      // Check if response has the expected format
      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (!response.containsKey('user')) {
        // Modified error handling based on actual response format
        final message =
            response['message'] ??
            'Update user info failed - invalid response format';
        throw Exception(message);
      }

      final user = User.fromJson(response['user']);
      await _userStorage.saveUser(user);

      return user;
    } catch (e) {
      print('Update user info error: $e');
      rethrow;
    }
  }

  /// Update user password
  Future<Map<String, dynamic>> updateUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // Verify that we have a valid token before attempting the request
      final isLoggedIn = await _userStorage.hasValidToken();
      if (!isLoggedIn) {
        throw Exception('No authentication token found. Please login again.');
      }

      final data = {'oldPassword': oldPassword, 'newPassword': newPassword};

      // Add debug logging
      print('Sending password update request with data: $data');
      print('Using authentication token');

      // Add a retry mechanism for token expiration
      try {
        final response = await _apiService.put(
          ApiEndpoints.updateUserPassword,
          data: data,
        );

        // Log response for debugging
        print('Update password response: $response');

        // Check if response has the expected format
        if (response is! Map<String, dynamic>) {
          throw Exception('Invalid response format');
        }

        // Check for specific error messages
        if (response.containsKey('message') && response['success'] == false) {
          throw Exception(response['message']);
        }

        return response;
      } catch (e) {
        // If the error is about authentication, try to refresh and retry once
        if (e.toString().contains('Please login to access this resource')) {
          print(
            'Authentication error detected, attempting to refresh token and retry...',
          );

          // Try to refresh the token first by calling loadUser() which should trigger a refresh
          final user = await _refreshUserSession();

          if (user != null) {
            // Retry the request with the new token
            final response = await _apiService.put(
              ApiEndpoints.updateUserPassword,
              data: data,
            );

            print('Retry update password response: $response');

            if (response is! Map<String, dynamic>) {
              throw Exception('Invalid response format');
            }

            if (response.containsKey('message') &&
                response['success'] == false) {
              throw Exception(response['message']);
            }

            return response;
          } else {
            throw Exception(
              'Failed to refresh authentication. Please login again.',
            );
          }
        } else {
          // For other errors, just rethrow
          rethrow;
        }
      }
    } catch (e) {
      print('Update user password error: $e');
      rethrow;
    }
  }

  /// Update user avatar
  Future<User> updateUserAvatar(String avatarUrl) async {
    try {
      final data = {'avatar': avatarUrl};

      final response = await _apiService.put(
        ApiEndpoints.updateUserAvatar,
        data: data,
      );

      // Debug log to see what the response looks like
      print('Update user avatar response: $response');

      // Check if response has the expected format
      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (!response.containsKey('user')) {
        // Modified error handling based on actual response format
        final message =
            response['message'] ??
            'Update user avatar failed - invalid response format';
        throw Exception(message);
      }

      final user = User.fromJson(response['user']);
      await _userStorage.saveUser(user);

      return user;
    } catch (e) {
      print('Update user avatar error: $e');
      rethrow;
    }
  }

  /// Get current user profile from server
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiService.get(ApiEndpoints.loadUser);

      // Debug log
      print('Get current user response: $response');

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (!response.containsKey('user')) {
        final message = response['message'] ?? 'Failed to get user profile';
        throw Exception(message);
      }

      final user = User.fromJson(response['user']);

      // Save updated user to storage
      await _userStorage.saveUser(user);

      return user;
    } catch (e) {
      print('❌ Error getting user profile: $e');
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Helper method to refresh user session
  Future<User?> _refreshUserSession() async {
    try {
      final response = await _apiService.get(ApiEndpoints.loadUser);

      if (response is! Map<String, dynamic> || !response.containsKey('user')) {
        return null;
      }

      final user = User.fromJson(response['user']);
      await _userStorage.saveUser(user);
      return user;
    } catch (e) {
      print('Failed to refresh user session: $e');
      return null;
    }
  }
}
