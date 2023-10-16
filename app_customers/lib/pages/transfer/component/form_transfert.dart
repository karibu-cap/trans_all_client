import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:karibu_capital_core_utils/utils.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trans_all_common_config/config.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_router.dart';
import '../../../routes/pages_routes.dart';
import '../../../themes/app_button_styles.dart';
import '../../../themes/app_colors.dart';
import '../../../util/constant.dart';
import '../../../util/preferences_keys.dart';
import '../../../widgets/alert_box.dart';
import '../../../widgets/m_tooltip.dart';
import '../../../widgets/oparator_icon.dart';
import '../../../widgets/text_fiel_with_auto_completion.dart/auto_complete_text_field.dart';
import '../../../widgets/text_form_field.dart';
import '../transfer_controller_view.dart';
import 'contact_view.dart';
import 'default_buyer_contact.dart';

/// The form transfer view.
class FormTransfer extends StatelessWidget {
  /// The contacts list.
  final List<Contact> contacts;

  /// Constructor of new [FormTransfer].
  const FormTransfer(this.contacts);

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final controller = Get.find<TransfersController>();
    final border = Radius.circular(25.0);
    final theme = Theme.of(context);

    void alertToSentRequestBySms() {
      final mtnNumberForSMSAirtimeTransaction = RemoteConfig().getString(
        RemoteConfigKeys.mtnNumberForSmsTransaction,
      );

      final ValueNotifier<String> defaultReceiverSmsNumber =
          ValueNotifier(mtnNumberForSMSAirtimeTransaction);

      showAlertBoxView(
        context: context,
        icon: Icon(
          Icons.wifi_tethering_error,
          size: 30,
        ),
        topBackgroundColor: AppColors.orange,
        negativeBtnText: localization.noThank,
        positiveBtnText: localization.yes,
        positiveBtnPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          final String message =
              'Send ${controller.amountToPayTextController.text} from ${controller.paymentTextController.text} to ${controller.receiverTextController.text}';

          final uri = Platform.isAndroid
              ? 'sms:${defaultReceiverSmsNumber.value}?body=$message'
              : Platform.isIOS
                  ? 'sms:${defaultReceiverSmsNumber.value}&body=$message'
                  : null;

          if (uri != null) {
            await launchUrl(
              Uri.parse(uri),
              mode: LaunchMode.externalApplication,
            );
          }
        },
        title: localization.noInternetConnection,
        content: ValueListenableBuilder(
          valueListenable: defaultReceiverSmsNumber,
          builder: (context, value, child) => _AlertMessageContent(
            controller,
            value,
            (value) => defaultReceiverSmsNumber.value = value,
          ),
        ),
      );
    }

    void alertToSentAlertBox() {
      showAlertBoxView(
        context: context,
        icon: Icon(
          Icons.wifi_tethering_error,
          size: 30,
        ),
        topBackgroundColor: theme.colorScheme.errorContainer,
        positiveBtnText: localization.ok,
        positiveBtnPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
        },
        title: localization.noInternetConnection,
        content: SizedBox(),
      );
    }

    /// Checks the form.
    Future<void> checksTheForm() async {
      final pref = await SharedPreferences.getInstance();
      final isConnected = pref.getBool(PreferencesKeys.isConnected) ?? true;
      final paymentSelected = controller.currentPaymentMethod.value;
      final currentOperation = controller.currentOperation.value;
      final isValidPayerNumber = controller.isValidPayerNumber();
      final isValidReceiverNumber = controller.isValidReceiverNumber();
      final forfeit = controller.forfeit;
      final isValidAmount =
          forfeit.value == null ? controller.isValidAmount() : true;
      if (!isValidPayerNumber ||
          !isValidReceiverNumber ||
          !isValidAmount ||
          paymentSelected == null ||
          currentOperation == null) {
        return;
      }
      if (!isConnected) {
        final enableSmsTransactionAirtime = RemoteConfig().getBool(
          RemoteConfigKeys.userCanRequestAirtimeBySms,
        );
        enableSmsTransactionAirtime
            ? alertToSentRequestBySms()
            : alertToSentAlertBox();

        return;
      }

      final transactionParam = CreditTransactionParams(
        buyerPhoneNumber: controller.paymentTextController.text,
        receiverPhoneNumber: controller.receiverTextController.text,
        amountInXaf: forfeit.value != null
            ? forfeit.value?.amountInXAF.toString()
            : controller.amountToPayTextController.value.text,
        buyerGatewayId: paymentSelected.id.key,
        featureReference: currentOperation.reference.key,
        forfeitReference: forfeit.value?.reference,
      );

      AppRouter.push(
        context,
        PagesRoutes.initTransaction.create(transactionParam),
      );
      controller.cleanForm();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.localCreditTransaction != null) {
        controller.updateCurrentOperationImageOfNumber(
          controller.receiverTextController.text,
        );
        controller.updateCurrentPaymentMethodImageOfNumber(
          controller.paymentTextController.text,
        );
      }
    });

    final featureForfeitEnabled = RemoteConfig().getBool(
      RemoteConfigKeys.featureForfeitEnable,
    );

    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoCompleteTextField(
              layerLink: LayerLink(),
              listOfContactSuggestion: contacts,
              key: Key(localization.payLabelTextNumber),
              onChanged: controller.updateCurrentPaymentMethodImageOfNumber,
              onPressToSuggestion: (contact) =>
                  controller.updatePayerContact(contact.phoneNumber),
              errorMessage: controller.paymentNumberErrorMessage.value,
              textController: controller.paymentTextController,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OperatorIcon(
                  operatorType: controller.currentPaymentMethod.value?.id.key ??
                      PaymentId.unknown.key,
                ),
              ),
              labelText: localization.payLabelTextNumber,
              suffixImage: !kIsWeb
                  ? OverlayTooltipItem(
                      displayIndex: 5,
                      tooltip: (controller) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: MTooltip(
                          controller: controller,
                          message:
                              localization.selectDefaultBuyerContactMessage,
                        ),
                      ),
                      child: InkWell(
                        onLongPress: () => OverlayTooltipScaffold.of(context)
                            ?.controller
                            .start(5),
                        onTap: () => showModalBottomSheet(
                          isScrollControlled: true,
                          useRootNavigator: true,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                          ),
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: border,
                              topRight: border,
                            ),
                          ),
                          builder: (context) => DefaultBuyerContactsView(
                            onPressToContact: controller.updatePayerContact,
                          ),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_sharp,
                        ),
                      ),
                    )
                  : SizedBox(),
              isValidField: controller.paymentNumberErrorMessage.isEmpty &&
                  controller.paymentTextController.value.text.length > 2,
              contactWidget: ContactWidget(
                index: 2,
                contacts: contacts,
                tooltipDescriptionMessage:
                    localization.selectBuyerContactMessage,
                onPressToContact: controller.updatePayerContact,
                title: localization.selectBuyerContactMessage,
              ),
              saveContactIcon: controller.canUserSaveNumber()
                  ? Tooltip(
                      message: localization.setAsDefaultBuyer,
                      child: InkWell(
                        onTap: (() {
                          final FocusScopeNode currentFocus =
                              FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          showAlertBoxView(
                            context: context,
                            icon: Icon(
                              Icons.question_mark,
                              size: 30,
                            ),
                            title: localization.confirmation,
                            negativeBtnText: localization.noThank,
                            positiveBtnText: localization.yes,
                            content: Text(
                              localization.confirmSetAsDefault.trParams({
                                Constant.number:
                                    controller.paymentTextController.text,
                              }),
                              style: theme.textTheme.bodySmall,
                            ),
                            positiveBtnPressed: () async {
                              await controller.saveBuyerNumberAsDefaultBuyer();
                              Navigator.of(context, rootNavigator: true).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  localization.numberSaveSuccessful,
                                ),
                                behavior: SnackBarBehavior.floating,
                              ));
                            },
                          );
                        }),
                        child: Icon(
                          Icons.save_alt,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
            SizedBox(height: 10),
            AutoCompleteTextField(
              layerLink: LayerLink(),
              listOfContactSuggestion: contacts,
              key: Key(localization.receiverNumber),
              onChanged: controller.updateCurrentOperationImageOfNumber,
              onPressToSuggestion: (contact) =>
                  controller.updateReceiverContact(contact.phoneNumber),
              errorMessage: controller.receiverNumberErrorMessage.value,
              textController: controller.receiverTextController,
              isValidField: controller.receiverNumberErrorMessage.isEmpty &&
                  controller.receiverTextController.value.text.length > 2,
              labelText: localization.creditedLabelNumber,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OperatorIcon(
                  operatorType:
                      controller.currentOperation.value?.operatorName.key ??
                          PaymentId.unknown.key,
                ),
              ),
              contactWidget: ContactWidget(
                index: 3,
                contacts: contacts,
                tooltipDescriptionMessage:
                    localization.selectReceiverContactMessage,
                onPressToContact: controller.updateReceiverContact,
                title: localization.selectReceiverContactMessage,
              ),
            ),
            SizedBox(height: 10),
            if (featureForfeitEnabled && controller.forfeit.value != null)
              _ForfeitView(),
            if (controller.forfeit.value == null)
              SimpleTextField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[^0-9]')),
                ],
                textController: controller.amountToPayTextController,
                isValidField: controller.amountErrorMessage.isEmpty &&
                    controller.amountToPayTextController.value.text.isNotEmpty,
                errorMessage: controller.amountErrorMessage.value,
                labelText: localization.creditedAmount,
                onChanged: controller.updateAmount,
              ),
            SizedBox(height: 10),
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: FilledButton(
                style: theme.filledButtonTheme.style?.copyWith(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                      side: BorderSide(color: theme.primaryColor, width: 2),
                    ),
                  ),
                ),
                onPressed: checksTheForm,
                child: Text(
                  '${localization.pay} ${controller.buttonToPayTextAmount.value.isNotEmpty ? '${Currency.formatWithCurrency(
                      price: num.parse(controller.buttonToPayTextAmount.value),
                      locale: localization.locale,
                      currencyCodeAlpha3: DefaultCurrency.xaf,
                    )}' : ''}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class _AlertMessageContent extends StatelessWidget {
  final String value;
  final TransfersController controller;
  final Function(String value) changeDefaultParams;

  const _AlertMessageContent(
    this.controller,
    this.value,
    this.changeDefaultParams,
  );

  @override
  Widget build(BuildContext context) {
    final mtnNumberForSMSAirtimeTransaction = RemoteConfig().getString(
      RemoteConfigKeys.mtnNumberForSmsTransaction,
    );
    final orangeNumberForSMSAirtimeTransaction = RemoteConfig().getString(
      RemoteConfigKeys.orangeNumberForSmsTransaction,
    );
    final localization = Get.find<AppInternationalization>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            localization.sentRequestBySmsTitle,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          '${localization.chooseNumberToSend}: ',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 17,
        ),
        Row(
          children: [
            Text(
              mtnNumberForSMSAirtimeTransaction,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(width: 20),
            InkWell(
              onTap: () =>
                  changeDefaultParams(mtnNumberForSMSAirtimeTransaction),
              child: Icon(
                value == mtnNumberForSMSAirtimeTransaction
                    ? Icons.circle
                    : Icons.circle_outlined,
                size: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              orangeNumberForSMSAirtimeTransaction,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(width: 20),
            InkWell(
              onTap: () =>
                  changeDefaultParams(orangeNumberForSMSAirtimeTransaction),
              child: Icon(
                value == orangeNumberForSMSAirtimeTransaction
                    ? Icons.circle
                    : Icons.circle_outlined,
                size: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}

class _ForfeitView extends StatelessWidget {
  const _ForfeitView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransfersController>();
    final Forfeit? forfeit = controller.forfeit.value;
    final localization = Get.find<AppInternationalization>();

    if (forfeit == null) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.forfeitSelected,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: OperatorIcon(
                operatorType: forfeit.operatorName.key,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                forfeit.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                Currency.formatWithCurrency(
                  price: num.parse(forfeit.amountInXAF.toString()),
                  locale: localization.locale,
                  currencyCodeAlpha3: DefaultCurrency.xaf,
                ),
                style: TextStyle(color: AppColors.black),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 35,
          width: 100,
          child: TextButton(
            style: roundedBigButton(
              context,
              AppColors.darkGray,
              AppColors.white,
            ),
            onPressed: () => controller.setActiveForfeit(null),
            child: Text(
              localization.cancel,
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
