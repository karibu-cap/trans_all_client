import '../models.dart';
import 'base_model.dart';

/// Model of money Transfer information.
class TransferInfo extends BaseModel {
  /// The stored key ref for the [id] property.
  static const keyId = 'id';

  /// The stored key ref for the [payments] property.
  static const keyPayments = 'payments';

  /// The stored key ref for the [createdAt] property.
  static const keyCreatedAt = 'createdAt';

  /// The stored key ref for the [updateAt] property.
  static const keyUpdateAt = 'updatedAt';

  /// The stored key ref for the [receiverPhoneNumber] property.
  static const keyReceiverPhoneNumber = 'receiverPhoneNumber';

  /// The stored key ref for the [buyerPhoneNumber] property.
  static const keyBuyerPhoneNumber = 'buyerPhoneNumber';

  /// The stored key ref for the [type] property.
  static const keyType = 'type';

  /// The stored key ref for the [status] property.
  static const keyStatus = 'status';

  /// The stored key ref for the [amountXAF] property.
  static const keyAmountXAF = 'amountXAF';

  /// The stored key ref for the [feature] property.
  static const keyFeature = 'feature';

  /// The stored key ref for the [reason] property.
  static const keyReason = 'reason';

  /// The stored key ref for the [forfeitReference] property.
  static const keyForfeitReference = 'forfeitReference';

  /// The id of transaction.
  final String id;

  /// Date of the refund.
  final DateTime createdAt;

  /// Date of the refund.
  final DateTime? updateAt;

  /// The receiver phone number.
  final String receiverPhoneNumber;

  /// The buyer phone number.
  final String buyerPhoneNumber;

  /// The type of transfer to be used.
  final String? type;

  /// The amount of transfer.
  final num amount;

  /// The status of transfer.
  final TransferStatus status;

  /// The operator gateway.
  final OperationTransferType feature;

  /// The reason in cas of failed transaction.
  final String? reason;

  /// The transfer payment.
  final List<TransTuPayment> payments;

  /// The forfeit reference.
  final String? forfeitReference;

  /// Constructs a new [TransferInfo] from [Map] object.
  TransferInfo.fromJson({
    required Map<String, dynamic> json,
  })  : id = json[keyId],
        createdAt = DateTime.parse(json[keyCreatedAt]).toLocal(),
        updateAt = json[keyUpdateAt] == null
            ? null
            : DateTime.tryParse(json[keyUpdateAt])?.toLocal(),
        receiverPhoneNumber = json[keyReceiverPhoneNumber],
        buyerPhoneNumber = json[keyBuyerPhoneNumber],
        feature = OperationTransferType.fromKey(json[keyFeature]),
        amount = json[keyAmountXAF],
        status = TransferStatus.fromKey(json[keyStatus]),
        type = json[keyType],
        forfeitReference = json[keyForfeitReference],
        reason = json[keyReason],
        payments = _getPayment(json[keyPayments]),
        super.fromJson();

  static List<TransTuPayment> _getPayment(List payments) => payments
      .whereType<Map<String, dynamic>>()
      .map((e) => TransTuPayment.fromJson(json: e))
      .toList();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyId: id,
        keyForfeitReference: forfeitReference,
        keyCreatedAt: DateTime.now().toUtc().toIso8601String(),
        keyUpdateAt: DateTime.now().toUtc().toIso8601String(),
        keyAmountXAF: amount,
        keyStatus: status.key,
        keyFeature: feature.key,
        keyReceiverPhoneNumber: receiverPhoneNumber,
        keyBuyerPhoneNumber: buyerPhoneNumber,
        keyType: type,
        keyReason: reason,
        keyPayments: payments.map((e) => e.toJson()).toList(),
      };

  /// Checks if the transfer is older than a week.
  bool isOlderThanAWeek() {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(createdAt);

    return difference.inDays > 7;
  }
}

/// The transfer information.
class TransTuPayment extends BaseModel {
  /// The stored key ref for the [phoneNumber] property.
  static const keyPhoneNumber = 'phoneNumber';

  /// The stored key ref for the [gateway] property.
  static const keyGateway = 'gateway';

  /// The stored key ref for the [status] property.
  static const keyStatus = 'status';

  /// The receiver phone number.
  final String phoneNumber;

  /// The payment status.
  final PaymentStatus status;

  /// The reference of this gateway.
  final PaymentId gateway;

  /// Constructs a new [TransTuPayment] from [Map] object.
  TransTuPayment.fromJson({
    required Map<String, dynamic> json,
  })  : phoneNumber = json[keyPhoneNumber],
        status = PaymentStatus.fromKey(json[keyStatus]),
        gateway = PaymentId.fromKey(json[keyGateway]),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyStatus: status.key,
        keyPhoneNumber: phoneNumber,
        keyGateway: gateway.key,
      };
}

/// Represents the  transfer status.
class TransferStatus {
  /// The available OperationTransfer.
  static final _data = <String, TransferStatus>{
    waitingRequest.key: waitingRequest,
    requestSend.key: requestSend,
    completed.key: completed,
    succeeded.key: succeeded,
    paymentFailed.key: paymentFailed,
    failed.key: failed,
    unknown.key: unknown,
  };

  /// Waiting completion of payment.
  static const waitingRequest = TransferStatus._('waiting_request');

  /// The request was send.
  static const requestSend = TransferStatus._('request_send');

  /// The payment failed.
  static const paymentFailed = TransferStatus._('payment_failed');

  /// The  transfer was executed successfully.
  static const completed = TransferStatus._('completed');

  /// The  transfer was executed successfully.
  static const succeeded = TransferStatus._('succeeded');

  /// The  code transfer failed.
  static const failed = TransferStatus._('failed');

  /// The unknown operator.
  static const unknown = TransferStatus._('unknown');

  /// The operator key.
  final String key;

  const TransferStatus._(this.key);

  /// Constructs a new [TransferStatus] form [key].
  factory TransferStatus.fromKey(String key) {
    return _data[key] ?? unknown;
  }
}

/// The payment status.
class PaymentStatus {
  /// The available PaymentId.
  static final _data = <String, PaymentStatus>{
    pending.key: pending,
    succeeded.key: succeeded,
    failed.key: failed,
    initialized.key: initialized,
    unknown.key: unknown,
  };

  /// The pending payment.
  static const pending = PaymentStatus._('pending');

  /// The succeeded payment.
  static const succeeded = PaymentStatus._('succeeded');

  /// The initialized payment.
  static const initialized = PaymentStatus._('initialized');

  /// The failed payment.
  static const failed = PaymentStatus._('failed');

  /// The unknown payment.
  static const unknown = PaymentStatus._('unknown');

  /// The operator key.
  final String key;

  const PaymentStatus._(this.key);

  /// Constructs a new [PaymentStatus] form [key].
  factory PaymentStatus.fromKey(String key) {
    return _data[key] ?? unknown;
  }
}
