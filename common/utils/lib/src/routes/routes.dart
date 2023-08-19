import 'dart:core';

/// This class contain all routes used in our application.
class ApiRoutes {
  /// The base routes.
  final String baseRoute;

  /// The route used to send sms about unit transfer.
  String get sendSmsAboutUnitTransfer => '$baseRoute/api/sms/transfer/unit';

  /// The route used to send sms about balance.
  String get sendSmsAboutBalance => '$baseRoute/api/sms/balance';

  /// The route used to send information about result of unit transfer.
  String get unitTransferResultSubscriptions => '$baseRoute/api/transfer/unit/result';

  /// Constructs an [ApiRoutes].
  ApiRoutes({required this.baseRoute});
}
