import 'dart:io';
import 'package:dio/dio.dart';
import '../../constants/api_endpoints.dart';

import 'api_cookie_manager.dart';
import 'api_error_handler.dart';
import 'api_interceptors.dart';
import 'api_request_methods.dart';

/// Main API service class that handles communication with the backend
class ApiService {
  static ApiService? _instance;
  final Dio _dio;
  final ApiCookieManager _cookieManager;
  final ApiErrorHandler _errorHandler;
  late ApiInterceptors _interceptors;
  late ApiRequestMethods _requestMethods;
  bool _isInitialized = false;

  /// Get singleton instance
  factory ApiService() => _instance ??= ApiService._internal();

  ApiService._internal()
    : _dio = Dio(
        BaseOptions(
          // Use the same base URL from ApiEndpoints class to ensure consistency
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          validateStatus: (status) {
            // Consider all status codes as valid to handle them properly
            return true;
          },
        ),
      ),
      _cookieManager = ApiCookieManager(),
      _errorHandler = ApiErrorHandler() {
    // Async initialization will be done on first request
    _ensureInitialized();
  }

  void _setupBasicComponents() {
    if (!_cookieManager.isInitialized) {
      throw Exception(
        'Cookie manager must be initialized before setting up components',
      );
    }

    // Create interceptors
    _interceptors = ApiInterceptors(
      dio: _dio,
      cookieJar: _cookieManager.cookieJar,
    );

    // Setup request methods
    _requestMethods = ApiRequestMethods(dio: _dio, errorHandler: _errorHandler);

    // Setup interceptors
    _interceptors.setupInterceptors();

    // Add cookie manager to Dio
    _cookieManager.addCookieManager(_dio);
  }

  /// Ensures the service is fully initialized before use
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeComponents();
      _isInitialized = true;
    }
  }

  /// Initialize all components that require async operations
  Future<void> _initializeComponents() async {
    try {
      // Initialize cookie jar
      await _cookieManager.initCookieJar();

      // Now that cookie jar is initialized, setup components that depend on it
      _setupBasicComponents();

      print('🚀 API Service initialized successfully');
    } catch (e) {
      print('❌ Error initializing API Service: $e');
      rethrow;
    }
  }

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    await _ensureInitialized();
    return _requestMethods.get(endpoint, queryParameters: queryParameters);
  }

  /// POST request
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _ensureInitialized();
    return _requestMethods.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// PUT request
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _ensureInitialized();
    return _requestMethods.put(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// DELETE request
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _ensureInitialized();
    return _requestMethods.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// PATCH request
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _ensureInitialized();
    return _requestMethods.patch(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// Upload file
  Future<dynamic> uploadFile(
    String path,
    File file, {
    String paramName = 'file',
    Map<String, dynamic>? data,
  }) async {
    await _ensureInitialized();
    return _requestMethods.uploadFile(
      path,
      file,
      paramName: paramName,
      data: data,
    );
  }
}
