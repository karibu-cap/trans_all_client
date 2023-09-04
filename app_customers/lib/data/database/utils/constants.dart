import '../../../config/environement_conf.dart';

/// The application route.
class AppRoute {
  static final String _appBaseUrl = AppEnvironment.appBaseUrl;

  /// The payment gateways route.
  static final paymentGatewaysRoute = '$_appBaseUrl/payment/methods/all';

  /// The operator gateways route.
  static final operatorGatewaysRoute = '$_appBaseUrl/transfer/providers/all';

  /// The create transfer route.
  static final createTransferRoute = '$_appBaseUrl/transfer/create';

  /// The get transaction route.
  static final getTheTransaction = '$_appBaseUrl/transfer';

  /// The list of forfeit route.
  static final listOfForfeit = '$_appBaseUrl/forfeit/providers/all';
}
