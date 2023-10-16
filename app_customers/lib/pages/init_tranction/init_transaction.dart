import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karibu_capital_core_utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/contactRepository.dart';
import '../../data/repository/forfeitRepository.dart';
import '../../data/repository/tranfersRepository.dart';
import '../../routes/app_router.dart';
import '../../routes/pages_routes.dart';
import '../../util/constant.dart';
import '../../widgets/custom_scaffold.dart';
import 'init_transaction_controller.dart';
import 'init_transaction_view_model.dart';

/// The Initialize transaction view.
class InitTransaction extends StatelessWidget {
  /// The credit transaction params.
  final CreditTransactionParams creditTransactionParams;

  /// The boolean to verify if is testing mode.
  final bool isTesting;

  /// Constructs a new [InitTransaction] view.
  const InitTransaction({
    super.key,
    required this.creditTransactionParams,
    this.isTesting = false,
  });

  @override
  Widget build(BuildContext context) {
    final transferRepository = Get.find<TransferRepository>();
    final contactRepository = Get.find<ContactRepository>();
    final forfeitRepository = Get.find<ForfeitRepository>();

    final initTransactionModel = InitTransactionViewModel(
      creditTransactionParams: creditTransactionParams,
      forfeitRepository: forfeitRepository,
      transferRepository: transferRepository,
    );

    Get.put(
      InitTransactionController(
        initTransactionModel,
        contactRepository,
      ),
    );

    return CustomScaffold(
      displayInternetMessage: !isTesting,
      child: Builder(builder: (context) {
        final controller = Get.find<InitTransactionController>();

        return FutureBuilder(
          future: controller.transferCompleter.future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  AnimationAsset.loading,
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                  repeat: !isTesting,
                ),
              );
            }

            return _TransferWrapper(isTesting: isTesting);
          },
        );
      }),
    );
  }
}

class _TransferWrapper extends StatelessWidget {
  final bool isTesting;

  const _TransferWrapper({
    required this.isTesting,
  });

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final controller = Get.find<InitTransactionController>();
    final forfeit = controller.forfeit?.value;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Text(
              localization.transferOf.trParams(
                {
                  Constant.amountToPay: forfeit != null
                      ? localization.forfeit
                      : Currency.formatWithCurrency(
                          price: controller.amountToPay.value ?? 0,
                          locale: localization.locale,
                          currencyCodeAlpha3: DefaultCurrency.xaf,
                        ),
                },
              ),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            if (forfeit != null)
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      forfeit.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      localization.locale.languageCode == 'en'
                          ? forfeit.description.en
                          : forfeit.description.fr,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Container(
                      height: 80,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localization.payer,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              controller.getUserName(
                                controller.buyerPhoneNumber.value ?? '',
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: FittedBox(
                      child: Row(
                        children: [
                          Icon(
                            Icons.forward,
                          ),
                          Icon(
                            Icons.phone_android_outlined,
                            size: 50,
                          ),
                          Icon(
                            Icons.forward,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Container(
                      height: 80,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localization.receiver,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              controller.getUserName(
                                controller.receiverPhoneNumber.value ?? '',
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _BodyTransaction(
              isTesting: isTesting,
              buyerGatewayId: controller.buyerGatewayId.value ?? '',
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyTransaction extends StatelessWidget {
  final String buyerGatewayId;
  final bool isTesting;

  const _BodyTransaction({
    required this.buyerGatewayId,
    required this.isTesting,
  });
  @override
  Widget build(BuildContext context) {
    return GetX<InitTransactionController>(builder: ((controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ImageStatus(
            controller.loadingState.value,
            isTesting,
          ),
          SizedBox(
            height: 20,
          ),
          PlayAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(seconds: 1),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: _CurrentWidget(
                  buyerGatewayId: buyerGatewayId,
                ),
              );
            },
          ),
        ],
      );
    }));
  }
}

class _ImageStatus extends GetView<InitTransactionController> {
  /// The loadingState.
  final LoadingState loadingState;
  final bool isTesting;

  _ImageStatus(this.loadingState, this.isTesting);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PlayAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(seconds: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        if (loadingState == LoadingState.succeeded) {
          return Opacity(
            opacity: value,
            child: Stack(
              fit: StackFit.loose,
              children: [
                Lottie.asset(
                  AnimationAsset.successTransaction,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  repeat: !isTesting,
                ),
                Lottie.asset(
                  AnimationAsset.firstSuccess,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  repeat: !isTesting,
                ),
              ],
            ),
          );
        }
        if (loadingState == LoadingState.failed) {
          return Opacity(
            opacity: value,
            child: Lottie.asset(
              AnimationAsset.failedTransaction,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              repeat: !isTesting,
            ),
          );
        }

        return Opacity(
          opacity: value,
          child: SimpleCircularProgressBar(
            valueNotifier: controller.transferProgress,
            size: 220,
            mergeMode: true,
            onGetText: ((value) {
              return Text(
                '${value.toInt()}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _CurrentWidget extends GetView<InitTransactionController> {
  final String buyerGatewayId;

  const _CurrentWidget({
    required this.buyerGatewayId,
  });
  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final theme = Theme.of(context);

    if (controller.loadingState.value == LoadingState.failed) {
      return Column(
        children: [
          Text(
            localization.ooops,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            localization.failedTransferMessage,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: theme.colorScheme.error,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (controller.errorMessage.value != null)
            Text(
              controller.errorMessage.value ?? localization.anErrorOccurred,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.error,
              ),
            ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => controller.initializationTransaction(),
                    child: Text(
                      localization.retry,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: () => AppRouter.go(
                      context,
                      PagesRoutes.creditTransaction.pattern,
                    ),
                    child: Text(
                      localization.newTransaction,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (controller.loadingState.value == LoadingState.initiated) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        child: Text(
          localization.waitingPaymentValidation_2.trParams({
            Constant.code: buyerGatewayId == PaymentId.orangePaymentId.key
                ? '#150*50#'
                : '*126#',
          }),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    if (controller.loadingState.value == LoadingState.succeeded) {
      return Column(
        children: [
          Text(
            localization.success,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            localization.successTransaction,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => AppRouter.go(
                      context,
                      PagesRoutes.historic.pattern,
                    ),
                    child: Text(
                      localization.goToHistory,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(9)),
                      ),
                    ),
                    onPressed: () => AppRouter.go(
                      context,
                      PagesRoutes.creditTransaction.pattern,
                    ),
                    child: Text(
                      localization.newTransaction,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (controller.loadingState.value == LoadingState.proceeded) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        child: Text(
          localization.initializationOfTransfer,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return SizedBox();
  }
}
