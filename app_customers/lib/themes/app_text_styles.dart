import 'package:flutter/material.dart';

import 'app_colors.dart';

/// List of Customers font weights.
class AppFontWeights {
  /// The bold font weight.
  static const semiBold = FontWeight.w600;

  /// The medium font weight.
  static const medium = FontWeight.w500;

  /// The light font weight.
  static const regular = FontWeight.w400;
}

/// List of Customers font size.
class AppFontSizes {
  /// The extra large font size generally used for important information we want
  /// to highlight.
  /// e.g: referral code, user balance.
  static const extraLargeText = 32.0;

  /// The large font size generally used for header.
  static const header = 19.0;

  /// The semi large font size generally used for title.
  static const subHeader = 17.0;

  /// The font size generally used for button.
  static const largeBody = 15.0;

  /// The normal font size generally used for message body.
  static const body = 13.0;

  /// The lite font size generally used for caption.
  static const caption = 11.0;
}

/// List of the Customers text styles.
class AppTextStyles {
  /// Common text styles across the app.
  /// Button label text style.
  static const commonButtonLabel = TextStyle(
    fontSize: 20,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.white,
  );

  /// Common text styles across the app.
  /// Title text style.
  static const commonTitleLabel = TextStyle(
    fontSize: AppFontSizes.extraLargeText,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.white,
  );

  /// Common text styles across the app.
  /// Header h3 text style.
  static const headerH3Label = TextStyle(
    fontSize: AppFontSizes.body,
    fontWeight: AppFontWeights.regular,
    color: AppColors.black,
  );

  /// Common text styles across the app.
  /// Header h4 text style.
  static const headerH4Label = TextStyle(
    fontSize: AppFontSizes.caption,
    fontWeight: AppFontWeights.medium,
    color: AppColors.darkGray,
  );
}
