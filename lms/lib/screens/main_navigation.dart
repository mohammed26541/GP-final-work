import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider/auth_provider.dart';
import '../providers/theme_provider/theme_provider.dart';
import 'courses/all_courses_screen.dart';
import 'dashboard/my_courses_screen.dart';
import 'home/home_screen.dart';
import 'instructor/instructor_dashboard.dart';
import 'profile/profile_screen.dart';
import 'chat/chat_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _getScreensForRole(String role) {
    switch (role) {
      case AppConstants.roleInstructor:
        return [
          const HomeScreen(),
          const AllCoursesScreen(),
          const InstructorDashboard(), // Dashboard for course creation
          const ChatScreen(),
          const ProfileScreen(),
        ];
      case AppConstants.roleAdmin:
        return [
          const HomeScreen(),
          const AllCoursesScreen(),
          const MyCoursesScreen(),
          const ChatScreen(),
          const ProfileScreen(),
        ];
      case AppConstants.roleStudent:
      default:
        return [
          const HomeScreen(),
          const AllCoursesScreen(),
          const MyCoursesScreen(),
          const ChatScreen(),
          const ProfileScreen(),
        ];
    }
  }

  List<NavigationDestination> _getNavigationDestinations(
    BuildContext context,
    String role,
    AuthProvider authProvider,
  ) {
    final List<NavigationDestination> commonItems = [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.school_outlined),
        selectedIcon: Icon(Icons.school),
        label: 'Courses',
      ),
      const NavigationDestination(
        icon: Icon(Icons.chat_outlined),
        selectedIcon: Icon(Icons.chat),
        label: 'Chat',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    // Insert the role-specific item at position 2 (after Home, Courses)
    switch (role) {
      case AppConstants.roleInstructor:
        return [
          ...commonItems.sublist(0, 2),
          const NavigationDestination(
            icon: Icon(Icons.create_outlined),
            selectedIcon: Icon(Icons.create),
            label: 'My Courses',
          ),
          ...commonItems.sublist(2),
        ];
      default:
        return [
          ...commonItems.sublist(0, 2),
          const NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'MyCourses',
          ),
          ...commonItems.sublist(2),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userRole = authProvider.currentUser?.role ?? AppConstants.roleStudent;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Initialize screens based on user role
    _screens = _getScreensForRole(userRole);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth >= 900;

        if (isLargeScreen) {
          // Use NavigationRail for larger screens
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: colorScheme.surface,
                  useIndicator: true,
                  indicatorColor: colorScheme.secondaryContainer,
                  destinations:
                      _getNavigationDestinations(
                        context,
                        userRole,
                        authProvider,
                      ).map((item) {
                        return NavigationRailDestination(
                          icon: item.icon,
                          selectedIcon: item.selectedIcon ?? item.icon,
                          label: Text(item.label),
                        );
                      }).toList(),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: _screens),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => themeProvider.toggleTheme(),
              child: Icon(
                themeProvider.isDarkMode(context)
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
          );
        } else {
          // Use NavigationBar for smaller screens
          return Scaffold(
            body: IndexedStack(index: _currentIndex, children: _screens),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: colorScheme.surface,
              indicatorColor: colorScheme.secondaryContainer,
              destinations: _getNavigationDestinations(
                context,
                userRole,
                authProvider,
              ),
            ),
            floatingActionButton: FloatingActionButton.small(
              onPressed: () => themeProvider.toggleTheme(),
              child: Icon(
                themeProvider.isDarkMode(context)
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
          );
        }
      },
    );
  }
}
