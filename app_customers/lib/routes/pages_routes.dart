/// The pages routes.
abstract class PagesRoutes {
  /// The  transfer route.
  /// eg: http:localhost:8080/credit-transaction?forfeitId='123'.
  static final creditTransaction = _CreditTransactionRoute();

  /// The  transfer route.
  /// eg: http:localhost:8080/forfeit.
  static final forfeit = _Forfeit();

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
      '/buy-airtime?${creditTransactionParams.encodeMap()}';
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

class _Forfeit extends PagesRoutesNoParams {
  @override
  String get pattern => '/forfeit';
}

class _InitTransferRoute
    extends PagesRoutesWithParams<CreditTransactionParams> {
  @override
  String get pattern => '/init-transaction';

  @override
  String create(CreditTransactionParams initCreditTransactionParams) =>
      '/init-transaction?${initCreditTransactionParams.encodeMap()}';
}

/// The init transaction route parameters.
class CreditTransactionParams {
  /// The parameter key for [buyerPhoneNumber].
  static const String keyParamBuyerPhoneNumber = 'buyerPhoneNumber';

  /// The parameter key for [receiverPhoneNumber].
  static const String keyParamReceiverPhoneNumber = 'receiverPhoneNumber';

  /// The parameter key for [amountInXaf].
  static const String keyParamAmountInXaf = 'amountInXaf';

  /// The parameter key for [featureReference].
  static const String keyParamFeatureReference = 'featureReference';

  /// The parameter key for [category].
  static const String keyParamCategory = 'category';

  /// The parameter key for [category].
  static const String keyParamOperatorName = 'operatorName';

  /// The parameter key for [buyerGatewayId].
  static const String keyParamBuyerGatewayId = 'buyerGatewayId';

  /// The parameter key for [transactionId].
  static const String keyParamTransactionId = 'transactionId';

  /// The transaction id.
  final String? transactionId;

  /// The buyerPhoneNumber parameter.
  final String buyerPhoneNumber;

  /// The receiverNumber parameter.
  final String receiverPhoneNumber;

  /// The amountToPay parameter.
  final String amountInXaf;

  /// The featureReference parameter.
  final String featureReference;

  /// The transaction operator name.
  final String operatorName;

  /// The transaction category name.
  final String category;

  /// The buyerGatewayId parameter.
  final String buyerGatewayId;

  /// Constructs a new instance of the orders parameters.
  CreditTransactionParams({
    required this.buyerPhoneNumber,
    required this.receiverPhoneNumber,
    required this.amountInXaf,
    required this.buyerGatewayId,
    required this.featureReference,
    required this.category,
    required this.operatorName,
    this.transactionId,
  });

  /// The encode parameters to a string.
  String encodeMap() {
    return toMap()
        .entries
        .map((entry) => '${entry.key}=${entry.value ?? ''}')
        .join('&');
  }

  /// Converts the parameters to a string.
  Map<String, String?> toMap() => {
        keyParamAmountInXaf: amountInXaf,
        keyParamBuyerGatewayId: buyerGatewayId,
        keyParamFeatureReference: featureReference,
        keyParamBuyerPhoneNumber: buyerPhoneNumber,
        keyParamTransactionId: transactionId,
        keyParamReceiverPhoneNumber: receiverPhoneNumber,
        keyParamCategory: category,
        keyParamOperatorName: operatorName,
      };
}
