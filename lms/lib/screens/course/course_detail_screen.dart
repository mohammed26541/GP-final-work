import 'package:flutter/material.dart';
import 'package:lms/screens/payment/payment_first_checkout_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/auth_provider/auth_provider.dart';
import '../../providers/course_provider/course_provider.dart';
import '../../providers/order_provider/order_provider.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/loading_animation.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../services/purchase_verification_service.dart';
import 'course_content_screen.dart';

// Import tab components
import 'tabs/overview_detail_tab.dart';
import 'tabs/content_detail_tab.dart';
import 'tabs/reviews_detail_tab.dart';
import 'tabs/qa_detail_tab.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchCourseDetails();
    _loadUserOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchCourseDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );

      // First refresh user data to get latest enrollment status
      if (authProvider.currentUser != null) {
        await authProvider.refreshCurrentUser();
      }

      // Then fetch course details
      await courseProvider.fetchCourseById(widget.courseId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching course details: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUserOrders() async {
    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Only load orders if user is logged in
      if (authProvider.currentUser != null) {
        await orderProvider.fetchAllOrders();
        print(
          '📦 Orders loaded for purchase verification: ${orderProvider.orders.length} orders',
        );

        // Force UI update after orders are loaded
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('❌ Error loading orders: $e');
    }
  }

  Future<void> _enrollCourse() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to enroll in this course'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (courseProvider.selectedCourse == null) return;

    // Get course ID
    final String courseId = courseProvider.selectedCourse!.id;

    // Check if the user has already purchased this course using our service
    final bool hasAlreadyPurchased =
        await PurchaseVerificationService.hasCurrentUserPurchasedCourse(
          context,
          courseId,
        );

    // If the user has already purchased the course, show a message and don't proceed
    if (hasAlreadyPurchased) {
      if (mounted) {
        PurchaseVerificationService.showAlreadyPurchasedDialog(
          context,
          courseId,
          () {
            // Navigate to the course content
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseContentScreen(courseId: courseId),
              ),
            );
          },
        );
      }
      return;
    }

    // Navigate directly to checkout without creating an order
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PaymentFirstCheckoutScreen(
                course: courseProvider.selectedCourse!,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final course = courseProvider.selectedCourse;
    final bool isAdmin = authProvider.currentUser?.role == 'admin';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ResponsiveScaffold(
      body:
          _isLoading
              ? Center(
                child: LoadingAnimation(
                  showLabel: true,
                  text: 'Loading course details...',
                  color: colorScheme.primary,
                ),
              )
              : course == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Course not found',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The course you are looking for does not exist or has been removed.',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Go Back',
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              )
              : CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: ResponsiveHelper.responsive(
                      context,
                      mobile: 250,
                      tablet: 300,
                      desktop: 350,
                    ),
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Course thumbnail
                          Hero(
                            tag: 'course_${course.id}',
                            child: CachedNetworkImage(
                              imageUrl: course.thumbnail,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget:
                                  (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                            ),
                          ),
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withAlpha(200),
                                ],
                              ),
                            ),
                          ),
                          // Course info
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          course.name,
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isAdmin)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colorScheme.error.withAlpha(
                                              200,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.admin_panel_settings,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Admin Access',
                                                style: theme
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        course.rating.toStringAsFixed(1),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(${course.reviews.length})',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(
                                        Icons.people,
                                        color: Colors.white70,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${course.totalStudents}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Price section
                  SliverToBoxAdapter(
                    child: CustomCard(
                      margin: EdgeInsets.symmetric(
                        horizontal:
                            ResponsiveHelper.getHorizontalPadding(context).left,
                        vertical: 16,
                      ),
                      elevation: 1,
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Original price with strikethrough
                              Text(
                                '\$${course.discountedPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              // Actual price to pay (original price)
                              Text(
                                '\$${course.price.toStringAsFixed(2)}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                // Use FutureBuilder to handle async verification
                                return FutureBuilder<bool>(
                                  future:
                                      PurchaseVerificationService.hasCurrentUserPurchasedCourse(
                                        context,
                                        course.id,
                                      ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    // Default to false if still loading
                                    final bool hasAccess =
                                        snapshot.data ?? false;

                                    return CustomButton(
                                      text:
                                          hasAccess
                                              ? 'Continue Learning'
                                              : 'Purchase Course',
                                      icon:
                                          hasAccess
                                              ? Icons.play_circle_fill
                                              : Icons.shopping_cart,
                                      onPressed:
                                          hasAccess
                                              ? () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            CourseContentScreen(
                                                              courseId:
                                                                  course.id,
                                                            ),
                                                  ),
                                                );
                                              }
                                              : _enrollCourse,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tab Bar
                  SliverPersistentHeader(
                    delegate: _SliverTabBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: colorScheme.primary,
                        unselectedLabelColor: colorScheme.onSurfaceVariant,
                        indicatorColor: colorScheme.primary,
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Content'),
                          Tab(text: 'Reviews'),
                          Tab(text: 'Q&A'),
                        ],
                      ),
                      backgroundColor: theme.scaffoldBackgroundColor,
                    ),
                    pinned: true,
                  ),

                  // Tab content - Using SliverFillRemaining to allow proper scrolling
                  SliverFillRemaining(
                    child: Padding(
                      padding: ResponsiveHelper.getHorizontalPadding(context),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Overview Tab - Always accessible
                          OverviewDetailTab(course: course),

                          // Conditional tabs that require purchase
                          FutureBuilder<bool>(
                            future:
                                PurchaseVerificationService.hasCurrentUserPurchasedCourse(
                                  context,
                                  course.id,
                                ),
                            builder: (context, snapshot) {
                              final bool hasAccess = snapshot.data ?? false;
                              // Access check for Admin users
                              final bool isAdmin =
                                  authProvider.currentUser?.role == 'admin';

                              if (hasAccess || isAdmin) {
                                return ContentDetailTab(course: course);
                              } else {
                                return _buildPurchaseRequiredMessage(
                                  context,
                                  "Course content is only available after purchase",
                                );
                              }
                            },
                          ),

                          // Reviews Tab - Requires purchase
                          FutureBuilder<bool>(
                            future:
                                PurchaseVerificationService.hasCurrentUserPurchasedCourse(
                                  context,
                                  course.id,
                                ),
                            builder: (context, snapshot) {
                              final bool hasAccess = snapshot.data ?? false;
                              // Access check for Admin users
                              final bool isAdmin =
                                  authProvider.currentUser?.role == 'admin';

                              if (hasAccess || isAdmin) {
                                return ReviewsDetailTab(course: course);
                              } else {
                                return _buildPurchaseRequiredMessage(
                                  context,
                                  "Reviews are only available after purchase",
                                );
                              }
                            },
                          ),

                          // Q&A Tab - Requires purchase
                          FutureBuilder<bool>(
                            future:
                                PurchaseVerificationService.hasCurrentUserPurchasedCourse(
                                  context,
                                  course.id,
                                ),
                            builder: (context, snapshot) {
                              final bool hasAccess = snapshot.data ?? false;
                              // Access check for Admin users
                              final bool isAdmin =
                                  authProvider.currentUser?.role == 'admin';

                              if (hasAccess || isAdmin) {
                                return QADetailTab(course: course);
                              } else {
                                return _buildPurchaseRequiredMessage(
                                  context,
                                  "Q&A is only available after purchase",
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildPurchaseRequiredMessage(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: CustomCard(
        elevation: 0,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Purchase this course to access all features and content',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Purchase Course',
              icon: Icons.shopping_cart,
              onPressed: _enrollCourse,
            ),
          ],
        ),
      ),
    );
  }
}

/// A delegate for creating a pinned tab bar in a SliverPersistentHeader
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar, {this.backgroundColor});

  final TabBar tabBar;
  final Color? backgroundColor;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor ?? Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
