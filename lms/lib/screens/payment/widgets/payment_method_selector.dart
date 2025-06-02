import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

/// Widget for selecting payment methods
class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final Function(String?) onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        RadioListTile<String>(
          title: Row(
            children: [
              Image.asset(
                'assets/images/stripe.png',
                width: 40,
                height: 40,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.credit_card, size: 40),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Pay with Card', overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          value: 'stripe',
          groupValue: selectedMethod,
          onChanged: onMethodChanged,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color:
                  selectedMethod == 'stripe'
                      ? AppColors.primary
                      : Colors.grey[300]!,
            ),
          ),
        ),
      ],
    );
  }
}
