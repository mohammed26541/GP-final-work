import 'package:flutter/material.dart';

/// Helper class for responsive UI design
class ResponsiveHelper {
  /// Screen width breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if current screen size is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen size is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if current screen size is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Get the current device type
  static DeviceType getDeviceType(BuildContext context) {
    if (isDesktop(context)) return DeviceType.desktop;
    if (isTablet(context)) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  /// Get horizontal padding based on screen size
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 6);
    }
  }

  /// Get responsive value based on screen size
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Build a responsive layout with different widgets for different screen sizes
  static Widget responsiveBuilder(
    BuildContext context, {
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Get number of grid columns based on screen width
  static int getResponsiveGridCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= desktopBreakpoint) {
      return 4; // Large desktop
    } else if (width >= tabletBreakpoint) {
      return 3; // Small desktop / large tablet
    } else if (width >= mobileBreakpoint) {
      return 2; // Tablet / large mobile
    } else {
      return 1; // Mobile
    }
  }

  /// Get responsive font size based on screen width
  static double getResponsiveFontSize(
    BuildContext context, {
    required double baseFontSize,
    double? minFontSize,
    double? maxFontSize,
  }) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width / tabletBreakpoint;

    final responsiveFontSize = baseFontSize * scaleFactor;

    if (minFontSize != null && responsiveFontSize < minFontSize) {
      return minFontSize;
    } else if (maxFontSize != null && responsiveFontSize > maxFontSize) {
      return maxFontSize;
    }

    return responsiveFontSize;
  }
}

/// Enum representing device types
enum DeviceType { mobile, tablet, desktop }
