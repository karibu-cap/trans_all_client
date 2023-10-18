import '../models.dart';
import 'base_model.dart';

/// Model of OperationGateways.
class OperationGateways extends BaseModel {
  /// The stored key ref for the [reference] property.
  static const keyReference = 'reference';

  /// The stored key ref for the [operatorName] property.
  static const keyOperatorName = 'operatorName';

  /// The stored key ref for the [exactMatchRegex] property.
  static const keyExactMatchRegex = 'exactMatchRegex';

  /// The stored key ref for the [tolerantRegex] property.
  static const keyTolerantRegex = 'tolerantRegex';

  /// The stored key ref for the [category] property.
  static const keyCategory = 'category';

  /// The reference.
  final String reference;

  /// The operator name.
  final Operator operatorName;

  /// The exactMatchRegex.
  final String exactMatchRegex;

  /// The tolerantRegex.
  final String tolerantRegex;

  /// The category operation.
  final Category category;

  /// Constructs a new [OperationGateways] from [Map] object.
  OperationGateways.fromJson(
    Map<String, dynamic> json,
  )   : exactMatchRegex = json[keyExactMatchRegex],
        operatorName = Operator.fromKey(json[keyOperatorName]),
        category = Category.fromKey(json[keyCategory]),
        tolerantRegex = json[keyTolerantRegex],
        reference = json[keyReference],
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyExactMatchRegex: exactMatchRegex,
        keyOperatorName: operatorName.key,
        keyCategory: category.key,
        keyReference: reference,
        keyTolerantRegex: tolerantRegex,
      };
}
