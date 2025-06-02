import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry contentPadding;
  final TextCapitalization textCapitalization;
  final bool filled;
  final Color? fillColor;
  final InputBorder? border;
  final bool isDense;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.contentPadding = const EdgeInsets.all(16),
    this.textCapitalization = TextCapitalization.none,
    this.filled = true,
    this.fillColor,
    this.border,
    this.isDense = false,
  }) : assert(
         controller == null || initialValue == null,
         'Cannot provide both a controller and an initialValue',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Compute appropriate colors based on theme brightness
    final defaultFillColor =
        isDarkMode ? Colors.grey[800] : AppColors.surfaceLight;

    final labelColor =
        enabled ? AppColors.textPrimary : AppColors.textSecondary;

    final effectiveFillColor =
        fillColor ?? (enabled ? defaultFillColor : Colors.grey[200]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          minLines: minLines,
          enabled: enabled,
          autofocus: autofocus,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onSubmitted,
          onChanged: onChanged,
          textCapitalization: textCapitalization,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textLight,
            ),
            prefixIcon:
                prefixIcon != null
                    ? Icon(
                      prefixIcon,
                      color:
                          enabled ? AppColors.primary : AppColors.textSecondary,
                    )
                    : null,
            suffixIcon: suffixIcon,
            filled: filled,
            fillColor: effectiveFillColor,
            contentPadding:
                isDense
                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                    : contentPadding,
            isDense: isDense,
            border:
                border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
            enabledBorder:
                border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
            focusedBorder:
                border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
            errorBorder:
                border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.error, width: 1.5),
                ),
            focusedErrorBorder:
                border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.error, width: 2),
                ),
            disabledBorder:
                border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
          ),
        ),
      ],
    );
  }
}
