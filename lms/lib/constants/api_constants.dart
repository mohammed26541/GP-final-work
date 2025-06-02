class ApiConstants {
  static const String baseUrl = 'http://192.168.0.103:8000/api/v1';
  //static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
  static const int timeout = 30;

  // Auth endpoints
  static const String register = '$baseUrl/registration';
  static const String activateUser = '$baseUrl/activate-user';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String loadUser = '$baseUrl/me';
  static const String socialAuth = '$baseUrl/social-auth';
  static const String updateUserInfo = '$baseUrl/update-user-info';
  static const String updateUserPassword = '$baseUrl/update-user-password';
  static const String updateUserAvatar = '$baseUrl/update-user-avatar';
  static const String getAllUsers = '$baseUrl/get-users';
  static const String updateUserRole = '$baseUrl/update-user';
  static const String deleteUser = '$baseUrl/delete-user';

  // Course endpoints
  static const String createCourse = '$baseUrl/create-course';
  static const String editCourse = '$baseUrl/edit-course';
  static const String getCourse = '$baseUrl/get-course';
  static const String getAllCourses = '$baseUrl/get-courses';
  // Using the same endpoint for enrolled courses but with different parameters
  static const String getEnrolledCourses = '$baseUrl/get-courses';

  static const String getAdminCourses = '$baseUrl/get-admin-courses';
  static const String getCourseContent = '$baseUrl/get-course-content';
  static const String addQuestion = '$baseUrl/add-question';
  static const String addAnswer = '$baseUrl/add-answer';
  static String addReview(String courseId) => '$baseUrl/add-review/$courseId';
  static const String addReply = '$baseUrl/add-reply';
  static const String generateVideoUrl = '$baseUrl/getVdoCipherOTP';
  static const String deleteCourse = '$baseUrl/delete-course';

  //Order endpoints
  static const String createOrder = '$baseUrl/create-order';
  static const String getAllOrders = '$baseUrl/get-orders';
  static const String stripePublishableKey =
      '$baseUrl/payment/stripepublishablekey';
  static const String createPayment = '$baseUrl/payment';

  //Notification endpoints
  static const String getAllNotifications =
      '$baseUrl/get-all-notifications'; // only admin
  // Define a function to create the update notification URL with the ID instead of a static constant
  static String getUpdateNotificationUrl(String notificationId) =>
      '$baseUrl/update-notification/$notificationId';

  // Email endpoints
  static const String sendEmail = '$baseUrl/send-email';
  static const String testEmailConfig = '$baseUrl/test-email-config';

  // Layout endpoints
  static const String createLayout = '$baseUrl/create-layout';
  static const String editLayout = '$baseUrl/edit-layout';
  static const String getLayout = '$baseUrl/get-layout';

  // Analytics endpoints
  static const String getUsersAnalytics = '$baseUrl/get-users-analytics';
  static const String getOrdersAnalytics = '$baseUrl/get-orders-analytics';
  static const String getCoursesAnalytics = '$baseUrl/get-courses-analytics';
}