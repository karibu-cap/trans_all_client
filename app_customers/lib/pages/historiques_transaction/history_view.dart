import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karibu_capital_core_utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/contactRepository.dart';
import '../../data/repository/forfeitRepository.dart';
import '../../data/repository/tranfersRepository.dart';
import '../../routes/app_router.dart';
import '../../routes/pages_routes.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../util/constant.dart';
import '../../util/format_date_time.dart';
import '../../util/get_client_status.dart';
import '../../util/operator_name.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/oparator_icon.dart';
import 'history_view_controller.dart';
import 'history_view_model.dart';

/// The historic page view.
class HistoryView extends StatelessWidget {
  /// Check if we can display internet message of the app bar.
  final bool? displayInternetMessage;

  /// Constructs a new instance of the [HistoryView].
  HistoryView({this.displayInternetMessage});

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final transferRepository = Get.find<TransferRepository>();
    final contactRepository = Get.find<ContactRepository>();
    final forfeitRepository = Get.find<ForfeitRepository>();
    Get.put(
      HistoryViewController(
        transferRepository: transferRepository,
        forfeitRepository: forfeitRepository,
        historyModel: HistoryViewModel(
          transferRepository: transferRepository,
          contactRepository: contactRepository,
        ),
      ),
    );

    return CustomScaffold(
      displayInternetMessage: false,
      title: localization.airtimeHistory,
      child: GetBuilder<HistoryViewController>(
        builder: (controller) => Column(children: [
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          '${localization.version}:',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          data.version,
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      ]),
                      Row(children: [
                        Text(
                          '${localization.buildNumber}:',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          data.buildNumber,
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(child: _HistoricTransaction()),
        ]),
      ),
    );
  }
}

class _HistoricTransaction extends GetView<HistoryViewController> {
  const _HistoricTransaction();

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final theme = Theme.of(context);

    int _getDaysSinceEpoch(DateTime dateTime) {
      final dayInMilliseconds = const Duration(days: 1).inMilliseconds;

      return dateTime.millisecondsSinceEpoch ~/ dayInMilliseconds;
    }

    return Obx((() {
      final allTransaction = controller.listOfTransfers.value;

      if (allTransaction == null) {
        return Center(
          child: Lottie.asset(
            AnimationAsset.loading,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      }
      if (allTransaction.isEmpty) {
        return Center(
          child: Text(
            localization.noTransferHistory,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        );
      }

      final children = <Widget>[];
      int? previousTransactionCreationDaysSinceEpoch;
      allTransaction.sort((t1, t2) {
        final createdAt1 = t1.createdAt;
        final createdAt2 = t2.createdAt;

        return createdAt2.compareTo(createdAt1);
      });
      for (final transaction in allTransaction) {
        final createdAt = transaction.createdAt;

        final transactionDaysSinceEpoch = _getDaysSinceEpoch(createdAt);
        if (previousTransactionCreationDaysSinceEpoch !=
            transactionDaysSinceEpoch) {
          children.add(_TransactionDateHeader(createdAt));
          previousTransactionCreationDaysSinceEpoch =
              _getDaysSinceEpoch(createdAt);
        }
        children.add(
          InkWell(
            onTap: () => AppRouter.push(
              context,
              PagesRoutes.initTransaction.create(
                CreditTransactionParams(
                  buyerPhoneNumber: transaction.buyerPhoneNumber,
                  receiverPhoneNumber: transaction.receiverPhoneNumber,
                  amountInXaf: transaction.amount.toString(),
                  buyerGatewayId: transaction.payments.last.gateway.key,
                  featureReference: transaction.feature.key,
                  transactionId: transaction.id,
                  forfeitReference: transaction.forfeitReference,
                ),
              ),
            ),
            child: _HistoryView(transfer: transaction),
          ),
        );
      }

      return Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
          ),
          if (controller.listOfStats.value.isNotEmpty)
            SizedBox(
              height: 200,
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CircularSeries>[
                  PieSeries<TransferStat, String>(
                    dataSource: controller.listOfStats.value,
                    xValueMapper: (stat, _) => stat.transferStatus,
                    yValueMapper: (stat, _) => stat.transferCount,
                    pointColorMapper: (stat, _) => stat.color,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    enableTooltip: true,
                  ),
                ],
              ),
            ),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              minChildSize: 0.5,
              initialChildSize: 0.7,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: theme.bottomSheetTheme.backgroundColor,
                    border: Border.fromBorderSide(
                      BorderSide(color: theme.primaryColor),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(color: theme.primaryColor),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: children.length,
                          controller: scrollController,
                          itemBuilder: (context, index) => children[index],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }));
  }
}

class _TransactionDateHeader extends StatelessWidget {
  final DateTime date;

  _TransactionDateHeader(this.date);

  String formattedDatePattern(Locale locale) {
    return locale.languageCode == 'fr' ? 'EEEE, d MMMM y' : 'EEEE MMMM d, y';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateFormatted(date),
            style: TextStyle(
              fontSize: AppFontSizes.largeBody,
              fontWeight: AppFontWeights.medium,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          DottedLine(
            dashColor: theme.colorScheme.secondary,
            lineThickness: 3,
          ),
        ],
      ),
    );
  }
}

/// The historic view.
class _HistoryView extends StatelessWidget {
  /// The specific transfer.
  final TransferInfo transfer;

  /// Constructs a new instance of the [HistoryView].
  _HistoryView({
    Key? key,
    required this.transfer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final controller = Get.find<HistoryViewController>();
    final theme = Theme.of(context);

    final transferStatus = transfer.status.key;
    final transferBuyerGateway =
        transfer.payments.last.gateway.key == PaymentId.orangePaymentId.key
            ? 'OM'
            : transfer.payments.last.gateway.key == PaymentId.mtnPaymentId.key
                ? 'MOMO'
                : PaymentId.unknown.key;
    final paymentStatus = transfer.payments.last.status.key;
    final isSuccessStatus = transferStatus == TransferStatus.succeeded.key ||
        transferStatus == TransferStatus.completed.key;
    final isFailedStatus = transferStatus == TransferStatus.failed.key ||
        transferStatus == TransferStatus.paymentFailed.key ||
        paymentStatus == PaymentStatus.failed.key;

    final buyerName = controller.getUserName(transfer.buyerPhoneNumber);
    final receiverName = controller.getUserName(transfer.receiverPhoneNumber);

    return Card(
      elevation: 0,
      color: isSuccessStatus
          ? AppColors.lightGreen.withOpacity(0.07)
          : isFailedStatus
              ? AppColors.red2.withOpacity(0.02)
              : AppColors.purple.withOpacity(0.02),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        side: BorderSide(
          color: isSuccessStatus
              ? AppColors.lightGreen
              : isFailedStatus
                  ? AppColors.red2
                  : AppColors.purple,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: #${transfer.id.substring(0, 5)}'),
            SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: OperatorIcon(
                        operatorType: retrieveOperatorName(transfer.feature),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HistoricData(
                        label: localization.buyerPhoneNumber,
                        value: buyerName == null
                            ? transfer.buyerPhoneNumber
                            : '$buyerName (${transfer.buyerPhoneNumber})',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _HistoricData(
                        label: localization.receiverNumber,
                        value: receiverName == null
                            ? transfer.receiverPhoneNumber
                            : '$receiverName (${transfer.receiverPhoneNumber})',
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _HistoricData(
                        label: localization.amount,
                        value: Currency.formatWithCurrency(
                          price: transfer.amount,
                          locale: localization.locale,
                          currencyCodeAlpha3: DefaultCurrency.xaf,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _HistoricData(
                        label: localization.paymentOperator,
                        value: transferBuyerGateway,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                        future: controller
                            .getCurrentForfeit(transfer.forfeitReference),
                        builder: (context, snapshot) {
                          final forfeit = snapshot.data;
                          if (forfeit == null) {
                            return SizedBox.shrink();
                          }

                          return _HistoricData(
                            label: localization.forfeit,
                            value: forfeit.name,
                          );
                        },
                      ),
                      _HistoricData(
                        label: localization.status,
                        value: retrieveValidStatusInternalized(transfer),
                        labelStyle: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      FilledButton(
                        child: FittedBox(
                          child: Text(
                            localization.clone,
                          ),
                        ),
                        onPressed: () => AppRouter.go(
                          context,
                          PagesRoutes.creditTransaction.create(
                            CreditTransactionParams(
                              buyerPhoneNumber: transfer.buyerPhoneNumber,
                              receiverPhoneNumber: transfer.receiverPhoneNumber,
                              amountInXaf: transfer.amount.toString(),
                              buyerGatewayId:
                                  transfer.payments.last.gateway.key,
                              featureReference: transfer.feature.key,
                              forfeitReference: transfer.forfeitReference,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoricData extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;

  const _HistoricData({
    Key? key,
    required this.label,
    required this.value,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          Text(
            '$label: ',
          ),
          Text(
            value,
            style: labelStyle ??
                TextStyle(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
