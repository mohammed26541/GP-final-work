import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../models/course/course_content.dart';
import '../../../providers/course_provider/course_provider.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class VideoPlayerHelper {
  /// VdoCipher API key - Replace with your actual API key
  static const String apiKey =
      '1kMZfTLKhILDYHPeSKaquw06Z5etfTIGv6csAp7brOspYjDGDbVFO4nEwjRI8fvq';
  static const String apiEndpoint = 'https://dev.vdocipher.com/api/videos';

  /// Gets OTP and playbackInfo from VdoCipher API
  static Future<Map<String, dynamic>> getVdoCipherCredentials(
    String videoId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://dev.vdocipher.com/api/videos/$videoId/otp'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Apisecret $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'ttl': 300, // OTP valid for 5 minutes
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'otp': data['otp'], 'playbackInfo': data['playbackInfo']};
      } else {
        print('⚠️ Failed to get VdoCipher credentials: ${response.statusCode}');
        throw Exception('Failed to get video credentials');
      }
    } catch (e) {
      print('⚠️ Error getting VdoCipher credentials: $e');
      throw Exception('Error getting video credentials');
    }
  }

  /// Initializes a video player for the given course content
  static Future<Map<String, dynamic>> initializeVideoPlayer(
    BuildContext context,
    CourseProvider courseProvider,
    CourseContent content,
  ) async {
    if (content.videoUrl.isEmpty) {
      print('⚠️ Video URL is empty for content: ${content.id}');
      return {'videoPlayerController': null, 'embedInfo': null};
    }

    try {
      print('🎬 Initializing video player for: ${content.videoUrl}');

      // Extract video ID from the URL or content
      // Assuming content.videoUrl contains the VdoCipher video ID
      final videoId = content.videoUrl;

      // Get OTP and playbackInfo from VdoCipher API
      final credentials = await getVdoCipherCredentials(videoId);

      // Create EmbedInfo for VdoCipher player
      final embedInfo = EmbedInfo.streaming(
        otp: credentials['otp'],
        playbackInfo: credentials['playbackInfo'],
        embedInfoOptions: EmbedInfoOptions(autoplay: true),
      );

      return {
        'videoPlayerController': null, // Not needed for VdoCipher
        'embedInfo': embedInfo,
      };
    } catch (e) {
      print('⚠️ Error initializing video player: $e');
      return {'videoPlayerController': null, 'embedInfo': null};
    }
  }
}
