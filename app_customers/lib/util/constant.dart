/// The local database constant.
class Constant {
  /// The credit transaction table name.
  static const String creditTransactionTable = 'credit_transaction';

  /// The credit operator table name.
  static const String operatorTable = 'operator';

  /// The credit payment gateways table name.
  static const String paymentGatewaysTable = 'payment_gateways';

  /// The forfeit table name.
  static const String forfeitTable = 'forfeit';

  /// The contact table name.
  static const String contactTable = 'contacts';

  /// The default buyer contact table name.
  static const String defaultBuyerContactsTable = 'defaultBuyerContacts';

  /// The amount name.
  static const String amountToPay = 'amountToPay';

  /// The number name.
  static const String number = 'number';

  /// The code number for validate a payment.
  static const String code = 'code';
}

/// The background tack name.
class BackgroundTask {
  /// The update airtime transaction function name.
  static const String updatePaymentStatusSchedule =
      'updatePaymentStatusSchedule';
}

/// The application currency.
class DefaultCurrency {
  /// The xaf currency.
  static const xaf = 'XAF';
}

/// The animation asset .
class AnimationAsset {
  /// The loading animation asset.
  static const loading = 'assets/icons/loading.json';

  /// The failed transaction asset.
  static const failedTransaction = 'assets/icons/failed_transaction.json';

  /// The success transaction asset.
  static const successTransaction = 'assets/icons/second_success.json';

  /// The success transaction asset.
  static const firstSuccess = 'assets/icons/first_success.json';

  /// The noItem asset.
  static const noItem = 'assets/icons/no_item.json';
}

/// The language code.
class LanguageCode {
  /// The english language.
  static const en = 'en';

  /// The french language.
  static const fr = 'fr';
}
