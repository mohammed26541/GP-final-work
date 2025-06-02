import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/responsive_scaffold.dart';
import '../auth/login_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return ResponsiveScaffold(
        appBar: AppBar(title: const Text('Profile'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 80,
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Please login to view your profile',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Login',
                width: 150,
                fullWidth: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: user),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = ResponsiveHelper.isDesktop(context);
          final isTablet = ResponsiveHelper.isTablet(context);

          return SingleChildScrollView(
            padding: ResponsiveHelper.getHorizontalPadding(
              context,
            ).copyWith(top: 24, bottom: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 800 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Header with Avatar
                    CustomCard(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Profile Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: ResponsiveHelper.responsive(
                                context,
                                mobile: 60,
                                tablet: 70,
                                desktop: 80,
                              ),
                              backgroundColor: colorScheme.primaryContainer,
                              backgroundImage:
                                  user.avatar.isNotEmpty
                                      ? NetworkImage(user.avatar)
                                      : null,
                              child:
                                  user.avatar.isEmpty
                                      ? Text(
                                        user.name.isNotEmpty
                                            ? user.name[0].toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          fontSize: ResponsiveHelper.responsive(
                                            context,
                                            mobile: 40,
                                            tablet: 50,
                                            desktop: 60,
                                          ),
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      )
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // User Name
                          Text(
                            user.name,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),

                          // User Role Badge
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getRoleColor(user.role, colorScheme),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user.role.toUpperCase(),
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Profile Info Card
                    CustomCardWithHeader(
                      title: 'Account Information',
                      leading: Icon(
                        Icons.info_outline,
                        color: colorScheme.primary,
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoItem(
                            context,
                            'Email',
                            user.email,
                            icon: Icons.email_outlined,
                          ),
                          const Divider(),
                          _buildInfoItem(
                            context,
                            'Courses Enrolled',
                            '${user.courses.length}',
                            icon: Icons.book_outlined,
                          ),
                          const Divider(),
                          _buildInfoItem(
                            context,
                            'Account Status',
                            user.isVerified ? 'Verified' : 'Not Verified',
                            icon: Icons.verified_user_outlined,
                            valueColor:
                                user.isVerified
                                    ? colorScheme.primary
                                    : colorScheme.error,
                          ),
                          const Divider(),
                          _buildInfoItem(
                            context,
                            'Member Since',
                            _formatDate(user.createdAt),
                            icon: Icons.calendar_today_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    if (isLargeScreen || isTablet)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            text: 'Change Password',
                            icon: Icons.lock_outline,
                            type: ButtonType.secondary,
                            width: 200,
                            fullWidth: false,
                            onPressed: () => _navigateToChangePassword(context),
                          ),
                          const SizedBox(width: 24),
                          CustomButton(
                            text: 'Logout',
                            icon: Icons.logout,
                            type: ButtonType.text,
                            width: 150,
                            fullWidth: false,
                            onPressed:
                                () => _showLogoutDialog(context, authProvider),
                          ),
                        ],
                      )
                    else
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          CustomButton(
                            text: 'Change Password',
                            icon: Icons.lock_outline,
                            type: ButtonType.secondary,
                            width: 200,
                            fullWidth: false,
                            onPressed: () => _navigateToChangePassword(context),
                          ),
                          CustomButton(
                            text: 'Logout',
                            icon: Icons.logout,
                            type: ButtonType.text,
                            width: 150,
                            fullWidth: false,
                            onPressed:
                                () => _showLogoutDialog(context, authProvider),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: valueColor ?? colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  Color _getRoleColor(String role, ColorScheme colorScheme) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.redAccent;
      case 'instructor':
        return Colors.blueAccent;
      case 'student':
      default:
        return colorScheme.secondary;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
