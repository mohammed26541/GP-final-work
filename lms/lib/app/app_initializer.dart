import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../services/realtime_service/realtime_service.dart';

/// Handles application initialization tasks
class AppInitializer {
  /// Initialize all app services
  static Future<void> initialize() async {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment variables
    await _loadEnvironmentVariables();

    // Initialize payment services
    await _initializeStripe();
    
    // Initialize real-time service
    _initializeRealtimeService();
  }

  /// Load environment variables from .env file
  static Future<void> _loadEnvironmentVariables() async {
    try {
      await dotenv.load(fileName: '.env');
      print('Environment variables loaded successfully');
    } catch (e) {
      print('Failed to load environment variables: $e');
      // Continue the app even if environment variables fail to load
    }
  }

  /// Initialize Stripe payment service
  static Future<void> _initializeStripe() async {
    try {
      // Use a test publishable key directly to avoid initialization errors
      const publishableKey =
          'pk_test_51NQvTsGSWHxUQRJAXLb7u2C5OT8ixEiDzgXZZ1mBSOB4rUYJrPrJWxXyVUBQi9FjXkfkF1aNcn7UdAZYQ4rGI37G00T5KjOCpJ';
      Stripe.publishableKey = publishableKey;
      await Stripe.instance.applySettings();
      print('Stripe initialized successfully with key: $publishableKey');
    } catch (e) {
      print('Failed to initialize Stripe: $e');
      // Continue the app even if Stripe fails to initialize
    }
  }

  /// Initialize real-time service for live data updates
  static void _initializeRealtimeService() {
    try {
      // Create an instance of RealtimeService which will initialize itself
      // We don't need to store the reference as it's a singleton
      RealtimeService();
      print('🔄 Real-time service initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize real-time service: $e');
      // Continue the app even if real-time service fails to initialize
    }
  }
}
