import '../../../config/environement_conf.dart';

/// The application route.
class AppRoute {
  static final String _appBaseUrl = AppEnvironment.appBaseUrl;

  /// The payment gateways route.
  static final paymentGatewaysRoute = '$_appBaseUrl/api/payment/methods/all';

  /// The operator gateways route.
  static final operatorGatewaysRoute = '$_appBaseUrl/api/feature/unit/all';

  /// The create transfer route.
  static final createTransferRoute = '$_appBaseUrl/api/v1/transfer/create';

  /// The get transaction route.
  static final getTheTransaction = '$_appBaseUrl/api/transfer';

  /// The list of forfeit route.
  static final listOfForfeit = '$_appBaseUrl/api/feature/forfeit/all';
}
