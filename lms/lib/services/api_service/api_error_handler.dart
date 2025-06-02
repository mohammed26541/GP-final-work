import 'package:dio/dio.dart';

/// Handles API errors and provides user-friendly error messages
class ApiErrorHandler {
  /// Handles API response and throws appropriate exceptions for error cases
  dynamic handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      // Check for authentication errors that need token refresh
      if (response.statusCode == 400 &&
          response.data is Map &&
          response.data['message'] == 'Please login to access this resource') {
        // Don't throw an exception here as it will be handled by the interceptor
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Authentication error',
        );
      }

      final errorMsg =
          response.data is Map
              ? response.data['message'] ??
                  'Server error: ${response.statusCode}'
              : 'Server error: ${response.statusCode}';

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: errorMsg,
      );
    }
  }

  /// Handles Dio exceptions and provides user-friendly error messages
  dynamic handleError(DioException e) {
    // Create a more user-friendly error message
    String errorMessage = 'An error occurred';

    if (e.response != null) {
      // Server responded with an error
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      print('Error Status: $statusCode');
      print('Error Data: $responseData');

      // Check for authentication errors that may need token refresh
      if (statusCode == 400 &&
          responseData is Map &&
          responseData['message'] == 'Please login to access this resource') {
        errorMessage = 'Authentication error: Session may have expired';
      } else if (responseData is Map) {
        // Try to extract error message from response
        errorMessage =
            responseData['message'] ??
            responseData['error'] ??
            'Server error: $statusCode';
      } else {
        errorMessage = 'Server error: $statusCode';
      }

      // Specific error handling based on status codes
      switch (statusCode) {
        case 400:
          if (responseData is Map &&
              responseData['message'] !=
                  'Please login to access this resource') {
            errorMessage =
                'Bad request: Please check your input data. $errorMessage';
          }
          break;
        case 401:
          errorMessage = 'Unauthorized: Please log in again';
          break;
        case 403:
          errorMessage =
              'Forbidden: You don\'t have permission to access this resource';
          break;
        case 404:
          errorMessage = 'Not found: The requested resource doesn\'t exist';
          break;
        case 422:
          errorMessage = 'Validation error: Please check your input data';
          break;
        case 500:
          errorMessage = 'Server error: Something went wrong on the server';
          break;
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage =
          'Connection timeout: The server took too long to respond. Please check your internet connection and try again.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      errorMessage =
          'Receive timeout: The server took too long to send data. Please try again later.';
    } else if (e.type == DioExceptionType.sendTimeout) {
      errorMessage =
          'Send timeout: It took too long to send data to the server. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage =
          'Connection error: Could not connect to the server. Please check:  \n1. Your internet connection  \n2. That the server is running  \n3. Server address is correct (10.0.2.2:8000)';
    } else {
      errorMessage = 'Network error: ${e.message}';
    }

    throw DioException(
      requestOptions: e.requestOptions,
      response: e.response,
      type: e.type,
      error: errorMessage,
    );
  }

  /// Provides a user-friendly suggestion for connection issues
  String getConnectionTroubleshootingTips() {
    return '''
    Connection Troubleshooting:
    
    1. Check that your device has internet access
    2. Ensure the server is running at the configured address
    3. If using an emulator, verify the server IP is set to 10.0.2.2
    4. For physical devices, ensure the server and device are on the same network
    5. Try restarting the app and the server
    ''';
  }
}
