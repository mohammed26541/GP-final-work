import 'package:flutter/material.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/theme_provider/theme_provider.dart';
import '../../../utils/responsive_helper.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  final AuthProvider authProvider;

  const HomeHeader({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLargeScreen = ResponsiveHelper.isDesktop(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Padding(
      padding: ResponsiveHelper.getHorizontalPadding(
        context,
      ).copyWith(top: 16, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${authProvider.currentUser?.name ?? ''}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'What would you like to learn today?',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Theme toggle button on larger screens
          if (isTablet || isLargeScreen)
            IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: Icon(
                themeProvider.isDarkMode(context)
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: colorScheme.primary,
              ),
              tooltip: 'Toggle theme',
            ),
          const SizedBox(width: 8),
          // Profile avatar
          GestureDetector(
            onTap: () {
              // Navigate to profile
            },
            child: Hero(
              tag: 'profile-avatar',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage:
                      authProvider.currentUser?.avatar.isNotEmpty ?? false
                          ? NetworkImage(authProvider.currentUser!.avatar)
                          : null,
                  child:
                      authProvider.currentUser?.avatar.isEmpty ?? true
                          ? Text(
                            authProvider.currentUser?.name.isNotEmpty ?? false
                                ? authProvider.currentUser!.name[0]
                                    .toUpperCase()
                                : 'U',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                          : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
