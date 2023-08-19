

import 'package:trans_all_common_models/models.dart';

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
  final RequestError? error;

  /// Constructs a new [CreateRemoteTransactionResponse].
  const CreateRemoteTransactionResponse({
    this.transactionId,
    this.error,
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

/// The request error.
class RequestError {
  /// The available RequestError.
  static final _data = <String, RequestError>{
    internetError.key: internetError,
    unknown.key: unknown,
  };

  /// The orange payment id.
  static const internetError = RequestError._('Internet error');

  /// The unknown payment.
  static const unknown = RequestError._('unknown');

  /// The operator key.
  final String key;

  const RequestError._(this.key);

  /// Constructs a new [RequestError] form [key].
  factory RequestError.fromKey(String key) {
    return _data[key] ?? unknown;
  }
}
