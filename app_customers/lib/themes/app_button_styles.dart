import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The big rounded button used as main action button in screens.
ButtonStyle roundedBigButton(
  BuildContext context,
  Color backgroundColor,
  Color borderColor,
) =>
    ButtonStyle(
      fixedSize: MaterialStateProperty.all(
        Size(
          MediaQuery.of(context).size.width,
          60,
        ),
      ),
      elevation: MaterialStateProperty.all(5.0),
      backgroundColor: MaterialStateProperty.all(backgroundColor),
      padding: MaterialStateProperty.all(
        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );

/// The small rounded button used to add items to the cart.
final roundedSmallButton = ButtonStyle(
  elevation: MaterialStateProperty.all(5.0),
  backgroundColor: MaterialStateProperty.all(AppColors.darkGray),
  padding: MaterialStateProperty.all(
    EdgeInsets.symmetric(vertical: 5, horizontal: 30),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(18.0)),
    ),
  ),
);

/// The rounded extra large button used as main action button in screens.
final roundedXXLButton = ButtonStyle(
  elevation: MaterialStateProperty.all(5.0),
  backgroundColor: MaterialStateProperty.all(AppColors.blue),
  padding: MaterialStateProperty.all(
    EdgeInsets.symmetric(vertical: 20, horizontal: 50),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    ),
  ),
);
