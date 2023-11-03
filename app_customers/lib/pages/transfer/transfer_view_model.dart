import 'dart:async';

import 'package:get/get.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:rxdart/rxdart.dart' hide Rx;
import 'package:trans_all_common_config/config.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/database/hive_service.dart';
import '../../data/repository/contactRepository.dart';
import '../../data/repository/tranferRepository.dart';
import '../../util/check_transaction.dart';
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
    supportedPaymentGateway.value = null;
    supportedTransferOperationGateway.value = null;

    final supportedPayment =
        await _transferRepository.listOfSupportedPaymentGateways();
    final supportedOperation =
        await _transferRepository.listOfSupportedOperationGateways();

    if ((supportedPayment.error != null &&
            supportedPayment.error == RequestError.internetError) ||
        (supportedOperation.error != null &&
            supportedOperation.error == RequestError.internetError)) {
      supportedPaymentGateway.value ??= [];
      supportedTransferOperationGateway.value ??= [];
      internetError.value = true;
    } else {
      supportedPaymentGateway.value ??=
          _validPaymentGateways(supportedPayment.listPaymentGateways);
      supportedTransferOperationGateway.value ??=
          _validSupportedOperator(supportedOperation.listOperationGateways);
      internetError.value = false;
    }
    updatePendingTransaction();
    retrieveUserBuyerContacts();
    watchTransfer();
    watchContact();

    return;
  }

  List<PaymentGateways>? _validPaymentGateways(
    List<PaymentGateways>? gateways,
  ) {
    if (gateways == null) {
      return null;
    }
    final List<PaymentGateways> newGateways = [];
    final orangeMoneyGateWaysEnabled = RemoteConfig().getBool(
      RemoteConfigKeys.orangeMoneyGatewayEnabled,
    );
    final mtnMomoGateWaysEnabled = RemoteConfig().getBool(
      RemoteConfigKeys.mtnMomoGatewayEnabled,
    );
    final orangeMoney = gateways
        .firstWhereOrNull((element) => element.id == PaymentId.orangePaymentId);
    final mtnMomo = gateways
        .firstWhereOrNull((element) => element.id == PaymentId.mtnPaymentId);
    if (orangeMoney != null && orangeMoneyGateWaysEnabled) {
      newGateways.add(orangeMoney);
    }
    if (mtnMomo != null && mtnMomoGateWaysEnabled) {
      newGateways.add(mtnMomo);
    }

    return newGateways;
  }

  List<OperationGateways>? _validSupportedOperator(
    List<OperationGateways>? operators,
  ) {
    if (operators == null) {
      return null;
    }
    final List<OperationGateways> newSupportedOperators = [];
    final orangeOperatorEnabled = RemoteConfig().getBool(
      RemoteConfigKeys.orangeOperatorEnabled,
    );
    final mtnOperatorEnabled = RemoteConfig().getBool(
      RemoteConfigKeys.mtnOperatorEnabled,
    );
    final camtelOperatorEnabled = RemoteConfig().getBool(
      RemoteConfigKeys.camtelOperatorEnabled,
    );
    final orangeOperator = operators
        .firstWhereOrNull((element) => element.operatorName == Operator.orange);
    final mtnOperator = operators
        .firstWhereOrNull((element) => element.operatorName == Operator.mtn);
    final camtelOperator = operators
        .firstWhereOrNull((element) => element.operatorName == Operator.camtel);

    if (orangeOperator != null && orangeOperatorEnabled) {
      newSupportedOperators.add(orangeOperator);
    }
    if (mtnOperator != null && mtnOperatorEnabled) {
      newSupportedOperators.add(mtnOperator);
    }
    if (camtelOperator != null && camtelOperatorEnabled) {
      newSupportedOperators.add(camtelOperator);
    }

    return newSupportedOperators;
  }

  /// Watch the list of transfer.
  void watchTransfer() {
    _transferRepository
        .streamAllLocalTransaction()
        .listen((event) => updatePendingTransaction());
  }

  /// Watch the list of contact.
  StreamSubscription<List<Contact>> watchContact() {
    return UserContactConfig.userContact.stream.listen(streamOfContact.add);
  }

  /// Updates the pending transaction.
  void updatePendingTransaction() {
    final pendingTransfers = _transferRepository
        .getAllLocalTransaction()
        .where(isPendingTransaction)
        .toList();
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
