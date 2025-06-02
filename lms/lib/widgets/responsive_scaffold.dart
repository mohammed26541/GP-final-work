import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// A responsive scaffold that adapts to different screen sizes
class ResponsiveScaffold extends StatelessWidget {
  /// The app bar to display at the top of the scaffold
  final PreferredSizeWidget? appBar;

  /// The primary content of the scaffold
  final Widget body;

  /// A button displayed floating above the body of the scaffold
  final Widget? floatingActionButton;

  /// The position of the floating action button
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// The bottom navigation bar to display at the bottom of the scaffold
  final Widget? bottomNavigationBar;

  /// The drawer to display to the left of the body
  final Widget? drawer;

  /// Whether to center the body content
  final bool centerContent;

  /// Whether to apply horizontal padding to the body content
  final bool applyHorizontalPadding;

  /// Additional padding to apply to the body content
  final EdgeInsets? padding;

  /// Background color for the scaffold
  final Color? backgroundColor;

  /// Maximum width constraint for the body content (for large screens)
  final double? maxWidth;

  /// Creates a responsive scaffold
  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.centerContent = false,
    this.applyHorizontalPadding = true,
    this.padding,
    this.backgroundColor,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(child: _buildResponsiveBody(context)),
    );
  }

  Widget _buildResponsiveBody(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);
    final isLargeScreen = deviceType == DeviceType.desktop;

    Widget contentWidget = body;

    // Apply horizontal padding if needed
    if (applyHorizontalPadding) {
      final horizontalPadding = ResponsiveHelper.getHorizontalPadding(context);
      contentWidget = Padding(
        padding: padding ?? horizontalPadding,
        child: contentWidget,
      );
    } else if (padding != null) {
      contentWidget = Padding(padding: padding!, child: contentWidget);
    }

    // Center content if requested or on large screens
    if (centerContent || isLargeScreen) {
      contentWidget = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
          child: contentWidget,
        ),
      );
    }

    return contentWidget;
  }
}

/// A responsive app bar that adapts to different screen sizes
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title widget
  final Widget? title;

  /// Title text
  final String? titleText;

  /// Leading widget
  final Widget? leading;

  /// Action widgets displayed at the end of the app bar
  final List<Widget>? actions;

  /// Whether the title should be centered
  final bool centerTitle;

  /// Background color for the app bar
  final Color? backgroundColor;

  /// Elevation of the app bar
  final double? elevation;

  /// Bottom widget of the app bar
  final PreferredSizeWidget? bottom;

  /// Whether to automatically add back button
  final bool automaticallyImplyLeading;

  /// Creates a responsive app bar
  const ResponsiveAppBar({
    super.key,
    this.title,
    this.titleText,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation,
    this.bottom,
    this.automaticallyImplyLeading = true,
  }) : assert(
         title == null || titleText == null,
         'Cannot provide both title and titleText',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceType = ResponsiveHelper.getDeviceType(context);

    // Determine title widget
    Widget? titleWidget;
    if (title != null) {
      titleWidget = title;
    } else if (titleText != null) {
      titleWidget = Text(
        titleText!,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // Determine if title should be centered based on device type
    final shouldCenterTitle = centerTitle || deviceType == DeviceType.mobile;

    // Build app bar
    return AppBar(
      title: titleWidget,
      centerTitle: shouldCenterTitle,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 2,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
