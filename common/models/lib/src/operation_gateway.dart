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

  /// The reference.
  final OperationTransferType reference;

  /// The operator name.
  final String operatorName;

  /// The exactMatchRegex.
  final String exactMatchRegex;

  /// The tolerantRegex.
  final String tolerantRegex;

  /// Constructs a new [OperationGateways] from [Map] object.
  OperationGateways.fromJson(
    Map<String, dynamic> json,
  )   : exactMatchRegex = json[keyExactMatchRegex],
        operatorName = json[keyOperatorName],
        tolerantRegex = json[keyTolerantRegex],
        reference = OperationTransferType.fromKey(json[keyReference]),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyExactMatchRegex: exactMatchRegex,
        keyOperatorName: operatorName,
        keyReference: reference.key,
        keyTolerantRegex: tolerantRegex,
      };
}

/// Represents the available operator of transfer.
class OperationTransferType {
  /// The available OperationTransfer.
  static final _data = <String, OperationTransferType>{
    orangeUnitTransfer.key: orangeUnitTransfer,
    camtelUnitTransfer.key: camtelUnitTransfer,
    mtnUnitTransfer.key: mtnUnitTransfer,
    yoomeeUnitTransfer.key: yoomeeUnitTransfer,
    nexttelUnitTransfer.key: nexttelUnitTransfer,
    unknown.key: unknown,
  };

  /// The orange unit transfer.
  static const orangeUnitTransfer =
      OperationTransferType._('orangeUnitTransfer');

  /// The camtel unit transfer.
  static const camtelUnitTransfer =
      OperationTransferType._('camtelUnitTransfer');

  /// The mtn unit transfer.
  static const mtnUnitTransfer = OperationTransferType._('mtnUnitTransfer');

  /// The mtn unit transfer.
  static const yoomeeUnitTransfer =
      OperationTransferType._('yoomeeUnitTransfer');

  /// The mtn unit transfer.
  static const nexttelUnitTransfer =
      OperationTransferType._('nexttelUnitTransfer');

  /// The unknown operator.
  static const unknown = OperationTransferType._('unknown');

  /// The operator key.
  final String key;

  const OperationTransferType._(this.key);

  /// Constructs a new [OperationTransferType] form [key].
  factory OperationTransferType.fromKey(String key) {
    return _data[key] ?? unknown;
  }
}
