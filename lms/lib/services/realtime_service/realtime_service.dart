import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/api_endpoints.dart';
import '../api_service/api_service.dart';

/// Service that handles real-time updates from the backend
class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  final ApiService _apiService = ApiService();

  // We're using polling only since WebSocket is not implemented in the backend

  // Stream controllers for different entity types
  final _courseStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _categoryStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _notificationStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _orderStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Polling fallback
  Timer? _pollingTimer;
  final Map<String, DateTime> _lastUpdateTimestamps = {};

  // Getters for streams
  Stream<Map<String, dynamic>> get courseStream =>
      _courseStreamController.stream;
  Stream<Map<String, dynamic>> get categoryStream =>
      _categoryStreamController.stream;
  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationStreamController.stream;
  Stream<Map<String, dynamic>> get orderStream => _orderStreamController.stream;

  factory RealtimeService() {
    return _instance;
  }

  RealtimeService._internal() {
    // Initialize the service
    _initialize();
  }

  void _initialize() {
    // Since WebSocket is not implemented in the backend,
    // we'll rely solely on polling for updates
    print('Initializing RealtimeService with polling mechanism only');
    _setupPolling();
  }

  /// Setup polling mechanism for real-time updates
  void _setupPolling() {
    // Cancel existing timer if any
    _pollingTimer?.cancel();

    // Start with an immediate poll
    _pollForUpdates();

    // Then set up periodic polling
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _pollForUpdates();
    });
    print('Polling mechanism activated for real-time updates');
  }

  /// Poll for updates from the server
  Future<void> _pollForUpdates() async {
    try {
      // Poll for course updates
      await _pollEntityUpdates('course');

      // Poll for category updates
      await _pollEntityUpdates('category');

      // Poll for notification updates
      await _pollEntityUpdates('notification');

      // Poll for order updates
      await _pollEntityUpdates('order');
    } catch (e) {
      print('Error polling for updates: $e');
    }
  }

  /// Poll for updates for a specific entity type
  Future<void> _pollEntityUpdates(String entityType) async {
    try {
      // Get the last update timestamp for this entity type
      final lastUpdate = _lastUpdateTimestamps[entityType] ?? DateTime(2000);

      // Construct the API endpoint based on entity type
      String endpoint;
      switch (entityType) {
        case 'course':
          // Use the proper API endpoint from ApiEndpoints
          endpoint = ApiEndpoints.getAllCourses;
          break;
        case 'category':
          // We don't have a specific endpoint for categories - this needs to be added
          // For now, we'll return early to avoid 404 errors
          print('Skipping category polling - endpoint not configured');
          return;
        case 'notification':
          endpoint = ApiEndpoints.getAllNotifications;
          break;
        case 'order':
          endpoint = ApiEndpoints.getAllOrders;
          break;
        default:
          print('Unknown entity type: $entityType');
          return;
      }

      // Add the timestamp query parameter - adjust parameter name to match your API
      final params = {
        'updatedSince': lastUpdate.toIso8601String(),
        // You might need to add other parameters required by your API
        'limit': '10',
        // 'sort': 'updatedAt',
      };

      print(
        'Polling for $entityType updates since ${lastUpdate.toIso8601String()}',
      );

      // Make the API request
      try {
        final response = await _apiService.get(
          endpoint,
          queryParameters: params,
        );

        if (response != null && response['success'] == true) {
          // Update the last timestamp for this entity type
          _lastUpdateTimestamps[entityType] = DateTime.now();

          // Extract data from response
          var items = [];
          if (response.containsKey('data')) {
            items = response['data'];
          }

          // Process the updates
          _processUpdates(entityType, items, lastUpdate);
        }
      } catch (e) {
        print('Error polling for $entityType updates: Exception: $e');
      }
    } catch (e) {
      print('Error polling for $entityType updates: $e');
    }
  }

  /// Process updates for a specific entity type
  void _processUpdates(String entityType, List items, DateTime lastUpdate) {
    if (items.isEmpty) return;

    print('Processing ${items.length} items for $entityType');

    for (final item in items) {
      // Default to 'update' if we can't determine
      String action = 'update';

      try {
        // Check for deletion marker
        if (item['deletedAt'] != null || item['isDeleted'] == true) {
          action = 'delete';
        } else if (item.containsKey('createdAt') &&
            item.containsKey('updatedAt')) {
          final DateTime? createdAt = _parseDateTime(item['createdAt']);
          final DateTime? updatedAt = _parseDateTime(item['updatedAt']);

          if (createdAt != null && updatedAt != null) {
            // If created and updated times are the same, it's a new item
            if (createdAt.isAtSameMomentAs(updatedAt)) {
              action = 'create';
            } else {
              action = 'update';
            }
          }
        }
      } catch (e) {
        print('Error determining action for item: $e');
        // Continue with default 'update' action
      }

      // Route update to appropriate stream
      switch (entityType) {
        case 'course':
          _courseStreamController.add({'action': action, 'payload': item});
          break;
        case 'category':
          _categoryStreamController.add({'action': action, 'payload': item});
          break;
        case 'notification':
          _notificationStreamController.add({
            'action': action,
            'payload': item,
          });
          break;
        case 'order':
          _orderStreamController.add({'action': action, 'payload': item});
          break;
      }
    }
  }

  /// Force an immediate poll for updates
  Future<void> forcePoll() async {
    await _pollForUpdates();
  }

  /// Clean up resources
  void dispose() {
    _pollingTimer?.cancel();
    _courseStreamController.close();
    _categoryStreamController.close();
    _notificationStreamController.close();
    _orderStreamController.close();
  }

  /// Helper method to parse different date formats
  DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return null;

    try {
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      } else if (dateValue is int) {
        // Handle timestamp in milliseconds
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
    } catch (e) {
      print('Error parsing date value: $e');
    }
    return null;
  }

  /// Check if the backend supports WebSockets
  Future<bool> checkWebSocketSupport() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/api/system/capabilities'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['websocketSupport'] == true;
      }
      return false;
    } catch (e) {
      print('Error checking WebSocket support: $e');
      return false;
    }
  }
}
