import 'package:trans_all_common_models/models.dart';

/// Retrieve operator name by feature.
String retrieveOperatorName(OperationTransferType feature) {
  switch (feature) {
    case OperationTransferType.orangeUnitTransfer:
      return Operator.orange.key;
    case OperationTransferType.mtnUnitTransfer:
      return Operator.mtn.key;
    case OperationTransferType.camtelUnitTransfer:
      return Operator.camtel.key;
    default:
      return Operator.unknown.key;
  }
}
