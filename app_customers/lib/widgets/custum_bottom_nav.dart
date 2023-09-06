import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// The [CustomAnimatedBottomBar].
class CustomAnimatedBottomBar extends StatelessWidget {
  /// The current selected index.
  final int selectedIndex;

  /// The icon size.
  final double iconSize;

  /// The background color.
  final Color? backgroundColor;

  /// The can elevation.
  final bool showElevation;

  /// The animation duration.
  final Duration animationDuration;

  /// The bottom nav bar item.
  final List<BottomNavyBarItem> items;

  /// The called when the item is selected.
  final ValueChanged<int> onItemSelected;

  /// The main axis alignment.
  final MainAxisAlignment mainAxisAlignment;

  /// The item corder radius.
  final double itemCornerRadius;

  /// The height.
  final double containerHeight;

  /// The curve.
  final Curve curve;

  /// Constructor of new [CustomAnimatedBottomBar].
  const CustomAnimatedBottomBar({
    Key? key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 30,
    this.backgroundColor,
    this.itemCornerRadius = 50,
    this.containerHeight = 56,
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.linear,
  })  : assert(items.length >= 2 && items.length <= 5),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).bottomAppBarColor;

    return Container(
      width: double.infinity,
      height: containerHeight,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40.0),
        ),
        boxShadow: <BoxShadow>[
          if (showElevation)
            BoxShadow(
              spreadRadius: 3,
              color: AppColors.darkGray.withOpacity(0.5),
              blurRadius: 5,
            ),
        ],
        gradient: LinearGradient(
          colors: [
            AppColors.darkGray,
            AppColors.darkGray,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: items.map((item) {
          final index = items.indexOf(item);

          return GestureDetector(
            onTap: () => onItemSelected(index),
            child: _ItemWidget(
              item: item,
              iconSize: iconSize,
              isSelected: index == selectedIndex,
              backgroundColor: bgColor,
              itemCornerRadius: itemCornerRadius,
              animationDuration: animationDuration,
              curve: curve,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final Curve curve;

  const _ItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    required this.animationDuration,
    required this.itemCornerRadius,
    required this.iconSize,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: isSelected,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(
                    size: iconSize,
                    color: isSelected
                        ? item.activeColor.withOpacity(1)
                        : item.inactiveColor ?? item.activeColor,
                  ),
                  child: item.icon,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: Text(
                    item.title,
                    textAlign: item.textAlign,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isSelected ? AppColors.white : item.inactiveColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The [BottomNavyBarItem].
class BottomNavyBarItem {
  /// The icon.
  final Widget icon;

  /// The title.
  final String title;

  /// The active color.
  final Color activeColor;

  /// The inactive color.
  final Color? inactiveColor;

  /// The text alignment.
  final TextAlign textAlign;

  /// Constructor of new [BottomNavyBarItem].
  const BottomNavyBarItem({
    required this.icon,
    required this.title,
    this.activeColor = Colors.blue,
    required this.textAlign,
    this.inactiveColor,
  });
}
