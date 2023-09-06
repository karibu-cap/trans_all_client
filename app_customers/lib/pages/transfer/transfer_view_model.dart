import 'dart:async';

import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' hide Rx;
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/contactRepository.dart';
import '../../data/repository/tranfersRepository.dart';
import '../../util/user_contact.dart';

/// The TransfersViewModel.
class TransfersViewModel {
  final TransferRepository _transferRepository;
  final ContactRepository _contactRepository;

  /// The list of contact.
  BehaviorSubject<List<Contact>> streamOfContact =
      BehaviorSubject.seeded(UserContactConfig.userContact.value);

  /// The list of buyer contact.
  BehaviorSubject<List<Contact>> streamOfBuyerContact =
      BehaviorSubject.seeded([]);

  /// Stream pending transfer.
  BehaviorSubject<List<TransferInfo>> streamPendingTransferInfo =
      BehaviorSubject.seeded([]);

  /// Returns false if the request was successful.
  Rx<bool> internetError = Rx<bool>(false);

  /// The List of supported payment gateway.
  Rx<List<PaymentGateways>?> supportedPaymentGateway =
      Rx<List<PaymentGateways>?>(null);

  /// The List of supported transfer operation gateway.
  Rx<List<OperationGateways>?> supportedTransferOperationGateway =
      Rx<List<OperationGateways>?>(null);

  /// Constructs a new [TransfersViewModel].
  TransfersViewModel({
    required TransferRepository transferRepository,
    required ContactRepository contactRepository,
  })  : _transferRepository = transferRepository,
        _contactRepository = contactRepository {
    _init();
  }

  Future<void> _init() async {
    internetError.value = false;

    final supportedPayment =
        await _transferRepository.listOfSupportedPaymentGateways();
    final supportedOperation =
        await _transferRepository.listOfSupportedOperationGateways();
    final localOperationGateways =
        await _transferRepository.listOfLocalSupportedOperationGateways();
    final localPaymentGateways =
        await _transferRepository.listOfLocalSupportedPaymentGateways();
    if (supportedPayment.error != null || supportedOperation.error != null) {
      if (localOperationGateways.isEmpty || localPaymentGateways.isEmpty) {
        internetError.value = true;
      } else {
        supportedPaymentGateway.value ??= localPaymentGateways;
        supportedTransferOperationGateway.value ??= localOperationGateways;
        internetError.value = false;
      }
    } else {
      supportedPaymentGateway.value ??= supportedPayment.listPaymentGateways;
      supportedTransferOperationGateway.value ??=
          supportedOperation.listOperationGateways;
      internetError.value = false;
    }
    updatePendingTransaction();
    retrieveUserBuyerContacts();
    watchTransfer();
    watchContact();
    _transferRepository.synchronizeLocalRemoteGateways();

    return;
  }

  /// Watch the list of transfer.
  void watchTransfer() {
    _transferRepository
        .streamAllLocalTransaction()
        .listen((event) => updatePendingTransaction());
  }

  /// Watch the list of contact.
  StreamSubscription<List<Contact>> watchContact() {
    return UserContactConfig.userContact.stream.listen((value) {
      streamOfContact.add(value);
    });
  }

  /// Updates the pending transaction.
  void updatePendingTransaction() {
    final pendingTransfers =
        _transferRepository.getAllLocalTransaction().where((element) {
      if (element.status.key == TransferStatus.completed.key) {
        return false;
      }
      if (element.status.key == TransferStatus.succeeded.key) {
        return false;
      }
      if (element.payments.last.status.key == PaymentStatus.failed.key) {
        return false;
      }

      return true;
    }).toList();
    streamPendingTransferInfo.add(pendingTransfers);
  }

  /// Adds new buyer contact.
  Future<void> addBuyerContact(String contactId, Contact newContact) async {
    await _contactRepository.addUserBuyerContact(
      newContact,
      contactId,
    );
    retrieveUserBuyerContacts();
  }

  /// Retrieve the buyers contact.
  void retrieveUserBuyerContacts() {
    final contacts = _contactRepository.getAllLocalBuyerContact();
    streamOfBuyerContact.add(contacts.toList());

    return;
  }

  /// Retry the transfer.
  void retryTransfer() => _init();
}
