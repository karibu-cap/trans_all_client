import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import 'forfeit_view_model.dart';

/// The forfeit view controller.
class ForfeitController extends ChangeNotifier {
  final ForfeitViewModel _model;

  /// The Selected operator.
  BehaviorSubject<String> selectedOperator = BehaviorSubject<String>();

  /// The filter list of forfeit.
  BehaviorSubject<List<Forfeit>> get filterListOfForfeit =>
      _model.filterListOfForfeit;

  /// The list of forfeit.
  List<Forfeit> get listOfForfeit => _model.listOfForfeit;

  /// The list of operator type supported by forfeit.
  Set<String> get listOfOperatorType => _model.listOfOperatorType;

  /// List of forfeit category.
  Set<SelectedCategory> get listOfForfeitCategory =>
      _model.listOfForfeitCategory;

  /// List of forfeit validity.
  Set<SelectedValidity> get listOfForfeitValidity =>
      _model.listOfForfeitValidity;

  /// The variable for check if the initialization is done.
  Completer<void> get initializeDone => _model.initializeDone;

  /// Constructs a new [ForfeitController].
  ForfeitController({required ForfeitViewModel model}) : _model = model;

  /// Returns the operator name.
  String? getOperatorName(String operationTransferType) {
    if (operationTransferType == OperationTransferType.camtelUnitTransfer.key) {
      return 'Camtel';
    }
    if (operationTransferType == OperationTransferType.mtnUnitTransfer.key) {
      return 'MTN';
    }
    if (operationTransferType == OperationTransferType.orangeUnitTransfer.key) {
      return 'Orange';
    }

    return null;
  }

  /// Changes the validity type.
  void changeValidityState(
    bool state,
    SelectedValidity selectedValidity,
  ) {
    for (final validity in listOfForfeitValidity) {
      if (validity.validity.key == selectedValidity.validity.key) {
        validity.isSelected = state;
      }
    }
    updateFilterListOfForfeit();
    notifyListeners();
  }

  /// Changes the category type.
  void changeCategoryState(
    bool state,
    SelectedCategory selectedCategory,
  ) {
    for (final category in listOfForfeitCategory) {
      if (category.category.key == selectedCategory.category.key) {
        category.isSelected = state;
      }
    }
    updateFilterListOfForfeit();
    notifyListeners();
  }

  /// Updates the filter forfeit.
  void updateFilterListOfForfeit() {
    final intl = Get.find<AppInternationalization>();

    final selectOperator = selectedOperator.stream.value;
    final selectedValidity = listOfForfeitValidity
        .where((e) => e.isSelected)
        .map((e) => e.validity.key);
    final selectedCategory = listOfForfeitCategory
        .where((e) => e.isSelected)
        .map((e) => e.category.key);

    if (selectOperator == intl.all) {
      if (selectedValidity.isEmpty && selectedCategory.isEmpty) {
        filterListOfForfeit.add([...listOfForfeit]);

        return;
      }
      final filterElement = listOfForfeit.where((element) =>
          selectedValidity.contains(element.validity.key) ||
          selectedCategory.contains(element.category.key));

      _model.filterListOfForfeit.add([...filterElement]);

      return;
    }

    if (selectedValidity.isEmpty && selectedCategory.isEmpty) {
      final filterElement =
          listOfForfeit.where((e) => selectOperator == e.reference.key);
      _model.filterListOfForfeit.add([...filterElement]);

      return;
    }

    final filterElement = listOfForfeit
        .where((e) => selectOperator == e.reference.key)
        .where((element) =>
            selectedValidity.contains(element.validity.key) ||
            selectedCategory.contains(element.category.key));

    _model.filterListOfForfeit.add([...filterElement]);
  }
}
