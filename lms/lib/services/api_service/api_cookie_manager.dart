import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

/// Manages cookie persistence for API requests
class ApiCookieManager {
  late PersistCookieJar _cookieJar;
  bool _isInitialized = false;

  /// Get the cookie jar instance
  PersistCookieJar get cookieJar => _cookieJar;
  
  /// Check if cookie manager is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the cookie jar
  Future<void> initCookieJar() async {
    if (_isInitialized) return;
    
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      _cookieJar = PersistCookieJar(
        persistSession: true,
        ignoreExpires: false,
        storage: FileStorage("$appDocPath/.cookies/"),
      );

      _isInitialized = true;
      print('🍪 Cookie manager initialized');
    } catch (e) {
      print('❌ Error initializing cookie jar: $e');
      // Create a fallback in-memory cookie jar that can be assigned to PersistCookieJar
      _cookieJar = PersistCookieJar();
      _isInitialized = true;
      print('🍪 Fallback cookie manager initialized');
    }
  }

  /// Add cookie manager to Dio instance
  void addCookieManager(Dio dio) {
    if (!_isInitialized) {
      throw Exception('Cookie manager not initialized');
    }
    
    dio.interceptors.add(CookieManager(_cookieJar));
    print('🍪 Cookie manager added to Dio instance');
  }
}
