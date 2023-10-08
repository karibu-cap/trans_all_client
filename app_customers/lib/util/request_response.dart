import 'package:trans_all_common_models/models.dart';

import '../data/database/hive_service.dart';

/// The list of payment gateway response.
class ListPaymentGatewaysResponse {
  /// The list of payment gateway.
  final List<PaymentGateways>? listPaymentGateways;

  /// The error type.
  final RequestError? error;

  /// Constructs a new [ListPaymentGatewaysResponse].
  const ListPaymentGatewaysResponse({
    this.listPaymentGateways,
    this.error,
  });
}

/// The response on createRemoteTransaction.
class CreateRemoteTransactionResponse {
  /// Return the transaction id.
  final String? transactionId;

  /// The error type.
  final String? errorMessage;

  /// Constructs a new [CreateRemoteTransactionResponse].
  const CreateRemoteTransactionResponse({
    this.transactionId,
    this.errorMessage,
  });
}

/// The list of operator gateway response.
class ListOperationGatewaysResponse {
  /// The list of operator gateway.
  final List<OperationGateways>? listOperationGateways;

  /// The error type.
  final RequestError? error;

  /// Constructs a new [ListOperationGatewaysResponse].
  const ListOperationGatewaysResponse({
    this.listOperationGateways,
    this.error,
  });
}
