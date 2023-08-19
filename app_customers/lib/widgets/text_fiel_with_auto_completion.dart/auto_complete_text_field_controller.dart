import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_models/models.dart';

/// The auto complete text controller.
class AutoCompleteTextFieldController extends GetxController {
  /// The overlay entry using to display the suggestion list.
  OverlayEntry? _overlayEntry;

  /// The auto complete field text controller.
  final TextEditingController autoCompleteFieldTextController;

  /// Called when press on the suggestion.
  final void Function(Contact) onPressToSuggestion;

  /// The text field global key.
  final GlobalKey globalKey = GlobalKey();

  /// The layer link.
  LayerLink layerLink;

  /// The filter contact list.
  ValueNotifier<List<Contact>> filterUserContacts = ValueNotifier([]);

  /// The list of contact suggestion.
  List<Contact> listOfContactSuggestion = [];

  /// The textfield focus node.
  final focusNode = FocusNode();

  /// Display the overlay.
  final bool displayOverLay = true;

  /// The overlay entry using to display the suggestion list.
  OverlayEntry? get overlayEntry => _overlayEntry;

  /// Sets the overlayEntry.
  void setOverlayEntry(OverlayEntry entry) {
    _overlayEntry = entry;
  }

  /// The constructor of new [AutoCompleteTextFieldController].
  AutoCompleteTextFieldController(
    this.autoCompleteFieldTextController,
    this.onPressToSuggestion,
    this.listOfContactSuggestion,
    this.layerLink,
  );

  @override
  void dispose() {
    super.dispose();
  }

  /// Hide the overlay entries.
  void hideOrderEntry() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  /// Updates filter list.
  void updateFilterContactList(String value) {
    if (value.isEmpty) {
      return;
    }

    filterUserContacts.value = listOfContactSuggestion
        .where((user) =>
            user.name.toLowerCase().contains(value.toLowerCase()) ||
            RegExp(value).hasMatch(user.phoneNumber.replaceAll(' ', '')))
        .toList();

    return;
  }
}
