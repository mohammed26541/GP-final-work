import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// A custom card widget with Material 3 design
class CustomCard extends StatelessWidget {
  /// The child widget to display inside the card
  final Widget child;

  /// Padding to apply to the card content
  final EdgeInsets? padding;

  /// Margin to apply around the card
  final EdgeInsets? margin;

  /// Border radius of the card
  final BorderRadius? borderRadius;

  /// Elevation of the card
  final double elevation;

  /// Background color of the card
  final Color? color;

  /// Whether to add a hover effect to the card
  final bool enableHover;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Width of the card
  final double? width;

  /// Height of the card
  final double? height;

  /// Creates a custom card
  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation = 1,
    this.color,
    this.enableHover = true,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final deviceType = ResponsiveHelper.getDeviceType(context);

    // Determine default padding based on device type
    final defaultPadding = switch (deviceType) {
      DeviceType.desktop => const EdgeInsets.all(24),
      DeviceType.tablet => const EdgeInsets.all(20),
      DeviceType.mobile => const EdgeInsets.all(16),
    };

    // Determine default border radius based on device type
    final defaultBorderRadius = switch (deviceType) {
      DeviceType.desktop => BorderRadius.circular(16),
      DeviceType.tablet => BorderRadius.circular(16),
      DeviceType.mobile => BorderRadius.circular(12),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      margin: margin,
      child: Material(
        color: color ?? colorScheme.surface,
        elevation: elevation,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        borderRadius: borderRadius ?? defaultBorderRadius,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor:
              onTap != null
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
          highlightColor:
              onTap != null
                  ? colorScheme.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
          hoverColor:
              enableHover && onTap != null
                  ? colorScheme.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
          borderRadius: borderRadius ?? defaultBorderRadius,
          child: Padding(padding: padding ?? defaultPadding, child: child),
        ),
      ),
    );
  }
}

/// A custom card with a header, content, and optional footer
class CustomCardWithHeader extends StatelessWidget {
  /// The title of the card
  final String title;

  /// The subtitle of the card
  final String? subtitle;

  /// The leading widget in the header
  final Widget? leading;

  /// The trailing widget in the header
  final Widget? trailing;

  /// The content of the card
  final Widget content;

  /// The footer of the card
  final Widget? footer;

  /// Padding to apply to the card content
  final EdgeInsets? contentPadding;

  /// Padding to apply to the card header
  final EdgeInsets? headerPadding;

  /// Padding to apply to the card footer
  final EdgeInsets? footerPadding;

  /// Margin to apply around the card
  final EdgeInsets? margin;

  /// Border radius of the card
  final BorderRadius? borderRadius;

  /// Elevation of the card
  final double elevation;

  /// Background color of the card
  final Color? color;

  /// Whether to add a hover effect to the card
  final bool enableHover;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Creates a custom card with header
  const CustomCardWithHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.content,
    this.footer,
    this.contentPadding,
    this.headerPadding,
    this.footerPadding,
    this.margin,
    this.borderRadius,
    this.elevation = 1,
    this.color,
    this.enableHover = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final deviceType = ResponsiveHelper.getDeviceType(context);

    // Determine default padding based on device type
    final defaultPadding = switch (deviceType) {
      DeviceType.desktop => const EdgeInsets.all(16),
      DeviceType.tablet => const EdgeInsets.all(16),
      DeviceType.mobile => const EdgeInsets.all(12),
    };

    return CustomCard(
      padding: EdgeInsets.zero,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      color: color,
      enableHover: enableHover,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: headerPadding ?? defaultPadding,
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 16)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),

          // Content
          Padding(padding: contentPadding ?? defaultPadding, child: content),

          // Footer if provided
          if (footer != null) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            Padding(padding: footerPadding ?? defaultPadding, child: footer!),
          ],
        ],
      ),
    );
  }
}
