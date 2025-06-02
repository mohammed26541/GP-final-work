import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
    this.width,
    this.height = 50.0,
    this.borderRadius = 12.0,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the appropriate width
    final calculatedWidth =
        fullWidth
            ? double.infinity
            : (width ?? 120.0); // Provide a default width when width is null

    return SizedBox(
      width: calculatedWidth,
      height: height,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    );

    final effectiveTextStyle = textStyle ?? defaultTextStyle;
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(vertical: 0, horizontal: 16);

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            textStyle: effectiveTextStyle,
            minimumSize: Size.fromHeight(height),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return colorScheme.onPrimary.withAlpha(25);
              }
              return null;
            }),
          ),
          child: _buildButtonContent(colorScheme.onPrimary),
        );

      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.primary,
            side: BorderSide(color: colorScheme.primary),
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            textStyle: effectiveTextStyle,
            minimumSize: Size.fromHeight(height),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return colorScheme.primary.withAlpha(25);
              }
              return null;
            }),
          ),
          child: _buildButtonContent(colorScheme.primary),
        );

      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            textStyle: effectiveTextStyle,
            minimumSize: Size.fromHeight(height),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return colorScheme.primary.withAlpha(25);
              }
              return null;
            }),
          ),
          child: _buildButtonContent(colorScheme.primary),
        );
    }
  }

  Widget _buildButtonContent(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),
        ],
      );
    }

    return Text(text);
  }
}

// Enhanced button with icon both before and after text, and animations
class EnhancedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final ButtonType type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final bool fullWidth;
  final double borderRadius;

  const EnhancedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 50.0,
    this.fullWidth = true,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final width = fullWidth ? double.infinity : null;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on button type and provided overrides
    Color effectiveBackground =
        backgroundColor ??
        (type == ButtonType.primary ? colorScheme.primary : Colors.transparent);

    Color effectiveForeground =
        foregroundColor ??
        (type == ButtonType.primary
            ? colorScheme.onPrimary
            : colorScheme.primary);

    return SizedBox(
      width: width,
      height: height,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: MaterialButton(
          onPressed: isLoading ? null : onPressed,
          color: effectiveBackground,
          textColor: effectiveForeground,
          elevation: type == ButtonType.primary ? 0 : 0,
          highlightElevation: type == ButtonType.primary ? 0 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side:
                type != ButtonType.primary
                    ? BorderSide(color: effectiveForeground)
                    : BorderSide.none,
          ),
          child: _buildContent(effectiveForeground),
        ),
      ),
    );
  }

  Widget _buildContent(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 18),
        ],
      ],
    );
  }
}
