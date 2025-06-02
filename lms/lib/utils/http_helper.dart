import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class HttpHelper {
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Set auth token for authenticated requests
  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  // Clear auth token
  void clearAuthToken() {
    _headers.remove('Authorization');
  }

  // GET request
  Future<http.Response> get(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(Duration(seconds: ApiConstants.timeout));

      return response;
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  // POST request
  Future<http.Response> post(String url, dynamic body) async {
    try {
      final response = await http
          .post(Uri.parse(url), headers: _headers, body: json.encode(body))
          .timeout(Duration(seconds: ApiConstants.timeout));

      return response;
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  // PUT request
  Future<http.Response> put(String url, dynamic body) async {
    try {
      final response = await http
          .put(Uri.parse(url), headers: _headers, body: json.encode(body))
          .timeout(Duration(seconds: ApiConstants.timeout));

      return response;
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  // DELETE request
  Future<http.Response> delete(String url) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: _headers)
          .timeout(Duration(seconds: ApiConstants.timeout));

      return response;
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  // PATCH request
  Future<http.Response> patch(String url, dynamic body) async {
    try {
      final response = await http
          .patch(Uri.parse(url), headers: _headers, body: json.encode(body))
          .timeout(Duration(seconds: ApiConstants.timeout));

      return response;
    } catch (e) {
      throw Exception('PATCH request failed: $e');
    }
  }
}
