import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../providers/auth_provider/auth_provider.dart';
import '../providers/course_provider/course_provider.dart';
import '../providers/category_provider/category_provider.dart';
import '../providers/order_provider/order_provider.dart';
import '../providers/theme_provider/theme_provider.dart';
import '../providers/notification_provider/notification_provider.dart';

/// Configures the application providers
class AppProviders {
  /// Get the list of providers for the application
  static List<SingleChildWidget> get providers {
    return [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => CourseProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ];
  }
}
