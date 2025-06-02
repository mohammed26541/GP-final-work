import 'api_service/api_service.dart';
import '../constants/api_endpoints.dart';

class EmailService {
  final ApiService _apiService = ApiService();
  
  // Singleton pattern
  static final EmailService _instance = EmailService._internal();
  factory EmailService() => _instance;
  
  EmailService._internal();
  
  // Send registration confirmation email
  Future<bool> sendRegistrationEmail({
    required String email,
    required String activationToken,
  }) async {
    try {
      // Log the details for debugging
      print('Attempting to send registration email to: $email');
      
      final data = {
        'email': email,
        'subject': 'Activate Your LMS Account',
        'emailType': 'ACTIVATION',
        'activationToken': activationToken,
      };
      
      // We'll call the backend endpoint that will handle the actual email sending
      // This way, we're not directly using SMTP which was causing authentication errors
      final response = await _apiService.post(ApiEndpoints.sendEmail, data: data);
      
      print('Email service response: $response');
      
      if (response is Map<String, dynamic> && response.containsKey('success')) {
        return response['success'] == true;
      }
      
      return false;
    } catch (e) {
      print('Error sending registration email: $e');
      // Instead of failing and throwing an exception, we'll return false
      // This way the registration can continue even if email fails
      return false;
    }
  }
  
  // Send password reset email
  Future<bool> sendPasswordResetEmail({
    required String email,
    required String resetToken,
  }) async {
    try {
      // Log the details for debugging
      print('Attempting to send password reset email to: $email');
      
      final data = {
        'email': email,
        'subject': 'Reset Your LMS Password',
        'emailType': 'PASSWORD_RESET',
        'resetToken': resetToken,
      };
      
      // Call the backend endpoint
      final response = await _apiService.post(ApiEndpoints.sendEmail, data: data);
      
      print('Email service response: $response');
      
      if (response is Map<String, dynamic> && response.containsKey('success')) {
        return response['success'] == true;
      }
      
      return false;
    } catch (e) {
      print('Error sending password reset email: $e');
      return false;
    }
  }
  
  // Send course enrollment confirmation
  Future<bool> sendEnrollmentConfirmation({
    required String email,
    required String courseName,
    required String orderNumber,
  }) async {
    try {
      // Log the details for debugging
      print('Attempting to send enrollment confirmation to: $email');
      
      final data = {
        'email': email,
        'subject': 'Enrollment Confirmation: $courseName',
        'emailType': 'ENROLLMENT',
        'courseName': courseName,
        'orderNumber': orderNumber,
      };
      
      // Call the backend endpoint
      final response = await _apiService.post(ApiEndpoints.sendEmail, data: data);
      
      print('Email service response: $response');
      
      if (response is Map<String, dynamic> && response.containsKey('success')) {
        return response['success'] == true;
      }
      
      return false;
    } catch (e) {
      print('Error sending enrollment confirmation: $e');
      return false;
    }
  }
  
  // Test email configuration
  Future<bool> testEmailConfiguration() async {
    try {
      print('Testing email configuration');
      
      final response = await _apiService.get(ApiEndpoints.testEmailConfig);
      
      print('Test email config response: $response');
      
      if (response is Map<String, dynamic> && response.containsKey('success')) {
        return response['success'] == true;
      }
      
      return false;
    } catch (e) {
      print('Error testing email configuration: $e');
      return false;
    }
  }
  
  // Generic email sending method
  Future<bool> sendEmail({
    required String email,
    required String subject,
    required String body,
    String? emailType = 'GENERIC',
  }) async {
    try {
      // Log the details for debugging
      print('Attempting to send email to: $email');
      
      final data = {
        'email': email,
        'subject': subject,
        'body': body,
        'emailType': emailType,
      };
      
      // Call the backend endpoint
      final response = await _apiService.post(ApiEndpoints.sendEmail, data: data);
      
      print('Email service response: $response');
      
      if (response is Map<String, dynamic> && response.containsKey('success')) {
        return response['success'] == true;
      }
      
      return false;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
