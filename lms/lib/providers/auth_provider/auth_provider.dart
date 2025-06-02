import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/user/user.dart';
import '../../services/auth_service/auth_service.dart';
import 'auth_methods.dart';
import 'profile_methods.dart';

/// Main authentication provider that manages user state and authentication operations
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  late final AuthMethods _authMethods;
  late final ProfileMethods _profileMethods;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider() {
    _authMethods = AuthMethods(_authService);
    _profileMethods = ProfileMethods(_authService);
  }

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // Initialize auth state
  Future<void> initializeAuth() async {
    _setLoading(true);
    try {
      final user = await _authMethods.initializeAuth();
      _currentUser = user;
    } catch (e) {
      _currentUser = null;
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Authentication Methods

  // Register a new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String role = AppConstants.roleStudent, // Default to student role
  }) async {
    _setLoading(true);
    try {
      final response = await _authMethods.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      _setError(null);
      return response; // Return the full response
    } catch (e) {
      _setError(e.toString());
      rethrow; // Rethrow to handle in UI
    } finally {
      _setLoading(false);
    }
  }

  // Direct registration (bypasses email verification)
  Future<bool> registerDirectly({
    required String name,
    required String email,
    required String password,
    String role = AppConstants.roleStudent, // Default to student role
  }) async {
    _setLoading(true);
    try {
      final user = await _authMethods.registerDirectly(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      _currentUser = user;
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Activate user account
  Future<bool> activateUser({
    required String activationToken,
    required String activationCode,
  }) async {
    _setLoading(true);
    try {
      await _authMethods.activateUser(
        activationToken: activationToken,
        activationCode: activationCode,
      );

      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login user
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      final user = await _authMethods.login(email: email, password: password);

      _currentUser = user;
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authMethods.logout();
      _currentUser = null;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Profile Management Methods

  // Update user info
  Future<bool> updateUserInfo({
    required String name,
    required String email,
    String? avatar,
  }) async {
    _setLoading(true);
    try {
      final user = await _profileMethods.updateUserInfo(
        name: name,
        email: email,
        avatar: avatar,
      );

      _currentUser = user;
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user password
  Future<bool> updateUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    try {
      await _profileMethods.updateUserPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user avatar
  Future<bool> updateUserAvatar(String avatarUrl) async {
    _setLoading(true);
    try {
      final user = await _profileMethods.updateUserAvatar(avatarUrl);

      _currentUser = user;
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh current user data
  Future<void> refreshCurrentUser() async {
    if (_currentUser == null) return;

    _setLoading(true);
    try {
      final user = await _profileMethods.getUserProfile();
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
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
