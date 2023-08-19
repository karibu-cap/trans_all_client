import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/app_colors.dart';

/// The text form field.
class SimpleTextField extends StatelessWidget {
  /// The label text.
  final String labelText;

  /// The hint text.
  final String? hintText;

  /// The prefix.
  final Widget? prefixIcon;

  /// The inputFormatters.
  final List<FilteringTextInputFormatter>? inputFormatters;

  /// Is valid field form.
  final bool isValidField;

  /// Text edition controller.
  final TextEditingController textController;

  /// The counter text.
  final String? counterText;

  /// The validator.
  final String? Function(String?)? validator;

  /// The onChange callback.
  final Function(String)? onChanged;

  /// The suffix image.
  final Widget? suffixImage;

  /// The suffix image.
  final String errorMessage;

  /// Constructor of new [ContactTextFieldForm].
  const SimpleTextField({
    this.suffixImage,
    this.inputFormatters,
    Key? key,
    required this.labelText,
    this.validator,
    this.hintText,
    this.prefixIcon,
    required this.textController,
    this.onChanged,
    this.counterText,
    required this.errorMessage,
    this.isValidField = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = const BorderRadius.all(Radius.circular(12));
    final borderColor = errorMessage.isNotEmpty
        ? AppColors.red
        : isValidField
            ? AppColors.lightGreen
            : AppColors.gray;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                labelText,
                style: TextStyle(color: AppColors.black),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              inputFormatters: inputFormatters,
              keyboardType: TextInputType.number,
              controller: textController,
              style: TextStyle(color: AppColors.black),
              textAlign: TextAlign.center,
              cursorColor: AppColors.darkBlack,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.gray.withOpacity(0.07),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: borderRadius,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor,
                  ),
                  borderRadius: borderRadius,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.red,
                  ),
                  borderRadius: borderRadius,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor,
                  ),
                  borderRadius: borderRadius,
                ),
                counterText: counterText,
                prefixIcon: prefixIcon,
                suffixIcon: suffixImage,
                hintText: '100',
                hintStyle: TextStyle(
                  color: AppColors.lightGray.withOpacity(
                    0.1,
                  ),
                ),
              ),
              onChanged: onChanged,
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.red,
                      size: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
