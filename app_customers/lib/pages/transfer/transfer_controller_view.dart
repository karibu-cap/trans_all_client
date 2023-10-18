import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' hide Rx;
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/forfeitRepository.dart';
import '../../routes/pages_routes.dart';
import 'transfer_view_model.dart';

/// The transfers controller view.
class TransfersController extends GetxController {
  final TransfersViewModel _transfersViewModel;
  final AppInternationalization _localization;
  final CreditTransactionParams? _localCreditTransaction;
  final ForfeitRepository _forfeitRepository;

  final PageController _pageController;
  final Rx<int> _activePageIndex;

  /// The total pageCount.
  final int pageCount = 2;

  /// The animation controller.
  Rx<AnimationController> animateController =
      Rx<AnimationController>(AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: const _MyTickerProvider(),
  ));

  /// The text form key.
  final formKey = GlobalKey<FormState>();

  /// The payer number text controller.
  TextEditingController paymentTextController;

  /// The current forfeit.
  Rx<Forfeit?> forfeit = Rx<Forfeit?>(null);

  /// The receiver number text controller.
  TextEditingController receiverTextController;

  /// The contact filter text controller.
  TextEditingController contactFilterTextController =
      TextEditingController(text: '');

  /// The button to pay text.
  Rx<String> buttonToPayTextAmount = Rx<String>('');

  /// The amount of the payment text controller.
  TextEditingController amountToPayTextController;

  /// The current reference.
  Rx<String?> reference = Rx<String?>(null);

  /// The current transaction category.
  Rx<Category?> currentCategory = Rx<Category?>(null);

  /// The current operator.
  Rx<OperationGateways?> currentOperation = Rx<OperationGateways?>(null);

  /// The current payment method.
  Rx<PaymentGateways?> currentPaymentMethod = Rx<PaymentGateways?>(null);

  /// The payer number error message.
  Rx<String> paymentNumberErrorMessage = Rx<String>('');

  /// The filter contact list.
  Rx<List<Contact>> filterContactList = Rx<List<Contact>>([]);

  /// The receiver number error message.
  Rx<String> receiverNumberErrorMessage = Rx<String>('');

  /// The amount error message.
  Rx<String> amountErrorMessage = Rx<String>('');

  /// The active page index.
  Rx<int> get activePageIndex => _activePageIndex;

  /// The page controller.
  PageController get pageController => _pageController;

  /// Stream the transfer.
  BehaviorSubject<List<TransferInfo>> get streamPendingTransferInfo =>
      _transfersViewModel.streamPendingTransferInfo;

  /// Stream the contact.
  BehaviorSubject<List<Contact>> get streamOfContact =>
      _transfersViewModel.streamOfContact;

  /// Stream the user buyer contact.
  BehaviorSubject<List<Contact>> get streamOfBuyerContact =>
      _transfersViewModel.streamOfBuyerContact;

  /// Can load the contact.
  ValueNotifier<bool> loadTheContacts = ValueNotifier<bool>(false);

  /// Returns false if the request was successful.
  Rx<bool> get internetError => _transfersViewModel.internetError;

  /// The List of supported payment gateway.
  Rx<List<PaymentGateways>?> get supportedPaymentGateway =>
      _transfersViewModel.supportedPaymentGateway;

  /// The List of supported transfer operation gateway.
  Rx<List<OperationGateways>?> get supportedTransferOperationGateway =>
      _transfersViewModel.supportedTransferOperationGateway;

  /// The local credit transaction.
  CreditTransactionParams? get localCreditTransaction =>
      _localCreditTransaction;

  /// Constructs a new [TransfersController].
  TransfersController({
    required AppInternationalization localization,
    required ForfeitRepository forfeitRepository,
    required TransfersViewModel transfersViewModel,
    CreditTransactionParams? localCreditTransaction,
    int? jumpToIndex,
  })  : paymentTextController = TextEditingController(
          text: localCreditTransaction?.buyerPhoneNumber,
        ),
        receiverTextController = TextEditingController(
          text: localCreditTransaction?.receiverPhoneNumber,
        ),
        amountToPayTextController = TextEditingController(
          text: localCreditTransaction?.amountInXaf == null
              ? ''
              : localCreditTransaction?.amountInXaf.toString(),
        ),
        _localization = localization,
        _forfeitRepository = forfeitRepository,
        _transfersViewModel = transfersViewModel,
        _localCreditTransaction = localCreditTransaction,
        _activePageIndex = Rx(jumpToIndex ?? 0),
        _pageController = PageController(initialPage: jumpToIndex ?? 0);

  @override
  void onClose() {
    super.onClose();
    cleanForm();
  }

  @override
  void onReady() {
    super.onReady();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if (pageController.hasClients &&
          pageController.position.maxScrollExtent > 0) {
        pageController.jumpToPage(activePageIndex.value);
      }

      final creditTransaction = localCreditTransaction;
      if (creditTransaction != null) {
        if (creditTransaction.category != Category.unit.key) {
          final forfeit = _forfeitRepository
              .getForfeitByReference(creditTransaction.featureReference);
          setActiveForfeit(forfeit);
        } else {
          currentCategory.value = Category.unit;
          buttonToPayTextAmount.value = creditTransaction.amountInXaf;
          reference.value = creditTransaction.featureReference;
          forfeit.value = null;
        }
      } else {
        disableForfeit();
      }
    });
  }

  /// Set the active page on the screen.
  void setActivePage(int index) {
    if (index != 0 && index != 1) {
      return;
    }
    activePageIndex.value = index;
    if (pageController.hasClients && pageCount > 1) {
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    }
  }

  /// Sets the current forfeit.
  void setActiveForfeit(Forfeit? currentForfeit) {
    currentCategory.value = currentForfeit?.category;
    reference.value = currentForfeit?.reference;
    amountToPayTextController.clear();
    buttonToPayTextAmount.value = currentForfeit?.amountInXAF.toString() ?? '';
    forfeit.value = currentForfeit;
  }

  /// Disables the current forfeit.
  void disableForfeit() {
    currentCategory.value = Category.unit;
    buttonToPayTextAmount.value = '';
    reference.value = null;
    forfeit.value = null;
  }

  /// Checks if the payer number is valid.
  void isVAlidTolerancePaymentNumber(
    String number,
  ) {
    final currentPayment = currentPaymentMethod.value;
    if (currentPayment == null || number.trim().isEmpty) {
      paymentNumberErrorMessage.value = '';

      return;
    }
    if (number.trim().length > 2 &&
        !RegExp(currentPayment.tolerantRegex).hasMatch(number)) {
      paymentNumberErrorMessage.value = _localization.invalidGatewayNumber
          .trParams({'gateway': currentPayment.displayName});

      return;
    }
    paymentNumberErrorMessage.value = '';

    return;
  }

  /// Checks if the received number is valid.
  bool isValidReceiverNumber() {
    final currentOperator = currentOperation.value;
    if (receiverTextController.text.trim().isEmpty) {
      receiverNumberErrorMessage.value = _localization.errorEmptyNumberField;

      return false;
    }
    if (currentOperator == null) {
      receiverNumberErrorMessage.value = _localization.unsupportedOperator;

      return false;
    }
    if (!RegExp(currentOperator.exactMatchRegex)
        .hasMatch(receiverTextController.text)) {
      receiverNumberErrorMessage.value = _localization.invalidGatewayNumber
          .trParams({'gateway': currentOperator.operatorName.key});

      return false;
    }
    receiverNumberErrorMessage.value = '';

    return true;
  }

  /// Checks if the payer number is valid.
  bool isValidPayerNumber() {
    final currentPayment = currentPaymentMethod.value;
    if (paymentTextController.text.trim().isEmpty) {
      paymentNumberErrorMessage.value = _localization.errorEmptyNumberField;

      return false;
    }
    if (currentPayment == null) {
      paymentNumberErrorMessage.value = _localization.unsupportedPaymentMethod;

      return false;
    }
    if (!RegExp(currentPayment.exactMatchRegex)
        .hasMatch(paymentTextController.text)) {
      paymentNumberErrorMessage.value = _localization.invalidGatewayNumber
          .trParams({'gateway': currentPayment.displayName});

      return false;
    }
    paymentNumberErrorMessage.value = '';

    return true;
  }

  /// Checks if the amount number is valid.
  bool isValidAmount() {
    if (amountToPayTextController.text.trim().isEmpty) {
      amountErrorMessage.value = _localization.errorEmptyAmountField;

      return false;
    }
    final isIntegerNumber =
        RegExp(r'^\d+$').hasMatch(amountToPayTextController.text);
    if (!isIntegerNumber) {
      amountErrorMessage.value = _localization.invalidAmount;

      return false;
    }
    if (int.parse(amountToPayTextController.text) < 100) {
      amountErrorMessage.value =
          '${_localization.amount} ${_localization.lessThan} 100';

      return false;
    }
    amountErrorMessage.value = '';

    return true;
  }

  /// Gets the asset operation image.
  void updateCurrentOperationImageOfNumber(
    String number,
  ) {
    final supportedOperation = supportedTransferOperationGateway.value;
    if (supportedOperation == null) {
      return null;
    }
    if (receiverTextController.text.isEmpty ||
        receiverTextController.text == '6') {
      receiverNumberErrorMessage.value = '';
      currentOperation.value = null;
      reference.value = null;

      return;
    }

    if (forfeit.value != null) {
      final validOperator = supportedOperation.firstWhere(
        (element) =>
            element.operatorName.key == forfeit.value?.operatorName.key,
      );
      if (RegExp(validOperator.tolerantRegex).hasMatch(number)) {
        currentOperation.value = validOperator;
        reference.value = validOperator.reference;
        receiverNumberErrorMessage.value = '';

        return null;
      }
      receiverNumberErrorMessage.value = _localization.invalidGatewayNumber
          .trParams({'gateway': validOperator.operatorName.key});

      return;
    }

    for (final operation in supportedOperation) {
      if (RegExp(operation.tolerantRegex).hasMatch(number)) {
        if (operation.operatorName == Operator.orange) {
          currentOperation.value = operation;
          reference.value = operation.reference;
          receiverNumberErrorMessage.value = '';

          return;
        }
        if (operation.operatorName == Operator.mtn) {
          currentOperation.value = operation;
          reference.value = operation.reference;
          receiverNumberErrorMessage.value = '';

          return;
        }
        if (operation.operatorName == Operator.camtel) {
          currentOperation.value = operation;
          reference.value = operation.reference;
          receiverNumberErrorMessage.value = '';

          return;
        }
      } else {
        receiverNumberErrorMessage.value =
            receiverTextController.text.length > 2
                ? _localization.unsupportedOperator
                : '';
      }
    }
    currentOperation.value = null;
    reference.value = null;

    return null;
  }

  /// Gets the asset payment image.
  void updateCurrentPaymentMethodImageOfNumber(
    String number,
  ) {
    final supportedPayment = supportedPaymentGateway.value;
    if (supportedPayment == null) {
      return null;
    }
    if (paymentTextController.text.isEmpty ||
        paymentTextController.text == '6' ||
        paymentTextController.text == '65') {
      paymentNumberErrorMessage.value = '';
      currentPaymentMethod.value = null;

      return;
    }

    if (!paymentTextController.text.startsWith('6')) {
      paymentNumberErrorMessage.value = _localization.invalidNumber;
      currentPaymentMethod.value = null;

      return;
    }
    if (RegExp('^(?!67|65|68|69)').hasMatch(paymentTextController.text)) {
      paymentNumberErrorMessage.value = _localization.invalidNumber;
      currentPaymentMethod.value = null;

      return;
    }
    for (final payment in supportedPayment) {
      if (RegExp(payment.tolerantRegex).hasMatch(number)) {
        if (payment.id == PaymentId.orangePaymentId) {
          currentPaymentMethod.value = payment;
          paymentNumberErrorMessage.value = '';

          return;
        }
        if (payment.id == PaymentId.mtnPaymentId) {
          currentPaymentMethod.value = payment;
          paymentNumberErrorMessage.value = '';

          return;
        }
      } else {
        paymentNumberErrorMessage.value =
            _localization.unsupportedPaymentMethod;
      }
    }
    currentPaymentMethod.value = null;

    return null;
  }

  /// Updates the amount.
  void updateAmount(String amount) {
    if (amount.isNotEmpty) {
      amountErrorMessage.value = '';
      buttonToPayTextAmount.value = amount;

      return;
    }
    buttonToPayTextAmount.value = '';
  }

  /// Gets payer contact.
  Future<void> updatePayerContact(String phone) async {
    final number =
        phone.replaceAll('+', '').replaceAll('237', '').replaceAll(' ', '');
    paymentTextController.text = number;
    updateCurrentPaymentMethodImageOfNumber(
      number,
    );
  }

  /// Gets receiver contact.
  Future<void> updateReceiverContact(String phone) async {
    final number =
        phone.replaceAll('+', '').replaceAll('237', '').replaceAll(' ', '');
    receiverTextController.text = number;
    updateCurrentOperationImageOfNumber(
      number,
    );
  }

  /// Filters user contact.
  void filterUserContact(String value) {
    if (value.isEmpty) {
      filterContactList.value = streamOfContact.value;

      return;
    }
    filterContactList.value = streamOfContact.value
        .where((user) =>
            user.name.toLowerCase().contains(value.toLowerCase()) ||
            RegExp(value).hasMatch(user.phoneNumber.replaceAll(' ', '')))
        .toList();

    return;
  }

  /// Checks if user can save the number.
  bool canUserSaveNumber() {
    final number = paymentTextController.text;
    if (number.isEmpty) {
      return false;
    }
    final isValidNumber = isValidPayerNumber();
    if (!isValidNumber) {
      return false;
    }
    final saveContactNumber = streamOfBuyerContact.value.firstWhereOrNull(
      (element) =>
          RegExp(number).hasMatch(element.phoneNumber
              .replaceAll('+', '')
              .replaceAll('237', '')
              .replaceAll(' ', '')) &&
          element.isBuyerContact,
    );
    if (saveContactNumber == null) {
      return true;
    }

    return false;
  }

  /// Saves the buyer number as default contact.
  Future<void> saveBuyerNumberAsDefaultBuyer() {
    final number = paymentTextController.text;
    final contact = streamOfContact.value.firstWhereOrNull((element) =>
        RegExp(number).hasMatch(element.phoneNumber
            .replaceAll('+', '')
            .replaceAll('237', '')
            .replaceAll(' ', '')));
    final contactId = clock.now().hashCode.toString();
    if (contact == null) {
      return _transfersViewModel.addBuyerContact(
        contactId,
        Contact.fromJson({
          Contact.keyId: contactId,
          Contact.keyIsBuyerContact: true,
          Contact.keyName: number,
          Contact.keyPhoneNumber: number,
        }),
      );
    }

    return _transfersViewModel.addBuyerContact(
      contact.id,
      Contact.fromJson({
        ...contact.toJson(),
        Contact.keyIsBuyerContact: true,
      }),
    );
  }

  /// Updates the load of contact.
  void updateLoadOfContacts(bool value) {
    loadTheContacts.value = value;
  }

  /// Cleans the form.
  void cleanForm() {
    paymentTextController.clear();
    receiverTextController.clear();
    amountErrorMessage.value = '';
    amountToPayTextController.clear();
    receiverNumberErrorMessage.value = '';
    paymentNumberErrorMessage.value = '';
    buttonToPayTextAmount.value = '';
    currentOperation.value = null;
    currentPaymentMethod.value = null;
    currentCategory.value = null;
    reference.value = null;
    forfeit.value = null;
  }

  /// Retry the transfer.
  void retryTransfer() => _transfersViewModel.retryTransfer();
}

class _MyTickerProvider extends TickerProvider {
  const _MyTickerProvider();

  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}
