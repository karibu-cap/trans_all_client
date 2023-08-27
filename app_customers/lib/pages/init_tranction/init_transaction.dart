import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karibu_capital_core_utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/contactRepository.dart';
import '../../data/repository/forfeitRepository.dart';
import '../../data/repository/tranfersRepository.dart';
import '../../routes/app_router.dart';
import '../../routes/pages_routes.dart';
import '../../themes/app_colors.dart';
import '../../util/constant.dart';
import '../../widgets/custom_scaffold.dart';
import 'init_transaction_controller.dart';
import 'init_transaction_view_model.dart';

/// The Initialize transaction view.
class InitTransaction extends StatelessWidget {
  /// The id of transfer.
  final String? transferId;

  /// The number who make the payment.
  final String buyerPhoneNumber;

  /// The number who make the payment.
  final String buyerGatewayId;

  /// The number who make the payment.
  final String receiverOperator;

  /// The number who make the payment.
  final String featureReference;

  /// The receiver number.
  final String receiverPhoneNumber;

  /// The amount of transaction.
  final num amountToPay;

  /// The id of forfeit to transfers.
  final String? forfeitId;

  /// Constructs a new [InitTransaction] view.
  const InitTransaction({
    super.key,
    required this.buyerPhoneNumber,
    required this.receiverPhoneNumber,
    required this.amountToPay,
    required this.buyerGatewayId,
    required this.featureReference,
    required this.receiverOperator,
    this.transferId,
    this.forfeitId,
  });

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final transferRepository = Get.find<TransferRepository>();
    final contactRepository = Get.find<ContactRepository>();
    final forfeitRepository = Get.find<ForfeitRepository>();

    final initTransactionModel = InitTransactionViewModel(
      buyerPhoneNumber: buyerPhoneNumber,
      receiverPhoneNumber: receiverPhoneNumber,
      amountToPay: amountToPay,
      buyerGatewayId: buyerGatewayId,
      featureReference: featureReference,
      receiverOperator: receiverOperator,
      transferRepository: transferRepository,
      existedTransactionId: transferId,
      forfeitId: forfeitId,
      forfeitRepository: forfeitRepository,
    );

    Get.put(
      InitTransactionController(
        initTransactionModel,
        contactRepository,
        transferRepository,
      ),
    );

    return CustomScaffold(
      child: Builder(builder: (context) {
        final controller = Get.find<InitTransactionController>();
        final forfeit = controller.forfeit;

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
                              price: amountToPay,
                              locale: localization.locale,
                              currencyCodeAlpha3: DefaultCurrency.xaf,
                            ),
                    },
                  ),
                  style: TextStyle(
                    color: AppColors.black,
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
                            color: AppColors.black,
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
                            color: AppColors.black,
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
                                    color: AppColors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  controller.getUserName(buyerPhoneNumber),
                                  style: TextStyle(
                                    color: AppColors.black,
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
                                color: AppColors.black,
                              ),
                              Icon(
                                color: AppColors.black,
                                Icons.phone_android_outlined,
                                size: 50,
                              ),
                              Icon(
                                Icons.forward,
                                color: AppColors.black,
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
                                    color: AppColors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  controller.getUserName(receiverPhoneNumber),
                                  style: TextStyle(
                                    color: AppColors.black,
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
                  buyerGatewayId: buyerGatewayId,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _BodyTransaction extends StatelessWidget {
  final String buyerGatewayId;

  const _BodyTransaction({
    required this.buyerGatewayId,
  });
  @override
  Widget build(BuildContext context) {
    return GetX<InitTransactionController>(builder: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.loadingState.value != LoadingState.initiate ||
            controller.loadingState.value != LoadingState.processToTransfer) {
          controller.watchTransaction();
        }
      });

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ImageStatus(controller.loadingState.value),
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
                    ));
              }),
        ],
      );
    });
  }
}

class _ImageStatus extends GetView<InitTransactionController> {
  /// The loadingState.
  final LoadingState loadingState;

  _ImageStatus(this.loadingState);

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(seconds: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: loadingState == LoadingState.succeeded
              ? Stack(
                  fit: StackFit.loose,
                  children: [
                    Lottie.asset(
                      AnimationAsset.successTransaction,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Lottie.asset(
                      AnimationAsset.firstSuccess,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
              : loadingState == LoadingState.failed
                  ? Lottie.asset(
                      AnimationAsset.failedTransaction,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Lottie.asset(
                      AnimationAsset.loading,
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
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
    if (controller.loadingState.value == LoadingState.failed) {
      return Column(
        children: [
          Text(
            localization.ooops,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.darkBlack,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (controller.internetError.value)
            Text(
              localization.noInternetConnection,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: AppColors.red2,
              ),
            ),
          if (!controller.internetError.value)
            Text(
              localization.failedTransfer,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: AppColors.black,
              ),
            ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(9)),
                    ),
                  ),
                  onPressed: () => AppRouter.go(
                    context,
                    PagesRoutes.creditTransaction.pattern,
                  ),
                  child: Text(
                    localization.newTransaction,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(9)),
                    ),
                  ),
                  onPressed: () => controller.initializationTransaction(),
                  child: Text(
                    localization.retry,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (controller.loadingState.value == LoadingState.initiate) {
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
            color: AppColors.black,
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
              color: AppColors.darkBlack,
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
              color: AppColors.black,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(9)),
                    ),
                  ),
                  onPressed: () => AppRouter.go(
                    context,
                    PagesRoutes.creditTransaction.pattern,
                  ),
                  child: Text(
                    localization.newTransaction,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(9)),
                    ),
                  ),
                  onPressed: () => AppRouter.go(
                    context,
                    PagesRoutes.historic.pattern,
                  ),
                  child: Text(
                    localization.goToHistory,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (controller.loadingState.value == LoadingState.processToTransfer) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        child: Text(
          localization.initializationOfTransfer,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
      );
    }

    return SizedBox();
  }
}
