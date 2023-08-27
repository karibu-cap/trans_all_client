import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/tranfersRepository.dart';
import '../../themes/app_button_styles.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../util/constant.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/oparator_icon.dart';
import 'money_transfert_controller.dart';
import 'money_transfert_view_model.dart';

/// The money transfer.
class MoneyTransferView extends StatelessWidget {
  /// Check if we can display internet message of the app bar.
  final bool? displayInternetMessage;

  /// Constructor of new [MoneyTransferView].
  const MoneyTransferView({super.key, this.displayInternetMessage});

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();

    final transferRepository = Get.find<TransferRepository>();

    final moneyTransferViewModel =
        MoneyTransferViewModel(transferRepository: transferRepository);
    final controller = Get.put(MoneyTransferController(moneyTransferViewModel));

    return CustomScaffold(
      displayInternetMessage: displayInternetMessage ?? true,
      title: localization.moneyTransfer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _BodyTransaction(),
      ),
    );
  }
}

class _BodyTransaction extends StatelessWidget {
  const _BodyTransaction();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoneyTransferController>();

    final localization = Get.find<AppInternationalization>();

    return FutureBuilder<void>(
      future: controller.initializationDone.future,
      builder: (context, snapshot) {
        final supportedPayment = controller.supportedPaymentGateway;

        if (supportedPayment == null) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.8,
            child: Lottie.asset(
              AnimationAsset.loading,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          );
        }
        if (supportedPayment.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: PlayAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, -100 + value * 100),
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        localization.emptyPaymentGateway,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        /// Checks the form.
        Future<void> checksTheForm() async {
          final payerGatewaySelected = controller.currentPayerGateway.value;
          final receiverGatewaySelected =
              controller.currentReceiverGateway.value;
          controller.isValidPayerNumber();
          controller.isValidReceiverNumber();
          controller.isValidAmount();

          if (controller.paymentNumberErrorMessage.value.isEmpty &&
              controller.receiverNumberErrorMessage.value.isEmpty &&
              controller.amountErrorMessage.value.isEmpty &&
              payerGatewaySelected != null &&
              receiverGatewaySelected != null) {}
        }

        return PlayAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(seconds: 2),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _PaymentMethodView(supportedPayment),
                    _PaymentForm(),
                    ElevatedButton(
                      style: roundedBigButton(
                        context,
                        AppColors.green,
                        AppColors.white,
                      ),
                      onPressed: checksTheForm,
                      child: Text(
                        localization.proceed,
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PaymentForm extends StatelessWidget {
  const _PaymentForm();

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();

    return GetX<MoneyTransferController>(
      builder: (controller) => Column(
        children: [
          // TextForm(
          //   errorMessage: controller.paymentNumberErrorMessage.value,
          //   textController: controller.paymentNumberTextController,
          //   prefixIcon: Icon(
          //     Icons.phone_android,
          //     color: AppColors.green,
          //   ),
          //   onPressedAddContact: controller.getPayerContact,
          //   displayAddContactButton: !GetPlatform.isWeb,
          //   onChanged: controller.updateCurrentPayerNumberImage,
          //   labelText: localization.payLabelTextNumber,
          //   suffixImage: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: OperatorIcon(
          //       operatorType: controller.currentPayerGateway.value?.id.key ??
          //           PaymentId.unknown.key,
          //     ),
          //   ),
          // ),
          // InkWell(
          //   onTap: controller.changeTheNumber,
          //   child: Icon(
          //     Icons.cached_outlined,
          //     size: 25,
          //     color: AppColors.green,
          //   ),
          // ),
          // TextForm(
          //   textController: controller.receiverNumberTextController,
          //   errorMessage: controller.receiverNumberErrorMessage.value,
          //   displayAddContactButton: !GetPlatform.isWeb,
          //   prefixIcon: Icon(
          //     Icons.phone_android,
          //     color: AppColors.green,
          //   ),
          //   labelText: localization.receiverNumber,
          //   onPressedAddContact: controller.getReceiverContact,
          //   onChanged: controller.updateCurrentReceiverNumberImage,
          //   suffixImage: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: OperatorIcon(
          //       operatorType: controller.currentReceiverGateway.value?.id.key ??
          //           PaymentId.unknown.key,
          //     ),
          //   ),
          // ),
          // TextForm(
          //   errorMessage: controller.amountErrorMessage.value,
          //   textController: controller.amountOfTransferTextController,
          //   prefixIcon: Icon(
          //     Icons.payments,
          //     color: AppColors.green,
          //   ),
          //   labelText: localization.amount,
          // ),
        ],
      ),
    );
  }
}

class _PaymentMethodView extends StatelessWidget {
  final List<PaymentGateways> supportedPayment;

  const _PaymentMethodView(this.supportedPayment);

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();

    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.availablePayment,
            style: AppTextStyles.headerH3Label,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: supportedPayment.map((e) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: OperatorIcon(operatorType: e.id.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
