import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karibu_capital_core_utils/utils.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../../routes/app_router.dart';
import '../../../routes/pages_routes.dart';
import '../../../themes/app_colors.dart';
import '../../../util/constant.dart';
import '../../../util/get_client_status.dart';
import '../../../util/operator_name.dart';
import '../../../widgets/oparator_icon.dart';
import '../transfer_controller_view.dart';

/// The pending transaction view.
class PendingTransaction extends GetView<TransfersController> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransferInfo>>(
      stream: controller.streamPendingTransferInfo.stream,
      builder: (context, snapshot) {
        final pendingTransfer = snapshot.data ?? [];
        if (pendingTransfer.isEmpty) {
          return SizedBox();
        }

        return _ListOfPendingTransfer(pendingTransfer: pendingTransfer);
      },
    );
  }
}

class _ListOfPendingTransfer extends StatelessWidget {
  /// List of pending transfer.
  final List<TransferInfo> pendingTransfer;

  const _ListOfPendingTransfer({
    Key? key,
    required this.pendingTransfer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            localization.pendingTransfer,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: pendingTransfer.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final transfer = pendingTransfer[index];
                final transferBuyerGateway =
                    transfer.payments.last.gateway.key ==
                            PaymentId.orangePaymentId.key
                        ? 'OM'
                        : transfer.payments.last.gateway.key ==
                                PaymentId.mtnPaymentId.key
                            ? 'MOMO'
                            : PaymentId.unknown.key;

                return InkWell(
                  onTap: () => AppRouter.push(
                    context,
                    PagesRoutes.initTransaction.create(
                      CreditTransactionParams(
                        buyerPhoneNumber: transfer.buyerPhoneNumber,
                        receiverPhoneNumber: transfer.receiverPhoneNumber,
                        amountInXaf: transfer.amount.toString(),
                        buyerGatewayId: transferBuyerGateway,
                        featureReference: transfer.feature.key,
                        transactionId: transfer.id,
                        forfeitId: transfer.forfeitId,
                      ),
                    ),
                  ),
                  child: _PendingTransferView(
                    transfer: transfer,
                    localization: localization,
                    transferBuyerGateway: transferBuyerGateway,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingTransferView extends StatelessWidget {
  final TransferInfo transfer;
  final AppInternationalization localization;
  final String transferBuyerGateway;

  const _PendingTransferView({
    Key? key,
    required this.transfer,
    required this.localization,
    required this.transferBuyerGateway,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransfersController>();
    final Forfeit? forfeit = controller.forfeit.value;

    return Center(
      child: Container(
        margin: EdgeInsets.only(right: 10),
        //width: MediaQuery.of(context).size.width * 0.8,
        //constraints: BoxConstraints(maxWidth: 400),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: OperatorIcon(
                        operatorType: retrieveOperatorName(transfer.feature),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: forfeit == null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${localization.amount}: ',
                                  ),
                                  Text(
                                    Currency.formatWithCurrency(
                                      price: transfer.amount,
                                      locale: localization.locale,
                                      currencyCodeAlpha3: DefaultCurrency.xaf,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${localization.forfeit}: ',
                                  ),
                                  Text(
                                    forfeit.name,
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${localization.from}: ',
                            ),
                            Text(
                              transfer.buyerPhoneNumber,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${localization.to}: ',
                            ),
                            Text(
                              transfer.receiverPhoneNumber,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              child: Text(
                                '${localization.by}: ',
                              ),
                            ),
                            Text(
                              transferBuyerGateway,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            Text(
                              '${localization.status}: ',
                            ),
                            Text(
                              getValidStatus(
                                transfer.status,
                                transfer.payments.last.status,
                              ).toUpperCase(),
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
