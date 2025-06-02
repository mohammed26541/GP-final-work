import '../../constants/app_constants.dart';
import '../../models/user/user.dart';
import '../../services/auth_service/auth_service.dart';

/// Authentication methods for the AuthProvider
class AuthMethods {
  final AuthService _authService;

  AuthMethods(this._authService);

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String role = AppConstants.roleStudent,
  }) async {
    return await _authService.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }

  /// Direct registration (bypasses email verification)
  Future<User> registerDirectly({
    required String name,
    required String email,
    required String password,
    String role = AppConstants.roleStudent,
  }) async {
    return await _authService.registerDirectly(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }

  /// Activate user account
  Future<void> activateUser({
    required String activationToken,
    required String activationCode,
  }) async {
    await _authService.activateUser(
      activationToken: activationToken,
      activationCode: activationCode,
    );
  }

  /// Login user
  Future<User> login({required String email, required String password}) async {
    return await _authService.login(email: email, password: password);
  }

  /// Initialize auth state
  Future<User?> initializeAuth() async {
    return await _authService.loadUser();
  }

  /// Logout user
  Future<void> logout() async {
    await _authService.logout();
  }
}
