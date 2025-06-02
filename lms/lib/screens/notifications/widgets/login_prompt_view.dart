import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../../auth/login_screen.dart';

/// Widget that prompts the user to log in to view notifications
class LoginPromptView extends StatelessWidget {
  const LoginPromptView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Please login to view your notifications'),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Login',
            width: 120,
            fullWidth: false,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
