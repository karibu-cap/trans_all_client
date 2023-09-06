import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';

/// Component that shows the header tabs.
class HeaderTabs extends StatelessWidget {
  /// The first label.
  final String firstLabel;

  /// The second label.
  final String secondLabel;

  /// The default active tabs.
  final int activeIndex;

  /// The method that will called on tab change.
  final void Function(int index) onChange;

  /// Creates a new [HeaderTabsComponent].
  const HeaderTabs({
    required this.onChange,
    this.activeIndex = 0,
    Key? key,
    required this.firstLabel,
    required this.secondLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      ClipRRect(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(25)),
        child: _Tab(
          active: activeIndex == 0,
          label: firstLabel,
          onTap: () => onChange(0),
        ),
      ),
      ClipRRect(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(25)),
        child: _Tab(
          active: activeIndex == 1,
          label: secondLabel,
          onTap: () => onChange(1),
        ),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        margin: EdgeInsets.all(16),
        elevation: 8,
        shadowColor: AppColors.darkGray,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          side: BorderSide(color: AppColors.white, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: tabs,
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final bool active;
  final String label;
  final void Function() onTap;
  const _Tab({
    required this.active,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      height: 50,
      width: 150,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.white : AppColors.darkGray,
          ),
        ),
      ),
    );
    if (active) {
      child = ColoredBox(
        color: AppColors.darkGray,
        child: child,
      );
    }

    return Material(
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        child: child,
      ),
    );
  }
}
