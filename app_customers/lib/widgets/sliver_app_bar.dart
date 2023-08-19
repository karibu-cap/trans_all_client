import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// The custom app bar widget.
class CustomSilverAppBar extends StatelessWidget {
  /// The leading widget of app bar.
  final Widget? leadingAppBar;

  /// The title of the app bar.
  final String title;

  /// Construct a new custom app bar.
  const CustomSilverAppBar({
    this.leadingAppBar,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      centerTitle: false,
      foregroundColor: AppColors.black,
      title: Chip(
        backgroundColor: AppColors.white,
        padding: EdgeInsets.zero,
        avatar: CircleAvatar(
          backgroundColor: AppColors.green,
          child: const Text(
            'T',
            style: TextStyle(color: AppColors.white),
          ),
        ),
        label: const Text(
          'RANSTU',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
