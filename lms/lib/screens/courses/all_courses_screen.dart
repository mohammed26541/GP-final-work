import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider/category_provider.dart';
import '../../providers/course_provider/course_provider.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/course_card.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_animation.dart';
import '../../widgets/responsive_grid_view.dart';
import '../../widgets/responsive_scaffold.dart';
import '../course/course_detail_screen.dart';

class AllCoursesScreen extends StatefulWidget {
  final String? categoryId;
  final String title;

  const AllCoursesScreen({
    super.key,
    this.categoryId,
    this.title = 'All Courses',
  });

  @override
  State<AllCoursesScreen> createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  bool _isLoading = true;
  bool _isCategoriesLoading = true;
  String _sortBy = 'newest';
  String? _selectedCategoryId;
  final List<String> _sortOptions = [
    'newest',
    'rating',
    'price_low',
    'price_high',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    // Use post-frame callback to fetch data after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchCategories(), _fetchCourses()]);
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isCategoriesLoading = true;
    });

    try {
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );
      await categoryProvider.fetchAllCategories();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching categories: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCategoriesLoading = false;
        });
      }
    }
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );

      if (_selectedCategoryId != null) {
        await courseProvider.fetchCoursesByCategory(_selectedCategoryId!);
      } else {
        await courseProvider.fetchAllCourses();
      }

      _sortCourses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching courses: ${e.toString()}'),
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

  void _sortCourses() {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    switch (_sortBy) {
      case 'newest':
        courseProvider.sortByNewest();
        break;
      case 'rating':
        courseProvider.sortByRating();
        break;
      case 'price_low':
        courseProvider.sortByPriceLowToHigh();
        break;
      case 'price_high':
        courseProvider.sortByPriceHighToLow();
        break;
    }
  }

  String _getSortLabel(String sortOption) {
    switch (sortOption) {
      case 'newest':
        return 'Newest';
      case 'rating':
        return 'Highest Rated';
      case 'price_low':
        return 'Price: Low to High';
      case 'price_high':
        return 'Price: High to Low';
      default:
        return 'Sort';
    }
  }

  void _selectCategory(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;

    final courses =
        _selectedCategoryId != null
            ? courseProvider.coursesByCategory
            : courseProvider.allCourses;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort courses',
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _sortCourses();
              });
            },
            itemBuilder: (context) {
              return _sortOptions.map((option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Row(
                    children: [
                      Icon(
                        _sortBy == option
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: _sortBy == option ? colorScheme.primary : null,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(_getSortLabel(option)),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        color: colorScheme.primary,
        child:
            _isLoading && _isCategoriesLoading
                ? Center(
                  child: LoadingAnimation(
                    showLabel: true,
                    text: 'Loading courses...',
                    color: colorScheme.primary,
                  ),
                )
                : CustomScrollView(
                  slivers: [
                    // Categories section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: ResponsiveHelper.getHorizontalPadding(
                                context,
                              ),
                              child: Text(
                                'Browse Categories',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _isCategoriesLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : SizedBox(
                                  height: 48,
                                  child: ListView.builder(
                                    padding:
                                        ResponsiveHelper.getHorizontalPadding(
                                          context,
                                        ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        categories.length +
                                        1, // +1 for "All" option
                                    itemBuilder: (context, index) {
                                      // "All" category option
                                      if (index == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: ChoiceChip(
                                            label: const Text('All Courses'),
                                            selected:
                                                _selectedCategoryId == null,
                                            onSelected: (selected) {
                                              if (selected) {
                                                _selectCategory(null);
                                              }
                                            },
                                          ),
                                        );
                                      }

                                      // Category chips
                                      final category = categories[index - 1];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: ChoiceChip(
                                          label: Text(category.name),
                                          selected:
                                              _selectedCategoryId ==
                                              category.id,
                                          onSelected: (selected) {
                                            if (selected) {
                                              _selectCategory(category.id);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),

                    // Courses section
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      sliver:
                          courses.isEmpty
                              ? SliverFillRemaining(
                                child: Center(
                                  child: EmptyState(
                                    title: 'No Courses Found',
                                    message:
                                        _selectedCategoryId != null
                                            ? 'No courses available in this category'
                                            : 'No courses available at the moment',
                                    animationAsset:
                                        'assets/animations/empty_courses.json',
                                    icon: Icons.school_outlined,
                                    iconColor: colorScheme.primary,
                                  ),
                                ),
                              )
                              : SliverToBoxAdapter(
                                child: Padding(
                                  padding:
                                      ResponsiveHelper.getHorizontalPadding(
                                        context,
                                      ),
                                  child: CustomCardWithHeader(
                                    title: 'Found ${courses.length} Courses',
                                    subtitle:
                                        'Sorted by ${_getSortLabel(_sortBy)}',
                                    leading: Icon(
                                      Icons.school,
                                      color: colorScheme.primary,
                                    ),
                                    content: ResponsiveGridView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      mobileColumns: 1,
                                      tabletColumns: 2,
                                      desktopColumns: 3,
                                      childAspectRatio: 0.8,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      children:
                                          courses.map((course) {
                                            return CourseCard(
                                              course: course,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            CourseDetailScreen(
                                                              courseId:
                                                                  course.id,
                                                            ),
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList()
                                    ),
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
      ),
    );
  }
}
