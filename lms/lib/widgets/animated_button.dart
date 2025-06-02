import 'package:flutter/material.dart';

/// An animated button that provides visual feedback when pressed
class AnimatedButton extends StatefulWidget {
  /// The child widget to display inside the button
  final Widget child;

  /// The callback when the button is pressed
  final VoidCallback onPressed;

  /// The background color of the button
  final Color? backgroundColor;

  /// The foreground color of the button (text/icon color)
  final Color? foregroundColor;

  /// The border radius of the button
  final BorderRadius? borderRadius;

  /// The padding to apply to the button content
  final EdgeInsets? padding;

  /// The width of the button
  final double? width;

  /// The height of the button
  final double? height;

  /// Whether the button is enabled
  final bool isEnabled;

  /// The duration of the animation
  final Duration animationDuration;

  /// The elevation of the button
  final double elevation;

  /// Creates an animated button
  const AnimatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.isEnabled = true,
    this.animationDuration = const Duration(milliseconds: 150),
    this.elevation = 2,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = widget.backgroundColor ?? colorScheme.primary;
    final foregroundColor = widget.foregroundColor ?? colorScheme.onPrimary;
    final disabledBackgroundColor = backgroundColor.withValues(alpha: 0.6);
    final disabledForegroundColor = foregroundColor.withValues(alpha: 0.6);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: widget.animationDuration,
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color:
                    widget.isEnabled
                        ? backgroundColor
                        : disabledBackgroundColor,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                boxShadow: [
                  if (widget.isEnabled && widget.elevation > 0)
                    BoxShadow(
                      color: backgroundColor.withValues(alpha: 0.3),
                      blurRadius:
                          _isPressed ? widget.elevation / 2 : widget.elevation,
                      offset:
                          _isPressed ? const Offset(0, 1) : const Offset(0, 2),
                      spreadRadius: _isPressed ? 0 : 0.5,
                    ),
                ],
              ),
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: DefaultTextStyle(
                style: TextStyle(
                  color:
                      widget.isEnabled
                          ? foregroundColor
                          : disabledForegroundColor,
                  fontWeight: FontWeight.bold,
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color:
                        widget.isEnabled
                            ? foregroundColor
                            : disabledForegroundColor,
                  ),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A gradient animated button that provides visual feedback when pressed
class GradientAnimatedButton extends StatelessWidget {
  /// The child widget to display inside the button
  final Widget child;

  /// The callback when the button is pressed
  final VoidCallback onPressed;

  /// The gradient to apply to the button
  final Gradient gradient;

  /// The foreground color of the button (text/icon color)
  final Color? foregroundColor;

  /// The border radius of the button
  final BorderRadius? borderRadius;

  /// The padding to apply to the button content
  final EdgeInsets? padding;

  /// The width of the button
  final double? width;

  /// The height of the button
  final double? height;

  /// Whether the button is enabled
  final bool isEnabled;

  /// The duration of the animation
  final Duration animationDuration;

  /// The elevation of the button
  final double elevation;

  /// Creates a gradient animated button
  const GradientAnimatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.gradient,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.isEnabled = true,
    this.animationDuration = const Duration(milliseconds: 150),
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedButton(
      onPressed: onPressed,
      foregroundColor: foregroundColor ?? colorScheme.onPrimary,
      borderRadius: borderRadius,
      padding: padding,
      width: width,
      height: height,
      isEnabled: isEnabled,
      animationDuration: animationDuration,
      elevation: elevation,
      child: Container(
        decoration: BoxDecoration(
          gradient:
              isEnabled
                  ? gradient
                  : LinearGradient(
                    colors:
                        gradient.colors
                            .map((color) => color.withValues(alpha: 0.6))
                            .toList(),
                    begin: (gradient as LinearGradient).begin,
                    end: (gradient as LinearGradient).end,
                  ),
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
        child: Center(child: child),
      ),
    );
  }
}
