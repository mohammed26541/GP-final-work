import 'package:flutter/material.dart';
import '../../models/course/course.dart';
import '../../models/order/order.dart';
import 'payment_first_checkout_screen.dart';

/// Legacy checkout screen that redirects to the new payment flow
class CheckoutScreen extends StatefulWidget {
  final Course course;
  final Order order;
  final bool skipServerOrderCreation;

  const CheckoutScreen({
    super.key,
    required this.course,
    required this.order,
    this.skipServerOrderCreation = false,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    // Redirect to new screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => PaymentFirstCheckoutScreen(course: widget.course),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
