import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';

/// Handles API interceptors for request/response processing and authentication
class ApiInterceptors {
  final Dio dio;
  final PersistCookieJar cookieJar;
  bool isRefreshing = false; // Flag to prevent multiple refresh attempts

  ApiInterceptors({required this.dio, required this.cookieJar});

  /// Setup all interceptors for the Dio instance
  void setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  /// Request interceptor
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);

    if (token != null && token.isNotEmpty) {
      // Ensure token is added to every request
      options.headers['Authorization'] = 'Bearer $token';
      print('📝 Adding authentication token to request: ${options.path}');
    } else {
      print(
        '⚠️ No authentication token available for request: ${options.path}',
      );
    }

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    // Log the request for debugging
    print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    print('Data: ${options.data}');
    print('Query Parameters: ${options.queryParameters}');

    return handler.next(options);
  }

  /// Response interceptor
  Future<void> _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // Log the response for debugging
    print(
      '⬅️ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    print('Response Data: ${response.data}');

    // Check for Set-Cookie header
    if (response.headers.map.containsKey('set-cookie')) {
      print('🍪 Received cookies from server');
    }

    // Check if token expired (status 400 with "Please login to access this resource" message)
    if (response.statusCode == 400 &&
        response.data is Map &&
        response.data['message'] == 'Please login to access this resource' &&
        !isRefreshing) {
      print('🔄 Token appears to be expired, attempting to refresh...');

      try {
        // Try to login again using stored credentials
        final refreshedRequest = await _attemptRelogin(response.requestOptions);

        if (refreshedRequest != null) {
          // Return response from refreshed request
          return handler.resolve(refreshedRequest);
        }
      } catch (e) {
        print('❌ Failed to refresh token: $e');
        await _handleUnauthorized();
      }
    }

    if (response.statusCode != null && response.statusCode! >= 400) {
      final error = DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Server error: ${response.statusCode}',
      );

      return handler.reject(error);
    }

    return handler.next(response);
  }

  /// Error interceptor
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Enhanced error handling
    print(
      '⚠️ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
    );
    print('Error Type: ${error.type}');
    print('Error Message: ${error.message}');
    print('Error Data: ${error.response?.data}');

    // Handle unauthorized errors
    if ((error.response?.statusCode == 401 ||
            (error.response?.statusCode == 400 &&
                error.response?.data is Map &&
                error.response?.data['message'] ==
                    'Please login to access this resource')) &&
        !isRefreshing) {
      print('🔄 Attempting to refresh session due to authorization error...');

      try {
        // Try to login again using stored credentials
        final refreshedRequest = await _attemptRelogin(error.requestOptions);

        if (refreshedRequest != null) {
          // Return response from refreshed request
          return handler.resolve(refreshedRequest);
        }
      } catch (e) {
        print('❌ Failed to refresh token: $e');
        await _handleUnauthorized();
      }
    }

    return handler.next(error);
  }

  /// Attempts to re-login using stored credentials
  Future<Response?> _attemptRelogin(RequestOptions requestOptions) async {
    isRefreshing = true;
    try {
      // Get stored credentials
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConstants.userKey);

      if (userJson == null) {
        print('❌ No stored user information found for re-login');
        return null;
      }

      // Extract email from stored user data
      final userData = jsonDecode(userJson);
      final email = userData['email'];

      // Get password from secure storage
      final tempPassword = prefs.getString('temp_password');

      if (email == null || tempPassword == null) {
        print('❌ Missing email or password for re-login');
        return null;
      }

      print('🔑 Attempting to re-login with stored credentials...');

      // Create a new Dio instance specifically for login
      final loginDio = Dio(
        BaseOptions(
          baseUrl: dio.options.baseUrl,
          connectTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      // Add cookie manager to the login request
      loginDio.interceptors.add(CookieManager(cookieJar));

      // Attempt to login again
      final loginData = {'email': email, 'password': tempPassword};

      final loginResponse = await loginDio.post(
        '/login', // Use relative path since baseUrl is set
        data: jsonEncode(loginData),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          followRedirects: true,
          validateStatus: (status) => true,
          receiveDataWhenStatusError: true,
        ),
      );

      if (loginResponse.statusCode == 200 && loginResponse.data is Map) {
        print('✅ Re-login successful!');

        // Extract and save the new token
        String? newToken;
        if (loginResponse.data.containsKey('accessToken')) {
          newToken = loginResponse.data['accessToken'];
        }

        if (newToken != null && newToken.isNotEmpty) {
          // Save the new token
          await prefs.setString(AppConstants.tokenKey, newToken);

          // Wait a short moment to ensure cookies are saved
          await Future.delayed(Duration(milliseconds: 500));

          // Clone the original request with the new token
          final options = Options(
            method: requestOptions.method,
            headers: {
              ...requestOptions.headers,
              'Authorization': 'Bearer $newToken',
            },
            followRedirects: true,
            validateStatus: (status) => true,
            receiveDataWhenStatusError: true,
          );

          // Retry the original request with the new token
          print('🔄 Retrying original request with new token...');
          final response = await dio.request(
            requestOptions.path,
            options: options,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
          );

          return response;
        } else {
          print('❌ Could not extract new token from login response');
        }
      } else {
        print('❌ Re-login failed: ${loginResponse.statusCode}');
        print('❌ Error response: ${loginResponse.data}');
      }
    } catch (e) {
      print('❌ Error during re-login: $e');
    } finally {
      isRefreshing = false;
    }

    return null;
  }

  /// Handles unauthorized access by clearing tokens and cookies
  Future<void> _handleUnauthorized() async {
    // Clear stored tokens
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);

    // Clear cookies
    await cookieJar.deleteAll();

    // Notify that user needs to re-login (could use a global event bus or stream)
    print('User session expired. Needs to log in again.');
  }
}
