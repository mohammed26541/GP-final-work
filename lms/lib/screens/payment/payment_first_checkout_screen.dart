import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course/course.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../providers/order_provider/order_provider.dart';
import '../../widgets/custom_button.dart';
import '../course/course_content_screen.dart';
import 'utils/payment_processor.dart';
import 'widgets/course_info_card.dart';
import 'widgets/error_message.dart';
import 'widgets/order_summary.dart';
import 'widgets/payment_method_selector.dart';

class PaymentFirstCheckoutScreen extends StatefulWidget {
  final Course course;

  const PaymentFirstCheckoutScreen({super.key, required this.course});

  @override
  State<PaymentFirstCheckoutScreen> createState() =>
      _PaymentFirstCheckoutScreenState();
}

class _PaymentFirstCheckoutScreenState
    extends State<PaymentFirstCheckoutScreen> {
  bool _isProcessing = false;
  String? _paymentMethod;
  String? _error;
  String? _paymentIntentId;
  bool _isCheckingPurchase = true;

  @override
  void initState() {
    super.initState();
    _paymentMethod = 'stripe';
    
    // Check purchase immediately after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfAlreadyPurchased();
    });
  }
  
  /// Check if the user has already purchased this course
  Future<void> _checkIfAlreadyPurchased() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      
      // If user is not logged in, return
      if (authProvider.currentUser == null) {
        return;
      }
      
      // Refresh user data to get latest courses
      await authProvider.refreshCurrentUser();
      
      final String userId = authProvider.currentUser!.id;
      final String courseId = widget.course.id;
      
      // Make sure orders are loaded
      if (orderProvider.orders.isEmpty) {
        _setIsProcessing(true);
        await orderProvider.fetchAllOrders();
        _setIsProcessing(false);
      }
      
      // Check if user is already enrolled in the course
      final bool isEnrolled = authProvider.currentUser!.courses.contains(courseId);
      
      // Check if user has a completed order for this course
      final bool hasCompletedOrder = orderProvider.orders.any(
        (order) => order.courseId == courseId && 
                 order.userId == userId && 
                 order.status == 'completed',
      );
      
      print('🔍 Purchase check - User: $userId, Course: $courseId, Enrolled: $isEnrolled, Has Order: $hasCompletedOrder');
      
      // If user has already purchased this course, navigate to content
      if (isEnrolled || hasCompletedOrder) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have already purchased this course'),
              backgroundColor: Colors.orange,
            ),
          );
          
          // Navigate to course content
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CourseContentScreen(
                courseId: courseId,
              ),
            ),
          );
        }
      } else {
        setState(() {
          _isCheckingPurchase = false;
        });
      }
    } catch (e) {
      print('❌ Error checking purchase: $e');
    }
  }

  /// Sets the payment intent ID
  void _setPaymentIntentId(String id) {
    _paymentIntentId = id;
  }

  /// Sets the processing state
  void _setIsProcessing(bool value) {
    if (mounted) {
      setState(() {
        _isProcessing = value;
      });
    }
  }

  /// Sets the error message
  void _setError(String? error) {
    if (mounted) {
      setState(() {
        _error = error;
      });
    }
  }

  /// Handles successful payment
  void _onPaymentSuccess() {
    if (mounted) {
      // Log the payment intent ID for tracking purposes
      print('Payment successful with intent ID: $_paymentIntentId');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Payment successful! You are now enrolled in the course.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to course content
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CourseContentScreen(courseId: widget.course.id),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If still checking purchase status, show loading
    if (_isCheckingPurchase) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Verifying purchase status...'),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing payment...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course info
                  CourseInfoCard(course: widget.course),
                  const SizedBox(height: 24),

                  // Order summary
                  OrderSummary(course: widget.course),
                  const SizedBox(height: 24),

                  // Payment method selection
                  PaymentMethodSelector(
                    selectedMethod: _paymentMethod!,
                    onMethodChanged: (value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Error message
                  if (_error != null) ErrorMessage(message: _error!),

                  // Complete purchase button
                  if (_isProcessing)
                    const Center(child: CircularProgressIndicator())
                  else
                    CustomButton(
                      text: 'Complete Purchase',
                      icon: Icons.payment,
                      onPressed: () {
                        setState(() {
                          _isProcessing = true;
                        });
                        
                        PaymentProcessor.processStripePayment(
                          context: context,
                          courseId: widget.course.id,
                          price: widget.course.price,
                          setIsProcessing: _setIsProcessing,
                          setError: _setError,
                          setPaymentIntentId: _setPaymentIntentId,
                          onSuccess: _onPaymentSuccess,
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
