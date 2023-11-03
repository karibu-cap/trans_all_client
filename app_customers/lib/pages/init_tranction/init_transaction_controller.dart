import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/contactRepository.dart';
import '../../routes/pages_routes.dart';
import 'init_transaction_view_model.dart';

/// The new initialization controller.
class InitTransactionController extends GetxController {
  final InitTransactionViewModel _model;
  final ContactRepository _contactRepository;

  /// Returns the error message.
  Rx<String?> get errorMessage => _model.errorMessage;

  /// The credit transaction.
  CreditTransactionParams get creditTransactionParams =>
      _model.creditTransactionParams;

  /// The current forfeit to transfers.
  Rx<Forfeit?>? get forfeit => _model.forfeit;

  /// The transaction id.
  Rx<String?> get transactionId => _model.transactionId;

  /// The number who make the payment.
  Rx<String?> get buyerPhoneNumber => _model.buyerPhoneNumber;

  /// The buyer gateway.
  Rx<String?> get buyerGatewayId => _model.buyerGatewayId;

  /// The receiver number.
  Rx<String?> get receiverPhoneNumber => _model.receiverPhoneNumber;

  /// The amount of transaction.
  Rx<num?> get amountToPay => _model.amountToPay;

  /// The loading state.
  Rx<LoadingState> get loadingState => _model.loadingState;

  /// The transfer progress indicator.
  ValueNotifier<double> get transferProgress => _model.transferProgress;

  /// Completes the transfer state.
  Completer<void> get transferCompleter => _model.transferCompleter;

  /// Creates new [InitTransactionController].
  InitTransactionController(
    this._model,
    this._contactRepository,
  );

  /// Initialize the transaction.
  Future<void> initializationTransaction() async {
    transactionId.value = null;
    loadingState.value = LoadingState.load;
    transferProgress.value = 1;
    await _model.initTransfer();
  }

  /// Gets the user name.
  String getUserName(String phoneNumber) {
    final listOfContact = _contactRepository.getAllLocalContact();
    if (listOfContact.isEmpty) {
      return phoneNumber;
    }
    final contact = listOfContact
        .where((element) => RegExp(phoneNumber).hasMatch(element.phoneNumber
            .replaceAll('+', '')
            .replaceAll('237', '')
            .replaceAll(' ', '')))
        .toList();
    if (contact.isNotEmpty) {
      final newContact = contact.firstWhereOrNull((element) => !RegExp(r'^\d+$')
          .hasMatch(element.name
              .replaceAll('+', '')
              .replaceAll('237', '')
              .replaceAll(' ', '')));

      return newContact != null
          ? '${newContact.name}\n($phoneNumber)'
          : phoneNumber;
    }

    return phoneNumber;
  }
}

bool _goPaymentStatusHierarchy(
  PaymentStatus oldStatus,
  PaymentStatus newStatus,
) {
  if (newStatus == oldStatus) {
    return true;
  }
  if (newStatus == PaymentStatus.initialized) {
    return oldStatus == PaymentStatus.pending;
  }
  if (newStatus == PaymentStatus.failed) {
    return oldStatus == PaymentStatus.pending ||
        oldStatus == PaymentStatus.initialized;
  }
  if (newStatus == PaymentStatus.succeeded) {
    return oldStatus == PaymentStatus.initialized;
  }

  return false;
}

bool _goTransfersStatusHierarchy(
  TransferStatus oldStatus,
  TransferStatus newStatus,
) {
  if (newStatus == oldStatus) {
    return true;
  }
  if (newStatus == TransferStatus.requestSend) {
    return oldStatus == TransferStatus.waitingRequest;
  }
  if (newStatus == TransferStatus.completed ||
      newStatus == TransferStatus.succeeded) {
    return oldStatus == TransferStatus.requestSend ||
        oldStatus == TransferStatus.waitingRequest;
  }
  if (newStatus == TransferStatus.failed) {
    return oldStatus == TransferStatus.requestSend ||
        oldStatus == TransferStatus.waitingRequest;
  }

  return false;
}
