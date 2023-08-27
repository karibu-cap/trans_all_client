import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_models/models.dart';

import '../../themes/app_colors.dart';
import '../contact_list_widget.dart';
import 'auto_complete_text_field_controller.dart';

/// The auto complete text field.
class AutoCompleteTextField extends StatelessWidget {
  /// Called when press on the suggestion.
  final Function(Contact) onPressToSuggestion;

  /// List of suggestion.
  final List<Contact> listOfContactSuggestion;

  /// The label text.
  final String labelText;

  /// The hint text.
  final String? hintText;

  /// The prefix.
  final Widget prefixIcon;

  /// The save contact button.
  final Widget? saveContactIcon;

  /// The contact widget.
  final Widget contactWidget;

  /// Is valid field form.
  final bool isValidField;

  /// Text edition controller.
  final TextEditingController textController;

  /// The validator.
  final String? Function(String?)? validator;

  /// The onChange callback.
  final void Function(String)? onChanged;

  /// The suffix image.
  final Widget? suffixImage;

  /// The suffix image.
  final String errorMessage;

  /// The layer link.
  final LayerLink layerLink;

  /// Constructor of new [ContactTextFieldForm].
  const AutoCompleteTextField({
    this.suffixImage,
    Key? key,
    required this.labelText,
    this.validator,
    this.hintText,
    required this.layerLink,
    required this.prefixIcon,
    required this.contactWidget,
    required this.textController,
    required this.listOfContactSuggestion,
    this.onChanged,
    required this.errorMessage,
    required this.onPressToSuggestion,
    this.isValidField = false,
    this.saveContactIcon,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = const BorderRadius.all(Radius.circular(12));
    final saveIcon = saveContactIcon;
    final borderColor = errorMessage.isNotEmpty
        ? AppColors.red
        : isValidField
            ? AppColors.lightGreen
            : AppColors.gray;
    Get.put(
      AutoCompleteTextFieldController(
        textController,
        onPressToSuggestion,
        listOfContactSuggestion,
        layerLink,
      ),
      tag: labelText,
      permanent: true,
    );

    final controller = Get.find<AutoCompleteTextFieldController>(
      tag: labelText,
    );

    /// Can display overlay.
    void showOverlay() {
      controller.hideOrderEntry();

      final OverlayState? overlayState = Overlay.of(context);
      final RenderBox renderBox = context.findRenderObject() as RenderBox;

      final size = renderBox.size;
      final newOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: controller.layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, 60),
            child: Material(
              child: Padding(
                padding: EdgeInsets.zero,
                child: SizedBox(
                  child: ValueListenableBuilder<List<Contact>>(
                    valueListenable: controller.filterUserContacts,
                    builder: (context, value, child) => ContactListWidget(
                        listOfContact: value,
                        onContactPressed: (contact) {
                          onPressToSuggestion(contact);
                          controller.hideOrderEntry();

                          final FocusScopeNode currentFocus =
                              FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        }),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      controller.setOverlayEntry(newOverlayEntry);
      overlayState?.insert(newOverlayEntry);
    }

    /// Filter user contact.
    void _filterUserContact(
      String value,
    ) async {
      if (value.isEmpty) {
        return;
      }
      controller.filterUserContacts.value = listOfContactSuggestion
          .where((user) =>
              user.name.toLowerCase().contains(value.toLowerCase()) ||
              RegExp(value).hasMatch(user.phoneNumber.replaceAll(' ', '')))
          .toList();
      if (controller.filterUserContacts.value.isEmpty) {
        controller.hideOrderEntry();
      } else {
        showOverlay();
      }
    }

    void _onFocusChange(bool value) {
      if (!value) {
        controller.hideOrderEntry();

        return;
      }
      if (controller.autoCompleteFieldTextController.text.length > 2) {
        _filterUserContact(
          controller.autoCompleteFieldTextController.text,
        );
      }
    }

    void _onTextFieldChange(String value) {
      if (value.length > 2) {
        _filterUserContact(value);
      } else {
        controller.hideOrderEntry();
      }
      final onChangedText = onChanged;
      if (onChangedText != null) {
        onChangedText(value);
      }
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      labelText,
                      style: TextStyle(color: AppColors.black),
                    ),
                  ),
                ),
                if (saveIcon != null && !kIsWeb) saveIcon,
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                if (!kIsWeb)
                  Expanded(
                    child: Container(
                      height: 55,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.fromBorderSide(
                          BorderSide(color: borderColor),
                        ),
                        borderRadius: borderRadius,
                      ),
                      child: FittedBox(
                        child: contactWidget,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 4,
                  child: Focus(
                    focusNode: controller.focusNode,
                    child: CompositedTransformTarget(
                      link: controller.layerLink,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: textController,
                        style: TextStyle(
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: AppColors.darkGray,
                        decoration: InputDecoration(
                          filled: false,
                          fillColor: AppColors.purple.withOpacity(0.03),
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
                          prefixIcon: prefixIcon,
                          suffixIcon: suffixImage,
                          hintText: '6** *** ***',
                          hintStyle: TextStyle(
                            color: AppColors.lightGray.withOpacity(
                              0.1,
                            ),
                          ),
                        ),
                        onChanged: _onTextFieldChange,
                      ),
                    ),
                    onFocusChange: _onFocusChange,
                  ),
                ),
              ],
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
