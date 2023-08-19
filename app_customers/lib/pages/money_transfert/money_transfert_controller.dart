import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import 'money_transfert_view_model.dart';

/// The [MoneyTransferViewModel].
class MoneyTransferController extends GetxController {
  final MoneyTransferViewModel _moneyTransfersViewModel;

  /// The text form key.
  final formKey = GlobalKey<FormState>();

  /// The payer number text controller.
  final paymentNumberTextController = TextEditingController(text: '');

  /// The receiver number text controller.
  final receiverNumberTextController = TextEditingController(text: '');

  /// The amount of the payment text controller.
  final amountOfTransferTextController = TextEditingController(text: '');

  /// The payer number error message.
  Rx<String> paymentNumberErrorMessage = ''.obs;

  /// The receiver number error message.
  Rx<String> receiverNumberErrorMessage = ''.obs;

  /// The amount error message.
  Rx<String> amountErrorMessage = ''.obs;

  /// The current payer gateways number.
  Rx<PaymentGateways?> currentPayerGateway = Rx(null);

  /// The current receiver gateway number.
  Rx<PaymentGateways?> currentReceiverGateway = Rx(null);

  /// The List of supported payment gateway.
  List<PaymentGateways>? get supportedPaymentGateway =>
      _moneyTransfersViewModel.supportedPaymentGateway;

  /// Future that complete when all the list of payment gateway and operation
  /// will provided.
  Completer<void> get initializationDone =>
      _moneyTransfersViewModel.initializationDone;

  /// Constructor of new [MoneyTransferController].
  MoneyTransferController(this._moneyTransfersViewModel);

  /// Checks if the receiver number is valid.
  void isValidReceiverNumber() {
    final localization = Get.find<AppInternationalization>();

    if (receiverNumberTextController.text.isEmpty) {
      receiverNumberErrorMessage.value = localization.errorEmptyNumberField;

      return;
    }
    if (!isValidNumber(
      receiverNumberTextController.text,
      currentReceiverGateway.value,
    )) {
      receiverNumberErrorMessage.value =
          '${localization.number}  ${localization.invalid}';

      return;
    }

    receiverNumberErrorMessage.value = '';

    return;
  }

  /// Checks if the payer number is valid.
  void isValidPayerNumber() {
    final localization = Get.find<AppInternationalization>();

    if (paymentNumberTextController.text.isEmpty) {
      paymentNumberErrorMessage.value = localization.errorEmptyNumberField;

      return;
    }
    if (!isValidNumber(
      paymentNumberTextController.text,
      currentPayerGateway.value,
    )) {
      paymentNumberErrorMessage.value =
          '${localization.number} ${localization.invalid}';

      return;
    }
    paymentNumberErrorMessage.value = '';

    return;
  }

  /// Permutes the number.
  void changeTheNumber() {
    final oldReceiveNumber = receiverNumberTextController.text;
    final oldReceiveGateway = currentReceiverGateway.value;
    receiverNumberTextController.text = paymentNumberTextController.text;
    paymentNumberTextController.text = oldReceiveNumber;
    currentReceiverGateway.value = currentPayerGateway.value;
    currentPayerGateway.value = oldReceiveGateway;
  }

  /// Checks if the number is valid.
  bool isValidNumber(String value, PaymentGateways? gateways) {
    if (gateways == null) {
      return false;
    }
    if (RegExp(gateways.exactMatchRegex).hasMatch(value)) {
      return true;
    }

    return false;
  }

  /// Checks if the amount number is valid.
  void isValidAmount() {
    final localization = Get.find<AppInternationalization>();

    if (amountOfTransferTextController.text.isEmpty) {
      amountErrorMessage.value = localization.errorEmptyAmountField;

      return;
    }
    if (int.parse(amountOfTransferTextController.text) < 100) {
      amountErrorMessage.value =
          '${localization.amount} ${localization.lessThan} 100';

      return;
    }
    amountErrorMessage.value = '';

    return;
  }

  /// Gets the asset current payer number image.
  void updateCurrentPayerNumberImage(String number) {
    final supportedPayment = supportedPaymentGateway;
    if (supportedPayment == null) {
      return null;
    }
    if (paymentNumberTextController.text.isNotEmpty) {
      paymentNumberErrorMessage.value = '';
    }
    for (final payment in supportedPayment) {
      if (RegExp(payment.tolerantRegex).hasMatch(number)) {
        if (payment.id == PaymentId.mtnPaymentId) {
          currentPayerGateway.value = payment;

          return;
        }
        if (payment.id == PaymentId.orangePaymentId) {
          currentPayerGateway.value = payment;

          return;
        }
      }
    }
    currentPayerGateway.value = null;

    return null;
  }

  /// Gets the asset current receiver number image.
  void updateCurrentReceiverNumberImage(String number) {
    final supportedPayment = supportedPaymentGateway;
    if (supportedPayment == null) {
      return null;
    }
    if (receiverNumberTextController.text.isNotEmpty) {
      receiverNumberErrorMessage.value = '';
    }
    for (final payment in supportedPayment) {
      if (RegExp(payment.tolerantRegex).hasMatch(number)) {
        if (payment.id == PaymentId.mtnPaymentId) {
          currentReceiverGateway.value = payment;

          return;
        }
        if (payment.id == PaymentId.orangePaymentId) {
          currentReceiverGateway.value = payment;

          return;
        }
      }
    }
    currentReceiverGateway.value = null;

    return null;
  }

  /// Gets payer contact.
  Future<void> getPayerContact() async {
    // final contactPermission = await FlutterContactPicker.requestPermission();
    // if (contactPermission) {
    //   final PhoneContact contact =
    //       await FlutterContactPicker.pickPhoneContact();
    //   final contactNumber = contact.phoneNumber?.number;
    //   if (contactNumber != null) {
    //     final number = contactNumber
    //         .replaceAll('+', '')
    //         .replaceAll('237', '')
    //         .replaceAll(' ', '');
    //     paymentNumberTextController.text = number;
    //     updateCurrentPayerNumberImage(number);
    //   }
    // }
  }

  /// Gets receiver contact.
  Future<void> getReceiverContact() async {
    // final contactPermission = await FlutterContactPicker.requestPermission();
    // if (contactPermission) {
    //   final PhoneContact contact =
    //       await FlutterContactPicker.pickPhoneContact();
    //   final contactNumber = contact.phoneNumber?.number;
    //   if (contactNumber != null) {
    //     final number = contactNumber
    //         .replaceAll('+', '')
    //         .replaceAll('237', '')
    //         .replaceAll(' ', '');
    //     receiverNumberTextController.text = number;
    //     updateCurrentReceiverNumberImage(number);
    //   }
    // }
  }
}
