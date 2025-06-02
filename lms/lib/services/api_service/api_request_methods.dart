import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import './api_error_handler.dart';

/// Handles HTTP request methods for the API service
class ApiRequestMethods {
  final Dio dio;
  final ApiErrorHandler errorHandler;
  final int maxRetries = 3; // Maximum number of retry attempts

  ApiRequestMethods({required this.dio, required this.errorHandler});

  /// Performs a GET request with retry logic
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    int currentRetry = 0,
  }) async {
    try {
      print('📍 GET Request to: $endpoint');
      print('📍 Query Parameters: $queryParameters');

      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      print('📍 Response Status Code: ${response.statusCode}');

      // Only log data for successful responses to avoid huge logs
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        print('📍 Response Data: ${response.data}');
      }

      // Check if we have a successful response
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        // More detailed error handling
        print('❌ ERROR: Server returned status code ${response.statusCode}');
        print('❌ Error response: ${response.data}');

        if (response.statusCode == 404) {
          throw Exception('Resource not found: $endpoint');
        } else if (response.statusCode == 401) {
          throw Exception('Unauthorized access. Please login again.');
        } else {
          throw Exception(
            'API Error: ${response.statusCode} - ${response.data['message'] ?? 'Unknown error'}',
          );
        }
      }
    } on DioException catch (e) {
      print('❌ Dio ERROR: ${e.message}');
      print('❌ Dio ERROR Type: ${e.type}');

      // Retry logic for connection issues
      if (currentRetry < maxRetries &&
          (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError)) {
        // Exponential backoff: 1s, 2s, 4s, etc.
        final waitTime = Duration(milliseconds: 1000 * (1 << currentRetry));
        print(
          '🔄 Retrying request in ${waitTime.inMilliseconds}ms... (Attempt ${currentRetry + 1}/$maxRetries)',
        );

        await Future.delayed(waitTime);
        return get(
          endpoint,
          queryParameters: queryParameters,
          currentRetry: currentRetry + 1,
        );
      }

      if (e.response != null) {
        print('❌ Response Status: ${e.response?.statusCode}');
        print('❌ Response Data: ${e.response?.data}');
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Connection error. Please check if the server is running.',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('❌ Unexpected ERROR: $e');
      rethrow;
    }
  }

  /// Performs a POST request with retry logic
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int currentRetry = 0,
  }) async {
    try {
      // Ensure data is properly formatted
      dynamic processedData = data;
      if (data != null && data is! String && data is! FormData) {
        processedData = jsonEncode(data);
      }

      final response = await dio.post(
        path,
        data: processedData,
        queryParameters: queryParameters,
      );
      return errorHandler.handleResponse(response);
    } on DioException catch (e) {
      // Retry logic for connection issues
      if (currentRetry < maxRetries &&
          (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError)) {
        // Exponential backoff: 1s, 2s, 4s, etc.
        final waitTime = Duration(milliseconds: 1000 * (1 << currentRetry));
        print(
          '🔄 Retrying request in ${waitTime.inMilliseconds}ms... (Attempt ${currentRetry + 1}/$maxRetries)',
        );

        await Future.delayed(waitTime);
        return post(
          path,
          data: data,
          queryParameters: queryParameters,
          currentRetry: currentRetry + 1,
        );
      }

      return errorHandler.handleError(e);
    }
  }

  /// Performs a PUT request
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Ensure data is properly formatted
      dynamic processedData = data;
      if (data != null && data is! String && data is! FormData) {
        processedData = jsonEncode(data);
      }

      final response = await dio.put(
        path,
        data: processedData,
        queryParameters: queryParameters,
      );
      return errorHandler.handleResponse(response);
    } on DioException catch (e) {
      return errorHandler.handleError(e);
    }
  }

  /// Performs a DELETE request
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Ensure data is properly formatted
      dynamic processedData = data;
      if (data != null && data is! String && data is! FormData) {
        processedData = jsonEncode(data);
      }

      final response = await dio.delete(
        path,
        data: processedData,
        queryParameters: queryParameters,
      );
      return errorHandler.handleResponse(response);
    } on DioException catch (e) {
      return errorHandler.handleError(e);
    }
  }

  /// Performs a PATCH request
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Ensure data is properly formatted
      dynamic processedData = data;
      if (data != null && data is! String && data is! FormData) {
        processedData = jsonEncode(data);
      }

      final response = await dio.patch(
        path,
        data: processedData,
        queryParameters: queryParameters,
      );
      return errorHandler.handleResponse(response);
    } on DioException catch (e) {
      return errorHandler.handleError(e);
    }
  }

  /// Uploads a file to the server
  Future<dynamic> uploadFile(
    String path,
    File file, {
    String paramName = 'file',
    Map<String, dynamic>? data,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        paramName: await MultipartFile.fromFile(file.path),
        ...?data,
      });

      final response = await dio.post(path, data: formData);
      return errorHandler.handleResponse(response);
    } on DioException catch (e) {
      return errorHandler.handleError(e);
    }
  }
}
