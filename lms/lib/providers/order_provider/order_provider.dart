import 'package:flutter/material.dart';
import '../../models/order/order.dart';
import '../../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<Order> _orders = [];
  Order? _currentOrder;
  Map<String, dynamic>? _paymentData;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  Map<String, dynamic>? get paymentData => _paymentData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all orders for user
  Future<void> fetchAllOrders() async {
    _setLoading(true);
    try {
      final orders = await _orderService.getAllOrders();

      _orders = orders;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create a new order
  Future<bool> createOrder({
    required String courseId,
    required String paymentMethod,
  }) async {
    _setLoading(true);
    try {
      final order = await _orderService.createOrder(
        courseId: courseId,
        paymentMethod: paymentMethod,
      );

      // The order is now explicitly in "pending" state until payment completes
      // Do not add it to the user's purchased courses list yet
      _currentOrder = order;

      // We'll only add this to _orders list once payment is completed
      // This ensures that "pending" orders don't appear as purchased courses

      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get Stripe publishable key
  Future<String?> getStripePublishableKey() async {
    _setLoading(true);
    try {
      final key = await _orderService.getStripePublishableKey();

      _setError(null);
      return key;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Create payment intent for Stripe
  Future<bool> createPayment({
    required String orderId,
    required double amount,
  }) async {
    _setLoading(true);
    try {
      final data = await _orderService.createPayment(
        orderId: orderId,
        amount: amount,
      );

      _paymentData = data;
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Process payment success
  Future<bool> processPaymentSuccess({
    required String orderId,
    required String paymentIntentId,
  }) async {
    _setLoading(true);
    try {
      final order = await _orderService.processPaymentSuccess(
        orderId: orderId,
        paymentIntentId: paymentIntentId,
      );

      // Update the order in the list or add it if not present
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = order;
      } else {
        // After successful payment, now we add the order to the list
        // This ensures only completed orders appear in user's purchased courses
        _orders.add(order);
      }

      // Update current order if needed
      if (_currentOrder?.id == orderId) {
        _currentOrder = order;
      }

      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cancel an order (used when payment fails)
  Future<bool> cancelOrder({required String orderId}) async {
    _setLoading(true);
    try {
      final success = await _orderService.cancelOrder(orderId: orderId);

      // Remove the canceled order from local state if successful
      if (success) {
        _orders.removeWhere((order) => order.id == orderId);
        if (_currentOrder?.id == orderId) {
          _currentOrder = null;
        }
      }

      _setError(null);
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Clear current order
  void clearCurrentOrder() {
    _currentOrder = null;
    _paymentData = null;
    notifyListeners();
  }

  // Set a temporary order without persisting to server
  // This is used for showing checkout UI before creating an order
  void setCurrentOrderWithoutPersisting(Order order) {
    _currentOrder = order;
    notifyListeners();
  }

  // Verify course enrollment after payment
  // This is used when the order update endpoint fails but the payment might have succeeded
  Future<bool> verifyCourseEnrollment({
    required String courseId,
    required String orderId,
  }) async {
    _setLoading(true);
    try {
      print('🔍 Verifying course enrollment after payment...');

      // Try to get order details (might fail if endpoint doesn't exist)
      try {
        final order = await _orderService.getOrderById(orderId);
        if (order.status == 'completed') {
          print('✅ Order verified as completed');
          return true;
        }
      } catch (e) {
        print('⚠️ Couldn\'t fetch order: $e');
      }

      // If that fails, check orders list to see if this one exists and is completed
      try {
        await fetchAllOrders(); // Refresh orders
        final existingOrder = _orders.firstWhere(
          (o) => o.id == orderId,
          orElse:
              () => _orders.firstWhere(
                (o) => o.courseId == courseId && o.status == 'completed',
                orElse:
                    () => _orders.firstWhere(
                      (o) => o.courseId == courseId,
                      orElse: () => throw Exception('Order not found'),
                    ),
              ),
        );

        if (existingOrder.status == 'completed') {
          print('✅ Order found in orders list and is completed');
          return true;
        }

        print('⚠️ Order found but status is: ${existingOrder.status}');
      } catch (e) {
        print('⚠️ Couldn\'t find order in orders list: $e');
      }

      print('❌ Could not verify course enrollment through orders');
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Create a direct payment intent without creating an order first
  Future<Map<String, dynamic>?> createDirectPaymentIntent({
    required int amount,
  }) async {
    _setLoading(true);
    try {
      final data = await _orderService.createDirectPaymentIntent(
        amount: amount,
      );

      _paymentData = data;
      _setError(null);
      return data;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Create a paid order (after payment is confirmed)
  Future<bool> createPaidOrder({
    required String courseId,
    required String paymentIntentId,
  }) async {
    _setLoading(true);
    try {
      // Create an order with the payment already completed
      final order = await _orderService.createPaidOrder(
        courseId: courseId,
        paymentIntentId: paymentIntentId,
      );

      // Save the order to local state
      _currentOrder = order;
      _orders.add(order);

      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
