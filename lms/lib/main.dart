import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app_initializer.dart';
import 'app/app_providers.dart';
import 'app/app.dart';

/// Main entry point for the application
void main() async {
  // Initialize app services
  await AppInitializer.initialize();

  // Run the app
  runApp(const LmsApp());
}

/// Entry point wrapper for the LMS application
/// This separates provider setup from the main app widget
class LmsApp extends StatelessWidget {
  const LmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: const MyApp(),
    );
  }
}
