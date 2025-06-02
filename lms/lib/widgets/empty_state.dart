import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/responsive_helper.dart';
import 'animated_button.dart';

/// A widget to display when there is no data to show
class EmptyState extends StatelessWidget {
  /// The title to display
  final String title;

  /// The message to display
  final String message;

  /// The animation asset to display
  final String? animationAsset;

  /// The icon to display if no animation asset is provided
  final IconData icon;

  /// The action button text
  final String? actionButtonText;

  /// The callback when the action button is pressed
  final VoidCallback? onAction;

  /// The color of the icon
  final Color? iconColor;

  /// The size of the illustration
  final double? illustrationSize;

  /// Creates an empty state widget
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.animationAsset,
    this.icon = Icons.inbox_outlined,
    this.actionButtonText,
    this.onAction,
    this.iconColor,
    this.illustrationSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final deviceType = ResponsiveHelper.getDeviceType(context);
    final size = MediaQuery.of(context).size;

    // Determine size based on device type
    final defaultSize = switch (deviceType) {
      DeviceType.desktop => 240.0,
      DeviceType.tablet => 200.0,
      DeviceType.mobile => size.width * 0.4,
    };

    final illustrationSizeValue = illustrationSize ?? defaultSize;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation or icon
          if (animationAsset != null)
            _buildAnimationOrFallback(context)
          else
            Icon(
              icon,
              size: illustrationSizeValue * 0.7,
              color: iconColor ?? colorScheme.primary.withValues(alpha: 0.7),
            ),
          const SizedBox(height: 24),

          // Title
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Message
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          // Action button if available
          if (onAction != null && actionButtonText != null) ...[
            const SizedBox(height: 24),
            AnimatedButton(
              onPressed: onAction!,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Text(
                actionButtonText!,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnimationOrFallback(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 200,
      width: 200,
      child:
          animationAsset != null
              ? Lottie.asset(
                animationAsset!,
                errorBuilder: (context, error, stackTrace) {
                  // If animation file doesn't exist, show icon instead
                  return Icon(
                    icon,
                    size: 80,
                    color: iconColor ?? colorScheme.primary.withValues(alpha: 0.7),
                  );
                },
              )
              : Icon(
                icon,
                size: 80,
                color: iconColor ?? colorScheme.primary.withValues(alpha: 0.7),
              ),
    );
  }
}

/// A widget to display when content is loading
class LoadingState extends StatelessWidget {
  /// The message to display
  final String message;

  /// The animation asset to display
  final String? animationAsset;

  /// The size of the illustration
  final double? illustrationSize;

  /// Creates a loading state widget
  const LoadingState({
    super.key,
    this.message = 'Loading...',
    this.animationAsset,
    this.illustrationSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final deviceType = ResponsiveHelper.getDeviceType(context);
    final size = MediaQuery.of(context).size;

    // Determine size based on device type
    final defaultSize = switch (deviceType) {
      DeviceType.desktop => 200.0,
      DeviceType.tablet => 160.0,
      DeviceType.mobile => size.width * 0.35,
    };

    final illustrationSizeValue = illustrationSize ?? defaultSize;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation or Loading Indicator
          if (animationAsset != null)
            Lottie.asset(
              animationAsset!,
              width: illustrationSizeValue,
              height: illustrationSizeValue,
              repeat: true,
              fit: BoxFit.contain,
            )
          else
            SizedBox(
              width: illustrationSizeValue * 0.3,
              height: illustrationSizeValue * 0.3,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
          const SizedBox(height: 24),

          // Message
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// A widget to display when an error occurs
class ErrorState extends StatelessWidget {
  /// The title to display
  final String title;

  /// The message to display
  final String message;

  /// The animation asset to display
  final String? animationAsset;

  /// The retry button text
  final String retryButtonText;

  /// The callback when the retry button is pressed
  final VoidCallback? onRetry;

  /// The size of the illustration
  final double? illustrationSize;

  /// Creates an error state widget
  const ErrorState({
    super.key,
    this.title = 'Oops! Something went wrong',
    required this.message,
    this.animationAsset,
    this.retryButtonText = 'Retry',
    this.onRetry,
    this.illustrationSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final deviceType = ResponsiveHelper.getDeviceType(context);
    final size = MediaQuery.of(context).size;

    // Determine size based on device type
    final defaultSize = switch (deviceType) {
      DeviceType.desktop => 240.0,
      DeviceType.tablet => 200.0,
      DeviceType.mobile => size.width * 0.4,
    };

    final illustrationSizeValue = illustrationSize ?? defaultSize;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animation or Error Icon
            if (animationAsset != null)
              Lottie.asset(
                animationAsset!,
                width: illustrationSizeValue,
                height: illustrationSizeValue,
                repeat: true,
                fit: BoxFit.contain,
              )
            else
              Icon(
                Icons.error_outline,
                size: illustrationSizeValue * 0.7,
                color: colorScheme.error.withValues(alpha: 0.7),
              ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            // Retry Button
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              AnimatedButton(
                onPressed: onRetry!,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Text(
                  retryButtonText,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
