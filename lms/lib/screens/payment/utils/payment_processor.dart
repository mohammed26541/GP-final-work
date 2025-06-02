import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lms/screens/dashboard/my_courses_screen.dart';
import 'package:provider/provider.dart';
import '../../../providers/order_provider/order_provider.dart';

/// Helper class for processing payments
class PaymentProcessor {
  /// Create a payment intent directly without an order
  static Future<String?> createPaymentIntent(
    BuildContext context,
    double amount,
    Function(String) setPaymentIntentId,
  ) async {
    // Access the provider before the async gap
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    try {
      // Convert amount to cents
      final amountInCents = (amount * 100).toInt();

      // Use the createDirectPaymentIntent method
      final paymentData = await orderProvider.createDirectPaymentIntent(
        amount: amountInCents,
      );

      if (paymentData != null && paymentData.containsKey('client_secret')) {
        // Extract payment intent ID from client secret
        final clientSecret = paymentData['client_secret'] as String;
        final paymentIntentId = clientSecret.split('_secret_')[0];
        setPaymentIntentId(paymentIntentId);
        return clientSecret;
      }

      return null;
    } catch (e) {
      print('Error creating payment intent: $e');
      rethrow;
    }
  }

  /// Create order after successful payment
  static Future<bool> createOrderAfterPayment({
    required BuildContext context,
    required String courseId,
    required String paymentIntentId,
  }) async {
    // Access the provider before the async gap
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    try {
      // Create order with payment already completed
      final success = await orderProvider.createPaidOrder(
        courseId: courseId,
        paymentIntentId: paymentIntentId,
      );

      return success;
    } catch (e) {
      print('Error creating order after payment: $e');
      return false;
    }
  }

  /// Initialize and present the Stripe payment sheet
  static Future<void> processStripePayment({
    required BuildContext context,
    required String courseId,
    required double price,
    required Function setIsProcessing,
    required Function(String?) setError,
    required Function(String) setPaymentIntentId,
    required Function onSuccess,
  }) async {
    // Access the provider before any async operations
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    setIsProcessing(true);
    setError(null);

    try {
      // Get Stripe publishable key
      final publishableKey = await orderProvider.getStripePublishableKey();
      if (publishableKey == null) {
        throw Exception('Failed to get Stripe key');
      }

      // Set Stripe publishable key
      Stripe.publishableKey = publishableKey;

      // Check if widget is still mounted before proceeding
      if (!context.mounted) return;

      // Create payment intent DIRECTLY, without creating an order first
      final clientSecret = await createPaymentIntent(
        context,
        price, // Use the actual price to pay (original price)
        setPaymentIntentId,
      );

      if (clientSecret == null) {
        throw Exception('Failed to create payment intent');
      }

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'LMS Learning Platform',
          style: ThemeMode.light,
        ),
      );

      // Present payment sheet to collect payment details
      await Stripe.instance.presentPaymentSheet();

      print('✅ Payment successful! Now creating order...');

      // Check if widget is still mounted before proceeding
      if (!context.mounted) return;

      // After payment is successful, NOW create the order with payment info
      final success = await createOrderAfterPayment(
        context: context,
        courseId: courseId,
        paymentIntentId: clientSecret.split('_secret_')[0],
      );

      if (!success) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('DONE')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyCoursesScreen()),
    );
  }
  return;
}

      // Call the success callback
      onSuccess();
    } catch (e) {
      if (e is StripeException) {
        setError(e.error.localizedMessage);
      } else {
        setError(e.toString());
      }
    } finally {
      setIsProcessing(false);
    }
  }
}
