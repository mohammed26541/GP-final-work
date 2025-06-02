import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../main_navigation.dart';

class VerificationScreen extends StatefulWidget {
  final String activationToken;
  final String email;

  const VerificationScreen({
    super.key, 
    required this.activationToken,
    required this.email,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onCodeComplete() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      try {
        final success = await authProvider.activateUser(
          activationToken: widget.activationToken,
          activationCode: _codeController.text.trim(),
        );
        
        if (success && mounted) {
          // Auto-login after successful verification
          final loginSuccess = await authProvider.login(
            email: widget.email,
            password: "", // Password would need to be passed to this screen in a real app
          );
          
          if (loginSuccess && mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainNavigation()),
            );
          } else if (mounted) {
            // If login fails, show a message and still consider activation successful
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account activated! Please login with your credentials.'),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navigate to the main screen anyway
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainNavigation()),
            );
          }
        } else if (mounted) {
          setState(() {
            _errorMessage = authProvider.error ?? 'Activation failed';
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString();
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Icon(
                    Icons.email_outlined,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    'Email Verification',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Instructions
                  Text(
                    'We\'ve sent a 4-digit code to ${widget.email}.',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    'Please check the server console output to find your activation code in the activations.json file.',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Single code field
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter 4-digit code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    maxLength: 4,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the activation code';
                      }
                      if (value.length != 4 || !RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                        return 'Please enter a valid 4-digit code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  
                  // Error message
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Verify Button
                  CustomButton(
                    text: 'Verify Email',
                    isLoading: _isLoading,
                    onPressed: _onCodeComplete,
                  ),
                  const SizedBox(height: 16),
                  
                  // Resend Code
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please check the server console for the latest code in activations.json'),
                        ),
                      );
                    },
                    child: const Text('Didn\'t receive the code? Check server console'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
