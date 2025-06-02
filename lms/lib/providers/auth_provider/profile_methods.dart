import '../../models/user/user.dart';
import '../../services/auth_service/auth_service.dart';

/// Profile management methods for the AuthProvider
class ProfileMethods {
  final AuthService _authService;
  
  ProfileMethods(this._authService);
  
  /// Get current user profile
  Future<User> getUserProfile() async {
    return await _authService.getCurrentUser();
  }
  
  /// Update user info
  Future<User> updateUserInfo({
    required String name,
    required String email,
    String? avatar,
  }) async {
    return await _authService.updateUserInfo(
      name: name,
      email: email,
      avatar: avatar,
    );
  }
  
  /// Update user password
  Future<void> updateUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _authService.updateUserPassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
  
  /// Update user avatar
  Future<User> updateUserAvatar(String avatarUrl) async {
    return await _authService.updateUserAvatar(avatarUrl);
  }
}
