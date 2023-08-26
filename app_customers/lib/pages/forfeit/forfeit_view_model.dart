import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/forfeitRepository.dart';

/// The forfeit view model.
class ForfeitViewModel {
  final ForfeitRepository _forfeitRepository;

  /// The list of forfeit.
  List<Forfeit> listOfForfeit = [];

  /// The list of operator type supported by forfeit.
  Set<String> listOfOperatorType = {};

  /// List of forfeit category.
  Set<SelectedCategory> listOfForfeitCategory = {};

  /// The filter list of forfeit.
  BehaviorSubject<List<Forfeit>> filterListOfForfeit = BehaviorSubject();

  /// List of forfeit validity.
  Set<SelectedValidity> listOfForfeitValidity = {};

  /// The variable for check if the initialization is done.
  Completer<void> initializeDone = Completer<void>();

  /// Constructs a new [ForfeitViewModel].
  ForfeitViewModel(this._forfeitRepository) {
    _initForfeit().then((_) => initializeDone.complete());
  }

  Future<void> _initForfeit() async {
    final forfeits = await _forfeitRepository.getAllForfeit();
    if (forfeits == null) return;
    listOfForfeit.addAll(forfeits);
    if (forfeits.isNotEmpty) {
      final operator = forfeits.map((e) => e.reference.key).toSet();
      listOfOperatorType.addAll(operator);
      filterListOfForfeit.add(forfeits);
      final validity = forfeits.map((e) => e.validity).toSet();
      listOfForfeitValidity.addAll(
        validity.map(
          (e) => SelectedValidity(
            validity: e,
            isSelected: false,
          ),
        ),
      );
      final category = forfeits.map((e) => e.category).toSet();
      listOfForfeitCategory.addAll(
        category.map(
          (e) => SelectedCategory(
            category: e,
            isSelected: false,
          ),
        ),
      );
    }
  }
}

/// The selected category type.
class SelectedCategory {
  /// The category type.
  final Category category;

  /// Checks if the category is selected.
  bool isSelected;

  /// Constructs a new [SelectedCategory].
  SelectedCategory({
    required this.category,
    this.isSelected = false,
  });
}

/// The selected validity type.
class SelectedValidity {
  /// The Validity type.
  final Validity validity;

  /// Checks if the validity is selected.
  bool isSelected;

  /// Constructs a new [SelectedValidity].
  SelectedValidity({
    required this.validity,
    this.isSelected = false,
  });
}
