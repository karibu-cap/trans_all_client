import 'base_model.dart';

/// Model of PaymentGateways.
class PaymentGateways extends BaseModel {
  /// The stored key ref for the [id] property.
  static const keyId = 'id';

  /// The stored key ref for the [displayName] property.
  static const keyDisplayName = 'displayName';

  /// The stored key ref for the [thumbnailUrl] property.
  static const keyThumbnailUrl = 'thumbnailUrl';

  /// The stored key ref for the [exactMatchRegex] property.
  static const keyExactMatchRegex = 'exactMatchRegex';

  /// The stored key ref for the [tolerantRegex] property.
  static const keyTolerantRegex = 'tolerantRegex';

  /// The payment id.
  final PaymentId id;

  /// The display name.
  final String displayName;

  /// The thumbnailUrl.
  final String? thumbnailUrl;

  /// The exactMatchRegex.
  final String exactMatchRegex;

  /// The tolerantRegex.
  final String tolerantRegex;

  /// Constructs a new [PaymentGateways] from [Map] object.
  PaymentGateways.fromJson(
    Map<String, dynamic> json,
  )   : exactMatchRegex = json[keyExactMatchRegex],
        displayName = json[keyDisplayName],
        tolerantRegex = json[keyTolerantRegex],
        thumbnailUrl = json[keyThumbnailUrl],
        id = PaymentId.fromKey(json[keyId]),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyId: id.key,
        keyExactMatchRegex: exactMatchRegex,
        keyDisplayName: displayName,
        keyThumbnailUrl: thumbnailUrl,
        keyTolerantRegex: tolerantRegex,
      };
}

/// Represents the available payment id.
class PaymentId {
  /// The available PaymentId.
  static final _data = <String, PaymentId>{
    orangePaymentId.key: orangePaymentId,
    mtnPaymentId.key: mtnPaymentId,
    unknown.key: unknown,
  };

  /// The orange payment id.
  static const orangePaymentId = PaymentId._('OM');

  /// The mtn payment id.
  static const mtnPaymentId = PaymentId._('MOMO');

  /// The unknown payment.
  static const unknown = PaymentId._('unknown');

  /// The operator key.
  final String key;

  const PaymentId._(this.key);

  /// Constructs a new [PaymentId] form [key].
  factory PaymentId.fromKey(String key) {
    return _data[key] ?? unknown;
  }
}
