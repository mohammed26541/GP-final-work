import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lms/constants/api_endpoints.dart';

class VdoCipherHelper {
  // Use actual IP address when testing on real device
  static const String baseUrl = ApiEndpoints.baseUrl;

  static Future<Map<String, dynamic>> getVdoCipherOTP(String videoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getVdoCipherOTP'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({'videoId': videoId}),
      );

      print('VdoCipher Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['otp'] != null && data['playbackInfo'] != null) {
          return {
            'otp': data['otp'],
            'playbackInfo': data['playbackInfo']
          };
        } else {
          throw Exception('Invalid VdoCipher response format');
        }
      } else {
        throw Exception('Failed to get VdoCipher OTP: ${response.statusCode}');
      }
    } catch (e) {
      print('VdoCipher Error: $e');
      throw Exception('Error getting VdoCipher OTP: $e');
    }
  }

  static Future<bool> isEmulator() async {
    if (!Platform.isAndroid) return false;
    
    try {
      // Common emulator indicators
      final model = await _getAndroidProperty('ro.product.model');
      final manufacturer = await _getAndroidProperty('ro.product.manufacturer');
      final brand = await _getAndroidProperty('ro.product.brand');
      final hardware = await _getAndroidProperty('ro.hardware');
      final fingerprint = await _getAndroidProperty('ro.build.fingerprint');

      return model.toLowerCase().contains('sdk') ||
             manufacturer.toLowerCase().contains('genymotion') ||
             brand.toLowerCase().contains('generic') ||
             hardware.toLowerCase().contains('goldfish') ||
             hardware.toLowerCase().contains('ranchu') ||
             fingerprint.toLowerCase().contains('generic') ||
             fingerprint.toLowerCase().contains('sdk') ||
             fingerprint.toLowerCase().contains('emulator');
    } catch (e) {
      // If we can't determine, assume it's not an emulator
      return false;
    }
  }

  static Future<String> _getAndroidProperty(String property) async {
    try {
      final result = await Process.run('getprop', [property]);
      return result.stdout.toString().trim();
    } catch (e) {
      return '';
    }
  }
}
