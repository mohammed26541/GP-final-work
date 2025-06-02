import 'package:flutter/material.dart';
import '../../../utils/responsive_helper.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool isSearching;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLargeScreen = ResponsiveHelper.isDesktop(context);

    return Row(
      children: [
        Expanded(
          child: SearchBar(
            controller: controller,
            hintText: 'Search courses...',
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16),
            ),
            leading: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            onSubmitted: (_) => onSearch(),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: onSearch,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 24 : 16,
              vertical: 15,
            ),
          ),
          child:
              isSearching
                  ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                      strokeWidth: 2,
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, color: colorScheme.onPrimary),
                      if (isLargeScreen) ...[
                        const SizedBox(width: 8),
                        Text('Search', style: theme.textTheme.labelLarge),
                      ],
                    ],
                  ),
        ),
      ],
    );
  }
}
