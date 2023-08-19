/// The pages routes.
abstract class PagesRoutes {
  /// The  transfer route.
  /// eg: http:localhost:8080/credit-transaction.
  static final creditTransaction = _CreditTransactionRoute();

  /// The  transfer route.
  /// eg: http:localhost:8080/money-transaction.
  static final moneyTransaction = _MoneyTransactionRoute();

  /// The  transfer historic route.
  /// eg: http:localhost:8080/transfers.
  static final historic = _HistoricRoute();

  /// The  welcome route.
  /// eg: http:localhost:8080/welcome.
  static final welcome = _WelcomeRoute();

  /// The  transfer process route.
  /// eg: http:localhost:8080/transfers/init.
  static final initTransaction = _InitTransferRoute();
}

/// Interface for routes with parameters.
abstract class PagesRoutesWithParams<T> {
  /// Returns the pattern URL associated with the route.
  String get pattern;

  /// Creates the route URL.
  String create(T parameters);
}

/// Interface for routes without parameters.
abstract class PagesRoutesNoParams {
  /// Returns the pattern URL associated with the route.
  String get pattern;

  /// Creates the route URL.
  String create() => pattern;
}

class _CreditTransactionRoute
    extends PagesRoutesWithParams<CreditTransactionParams> {
  @override
  String get pattern => '/buy-airtime';

  @override
  String create(CreditTransactionParams creditTransactionParams) =>
      '/buy-airtime?${CreditTransactionParams.keyParamBuyerGatewayId}=${creditTransactionParams.buyerGatewayId}&${CreditTransactionParams.keyParamReceiverOperator}=${creditTransactionParams.receiverOperator}&${CreditTransactionParams.keyParamFeatureReference}=${creditTransactionParams.featureReference}&${CreditTransactionParams.keyParamBuyerPhoneNumber}=${creditTransactionParams.buyerPhoneNumber}&${CreditTransactionParams.keyParamReceiverPhoneNumber}=${creditTransactionParams.receiverPhoneNumber}&${CreditTransactionParams.keyParamAmountToPay}=${creditTransactionParams.amountToPay}';
}

class _MoneyTransactionRoute extends PagesRoutesNoParams {
  @override
  String get pattern => '/money-transaction';
}

class _HistoricRoute extends PagesRoutesNoParams {
  @override
  String get pattern => '/historic';
}

class _WelcomeRoute extends PagesRoutesNoParams {
  @override
  String get pattern => '/welcome';
}

class _InitTransferRoute
    extends PagesRoutesWithParams<CreditTransactionParams> {
  @override
  String get pattern => '/init-transaction';

  @override
  String create(CreditTransactionParams initCreditTransactionParams) =>
      '/init-transaction?${CreditTransactionParams.keyParamTransactionId}=${initCreditTransactionParams.transactionId}&${CreditTransactionParams.keyParamBuyerGatewayId}=${initCreditTransactionParams.buyerGatewayId}&${CreditTransactionParams.keyParamReceiverOperator}=${initCreditTransactionParams.receiverOperator}&${CreditTransactionParams.keyParamFeatureReference}=${initCreditTransactionParams.featureReference}&${CreditTransactionParams.keyParamBuyerPhoneNumber}=${initCreditTransactionParams.buyerPhoneNumber}&${CreditTransactionParams.keyParamReceiverPhoneNumber}=${initCreditTransactionParams.receiverPhoneNumber}&${CreditTransactionParams.keyParamAmountToPay}=${initCreditTransactionParams.amountToPay}';
}

/// The init transaction route parameters.
class CreditTransactionParams {
  /// The parameter key for [buyerPhoneNumber].
  static const String keyParamBuyerPhoneNumber = 'buyerPhoneNumber';

  /// The parameter key for [receiverPhoneNumber].
  static const String keyParamReceiverPhoneNumber = 'receiverPhoneNumber';

  /// The parameter key for [amountToPay].
  static const String keyParamAmountToPay = 'amountToPay';

  /// The parameter key for [featureReference].
  static const String keyParamFeatureReference = 'featureReference';

  /// The parameter key for [buyerGatewayId].
  static const String keyParamBuyerGatewayId = 'buyerGatewayId';

  /// The parameter key for [receiverOperator].
  static const String keyParamReceiverOperator = 'receiverOperator';

  /// The parameter key for [transactionId].
  static const String keyParamTransactionId = 'transactionId';

  /// The transaction id.
  final String? transactionId;

  /// The buyerPhoneNumber parameter.
  final String buyerPhoneNumber;

  /// The receiverNumber parameter.
  final String receiverPhoneNumber;

  /// The amountToPay parameter.
  final String amountToPay;

  /// The featureReference parameter.
  final String featureReference;

  /// The buyerGatewayId parameter.
  final String buyerGatewayId;

  /// The receiverOperator parameter.
  final String receiverOperator;

  /// Constructs a new instance of the orders parameters.
  CreditTransactionParams({
    required this.buyerPhoneNumber,
    required this.receiverPhoneNumber,
    required this.amountToPay,
    required this.buyerGatewayId,
    required this.featureReference,
    required this.receiverOperator,
    this.transactionId,
  });
}
