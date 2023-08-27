import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:trans_all_common_config/config.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/contactRepository.dart';
import '../../data/repository/forfeitRepository.dart';
import '../../data/repository/tranfersRepository.dart';
import '../../routes/app_router.dart';
import '../../routes/pages_routes.dart';
import '../../themes/app_button_styles.dart';
import '../../themes/app_colors.dart';
import '../../util/constant.dart';
import '../../widgets/custom_scaffold.dart';
import 'component/form_transfert.dart';
import 'component/operator_method.dart';
import 'component/payment_method.dart';
import 'component/pending_transaction.dart';
import 'transfer_controller_view.dart';
import 'transfer_view_model.dart';

/// The Transfers view.
class TransfersView extends StatelessWidget {
  /// Local transaction param.
  final CreditTransactionParams? localCreditTransaction;

  /// The forfeit id.
  final String? forfeitId;

  /// Check if we can display internet message of the app bar.
  final bool? displayInternetMessage;

  /// Constructs a new [TransfersView].
  const TransfersView({
    this.localCreditTransaction,
    this.displayInternetMessage,
    this.forfeitId,
  });

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final transferRepository = Get.find<TransferRepository>();
    final forfeitRepository = Get.find<ForfeitRepository>();
    final contactRepository = Get.find<ContactRepository>();
    final transfersViewModel = TransfersViewModel(
      transferRepository: transferRepository,
      contactRepository: contactRepository,
    );

    Get.put<TransfersController>(
      permanent: false,
      TransfersController(
        localization: localization,
        forfeitRepository: forfeitRepository,
        transfersViewModel: transfersViewModel,
        localCreditTransaction: localCreditTransaction,
        forfeitId: forfeitId,
      ),
    );

    return _OverlayTooltipView(displayInternetMessage);
  }
}

class _BodyTransaction extends StatelessWidget {
  const _BodyTransaction();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransfersController>();
    final localization = Get.find<AppInternationalization>();

    return Obx((() {
      final supportedPayment = controller.supportedPaymentGateway.value;
      final supportedTransfer =
          controller.supportedTransferOperationGateway.value;

      if (controller.internetError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                localization.anErrorOccurred,
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: controller.retryTransfer,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.darkBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    localization.retry,
                    style: const TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (supportedTransfer == null || supportedPayment == null) {
        return Center(
          child: Lottie.asset(
            AnimationAsset.loading,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      }
      if (supportedPayment.isEmpty) {
        return Center(
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
        );
      }
      if (supportedTransfer.isEmpty) {
        return Center(
          child: PlayAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(seconds: 1),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -100 + value * 100),
                child: Opacity(
                  opacity: value,
                  child: Text(localization.emptyTransfer),
                ),
              );
            },
          ),
        );
      }

      return PlayAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: Duration(seconds: 2),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: _SkeletonBodyWidget(
              children: [
                PendingTransaction(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: PaymentMethodView(supportedPayment),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: TransferAirtimeMethod(supportedTransfer),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                StreamBuilder<List<Contact>>(
                  stream: controller.streamOfContact.stream,
                  builder: (context, snapshot) {
                    final contacts = snapshot.data;

                    return StreamBuilder<List<Contact>>(
                      stream: controller.streamOfBuyerContact.stream,
                      builder: (context, snapshot) {
                        return FormTransfer(contacts ?? []);
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }));
  }
}

class _OverlayTooltipView extends StatelessWidget {
  final bool? displayInternetMessage;
  const _OverlayTooltipView(
    this.displayInternetMessage,
  );

  @override
  Widget build(BuildContext context) {
    final TooltipController _controller = TooltipController();
    final localization = Get.find<AppInternationalization>();

    return OverlayTooltipScaffold(
      overlayColor: AppColors.red.withOpacity(0.4),
      tooltipAnimationCurve: Curves.linear,
      tooltipAnimationDuration: const Duration(milliseconds: 1000),
      controller: _controller,
      preferredOverlay: GestureDetector(
        onTap: _controller.dismiss,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: AppColors.darkBlack.withOpacity(0.9),
        ),
      ),
      builder: (context) => GestureDetector(
        onTap: () {
          final FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: CustomScaffold(
          displayInternetMessage: displayInternetMessage ?? true,
          title: localization.buyAirtime,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _BodyTransaction(),
          ),
        ),
      ),
    );
  }
}

class _SkeletonBodyWidget extends StatelessWidget {
  /// The children.
  final List<Widget> children;

  /// Constructs a new [_SkeletonBodyWidget].
  const _SkeletonBodyWidget({required this.children});

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final featureForfeitEnabled = RemoteConfig().getBool(
      RemoteConfigKeys.featureForfeitEnable,
    );

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featureForfeitEnabled)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 35,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () => AppRouter.push(
                      context,
                      PagesRoutes.forfeit.pattern,
                    ),
                    style: roundedBigButton(
                      context,
                      AppColors.darkBlack,
                      AppColors.white,
                    ),
                    child: Text(
                      localization.forfeit,
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...children,
                        SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
