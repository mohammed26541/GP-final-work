import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import '../constants/app_constants.dart';
import '../screens/splash_screen.dart';
import '../providers/theme_provider/theme_provider.dart';
import 'app_themes.dart' as app_themes;
import 'realtime_initializer.dart';

/// The main application widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize real-time update manager after providers are available
    RealtimeInitializer.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: AppConstants.navigatorKey,
          title: AppConstants.appName,
          theme: app_themes.AppThemes.lightTheme,
          darkTheme: app_themes.AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          // Add VdoCipher navigator observer for proper fullscreen handling
          navigatorObservers: [
            VdoPlayerController.navigatorObserver('/player/(.*)'),
          ],
          builder: (context, child) {
            // Apply responsive text scaling
            final mediaQueryData = MediaQuery.of(context);
            final scale = mediaQueryData.textScaler.scale(1.0).clamp(0.8, 1.2);

            return MediaQuery(
              data: mediaQueryData.copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            );
          },
        );
      },
    );
  }
}
