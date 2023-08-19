import 'dart:async';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/contactRepository.dart';
import '../../data/repository/tranfersRepository.dart';
import 'init_transaction_view_model.dart';

/// The new initialization controller.
class InitTransactionController extends GetxController {
  final InitTransactionViewModel _model;
  final ContactRepository _contactRepository;
  final TransferRepository _transferRepository;
  final _logger = Logger('InitTransactionController');

  /// Returns false if the request was successful.
  Rx<bool> get internetError => _model.internetError;

  /// The transaction id.
  Rx<String?> get transactionId => _model.transactionId;

  /// The loading state.
  Rx<LoadingState> get loadingState => _model.loadingState;

  /// Creates new [InitTransactionController].
  InitTransactionController(
    this._model,
    this._contactRepository,
    this._transferRepository,
  );

  /// Initialize the transaction.
  Future<void> initializationTransaction() async {
    transactionId.value = null;
    loadingState.value = LoadingState.loading;
    await _model.init();
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

  /// Watch the transaction with id.
  void watchTransaction() {
    final transferId = transactionId.value;
    if (transferId == null ||
        transferId.isEmpty ||
        loadingState.value == LoadingState.failed ||
        loadingState.value == LoadingState.succeeded) {
      return;
    }
    _transferRepository.streamAllLocalTransaction().listen((event) async {
      final transfertId = transactionId.value;
      if (transfertId == null ||
          transfertId.isEmpty ||
          loadingState.value == LoadingState.failed ||
          loadingState.value == LoadingState.succeeded) {
        return;
      }
      final TransferInfo? transferInfo =
          _transferRepository.getLocalTransaction(transfertId);
      _logger.info(
        'Transfer $transactionId retrieve with status: ${transferInfo?.status.key}',
      );
      if (transferInfo == null) {
        return;
      }
      _model.updateLoadingState(transferInfo);
    });

    return;
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
