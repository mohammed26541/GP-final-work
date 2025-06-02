import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// A responsive grid view that adapts to different screen sizes
class ResponsiveGridView extends StatelessWidget {
  /// The list of items to display
  final List<Widget> children;

  /// The spacing between items horizontally
  final double crossAxisSpacing;

  /// The spacing between items vertically
  final double mainAxisSpacing;

  /// The minimum width of each item
  final double minItemWidth;

  /// The aspect ratio of each item (width / height)
  final double childAspectRatio;

  /// The padding around the grid
  final EdgeInsets? padding;

  /// Whether the grid should be scrollable
  final bool shrinkWrap;

  /// The physics of the grid
  final ScrollPhysics? physics;

  /// The number of columns for mobile devices
  final int mobileColumns;

  /// The number of columns for tablet devices
  final int tabletColumns;

  /// The number of columns for desktop devices
  final int desktopColumns;

  /// Creates a responsive grid view
  const ResponsiveGridView({
    super.key,
    required this.children,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.minItemWidth = 300,
    this.childAspectRatio = 1,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveHelper.getDeviceType(context);

        // Determine number of columns based on device type
        final crossAxisCount = switch (deviceType) {
          DeviceType.desktop => desktopColumns,
          DeviceType.tablet => tabletColumns,
          DeviceType.mobile => mobileColumns,
        };

        return GridView.builder(
          padding: padding ?? ResponsiveHelper.getHorizontalPadding(context),
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// A responsive grid view that uses a maximum cross axis extent
class ResponsiveGridViewExtent extends StatelessWidget {
  /// The list of items to display
  final List<Widget> children;

  /// The spacing between items horizontally
  final double crossAxisSpacing;

  /// The spacing between items vertically
  final double mainAxisSpacing;

  /// The maximum width of each item
  final double maxCrossAxisExtent;

  /// The aspect ratio of each item (width / height)
  final double childAspectRatio;

  /// The padding around the grid
  final EdgeInsets? padding;

  /// Whether the grid should be scrollable
  final bool shrinkWrap;

  /// The physics of the grid
  final ScrollPhysics? physics;

  /// Creates a responsive grid view with max extent
  const ResponsiveGridViewExtent({
    super.key,
    required this.children,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.maxCrossAxisExtent = 300,
    this.childAspectRatio = 1,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? ResponsiveHelper.getHorizontalPadding(context),
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A responsive staggered grid view
class ResponsiveStaggeredGridView extends StatelessWidget {
  /// The list of items to display
  final List<Widget> children;

  /// The spacing between items horizontally
  final double crossAxisSpacing;

  /// The spacing between items vertically
  final double mainAxisSpacing;

  /// The padding around the grid
  final EdgeInsets? padding;

  /// Whether the grid should be scrollable
  final bool shrinkWrap;

  /// The physics of the grid
  final ScrollPhysics? physics;

  /// The pattern of item sizes
  final List<int> pattern;

  /// The number of columns for mobile devices
  final int mobileColumns;

  /// The number of columns for tablet devices
  final int tabletColumns;

  /// The number of columns for desktop devices
  final int desktopColumns;

  /// Creates a responsive staggered grid view
  const ResponsiveStaggeredGridView({
    super.key,
    required this.children,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.pattern = const [1, 1, 2, 1, 1, 1],
    this.mobileColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveHelper.getDeviceType(context);

        // Determine number of columns based on device type
        final crossAxisCount = switch (deviceType) {
          DeviceType.desktop => desktopColumns,
          DeviceType.tablet => tabletColumns,
          DeviceType.mobile => mobileColumns,
        };

        // Calculate the width and height of each item
        final itemWidth =
            (constraints.maxWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
            crossAxisCount;

        // Build the staggered grid
        final List<Widget> staggeredItems = [];
        int patternIndex = 0;

        for (int i = 0; i < children.length; i++) {
          // Get the span from the pattern
          final span = pattern[patternIndex % pattern.length];
          patternIndex++;

          // Calculate the width and height of this item
          final width =
              span == 1
                  ? itemWidth
                  : (itemWidth * span) + (crossAxisSpacing * (span - 1));

          // Add the item to the list
          staggeredItems.add(SizedBox(width: width, child: children[i]));
        }

        return Padding(
          padding: padding ?? ResponsiveHelper.getHorizontalPadding(context),
          child: Wrap(
            spacing: crossAxisSpacing,
            runSpacing: mainAxisSpacing,
            children: staggeredItems,
          ),
        );
      },
    );
  }
}
