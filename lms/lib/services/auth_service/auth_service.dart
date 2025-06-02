import '../../../models/user/user.dart';
import '../../constants/app_constants.dart';
import '../api_service/api_service.dart';
import 'auth_operations.dart';
import 'user_profile_operations.dart';
import 'user_storage.dart';

/// Main authentication service class that handles user authentication and profile management
class AuthService {
  // Components
  final ApiService _apiService = ApiService();
  late final UserStorage _userStorage;
  late final AuthOperations _authOperations;
  late final UserProfileOperations _userProfileOperations;

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal() {
    _userStorage = UserStorage();
    _authOperations = AuthOperations(
      apiService: _apiService,
      userStorage: _userStorage,
    );
    _userProfileOperations = UserProfileOperations(
      apiService: _apiService,
      userStorage: _userStorage,
    );
  }

  // ======== Authentication Operations ========

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String role = AppConstants.roleStudent,
  }) async {
    return _authOperations.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }

  /// Direct registration (bypassing email verification)
  Future<User> registerDirectly({
    required String name,
    required String email,
    required String password,
    String role = AppConstants.roleStudent,
  }) async {
    return _authOperations.registerDirectly(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }

  /// Activate user account
  Future<Map<String, dynamic>> activateUser({
    required String activationToken,
    required String activationCode,
  }) async {
    return _authOperations.activateUser(
      activationToken: activationToken,
      activationCode: activationCode,
    );
  }

  /// User login
  Future<User> login({required String email, required String password}) async {
    return _authOperations.login(email: email, password: password);
  }

  /// Load current user from server
  Future<User?> loadUser() async {
    return _authOperations.loadUser();
  }

  /// Logout user
  Future<void> logout() async {
    return _authOperations.logout();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _authOperations.isLoggedIn();
  }

  // ======== User Profile Operations ========

  /// Update user information
  Future<User> updateUserInfo({
    required String name,
    required String email,
    String? avatar,
  }) async {
    return _userProfileOperations.updateUserInfo(
      name: name,
      email: email,
      avatar: avatar,
    );
  }

  /// Update user password
  Future<Map<String, dynamic>> updateUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return _userProfileOperations.updateUserPassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  /// Update user avatar
  Future<User> updateUserAvatar(String avatarUrl) async {
    return _userProfileOperations.updateUserAvatar(avatarUrl);
  }

  /// Get current user profile
  Future<User> getCurrentUser() async {
    return await _userProfileOperations.getCurrentUser();
  }

  // ======== User Storage Operations ========

  /// Get current user from local storage
  Future<User?> getCurrentUserFromStorage() async {
    return _userStorage.getCurrentUser();
  }
}
