import 'dart:async';

import 'package:trans_all_common_models/models.dart';

import '../../data/repository/tranferRepository.dart';

/// The [MoneyTransferViewModel].
class MoneyTransferViewModel {
  final TransferRepository _transferRepository;

  /// The List of supported payment gateway.
  List<PaymentGateways>? supportedPaymentGateway;

  /// Future that complete when all the list of payment gateway and operation
  /// will provided.
  final Completer<void> initializationDone = Completer<void>();

  /// The new [MoneyTransferViewModel].
  MoneyTransferViewModel({required TransferRepository transferRepository})
      : _transferRepository = transferRepository {
    _init().then((_) {
      initializationDone.complete();
    });
  }

  Future<void> _init() async {
    final supportedPayment =
        await _transferRepository.listOfSupportedPaymentGateways();

    // supportedPaymentGateway ??= supportedPayment;
  }
}
