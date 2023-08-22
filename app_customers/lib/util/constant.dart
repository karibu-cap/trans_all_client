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
