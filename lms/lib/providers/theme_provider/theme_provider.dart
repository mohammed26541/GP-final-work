import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider to manage theme mode (light/dark/system)
class ThemeProvider extends ChangeNotifier {
  // Default theme mode
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = true;

  // Storage key
  static const String _themeModeKey = 'theme_mode';

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if theme is being loaded
  bool get isLoading => _isLoading;

  /// Initialize provider
  ThemeProvider() {
    _loadThemeMode();
  }

  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt(_themeModeKey);

      if (themeModeIndex != null) {
        _themeMode = ThemeMode.values[themeModeIndex];
      }
    } catch (e) {
      // If there's an error, fall back to system theme
      _themeMode = ThemeMode.system;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set and save theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);
    } catch (e) {
      // Just log error, don't revert UI
      print('Error saving theme mode: $e');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await setThemeMode(newMode);
  }

  /// Check if current theme is dark
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
