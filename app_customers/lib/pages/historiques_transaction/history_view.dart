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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                AnimationAsset.noItem,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Text(
                localization.noTransferHistory,
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ],
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
                  buyerGatewayId: transaction.buyerGateway.key,
                  receiverOperator: transaction.receiverOperator,
                  featureReference: transaction.feature.key,
                  transactionId: transaction.id,
                  forfeitId: transaction.forfeitId,
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
                    color: AppColors.white,
                    border: const Border.fromBorderSide(
                      BorderSide(color: AppColors.lightGray),
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
                          color: AppColors.black,
                          border: const Border.fromBorderSide(
                            BorderSide(color: AppColors.lightGray),
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
              color: AppColors.black,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          DottedLine(
            dashColor: AppColors.black,
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

    final transferStatus = transfer.status.key;
    final transferBuyerGateway =
        transfer.buyerGateway.key == PaymentId.orangePaymentId.key
            ? 'OM'
            : transfer.buyerGateway.key == PaymentId.mtnPaymentId.key
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
    final forfeit = controller.getCurrentForfeit(transfer.forfeitId);

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
                        operatorType: transfer.feature.key,
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
                      Text(
                        '${localization.buyerPhoneNumber}: ',
                      ),
                      Text(
                        buyerName == null
                            ? transfer.buyerPhoneNumber
                            : '$buyerName (${transfer.buyerPhoneNumber})',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${localization.receiverNumber}: ',
                      ),
                      Text(
                        receiverName == null
                            ? transfer.receiverPhoneNumber
                            : '$receiverName (${transfer.receiverPhoneNumber})',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${localization.paymentOperator}: ',
                      ),
                      Text(
                        transferBuyerGateway,
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (forfeit != null)
                        SizedBox(
                          child: Column(
                            children: [
                              Text(
                                '${localization.forfeit}: ',
                              ),
                              Text(
                                forfeit.name,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${localization.amount}: ',
                    ),
                    FittedBox(
                      child: Text(
                        Currency.formatWithCurrency(
                          price: transfer.amount,
                          locale: localization.locale,
                          currencyCodeAlpha3: DefaultCurrency.xaf,
                        ),
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(timeFormatted(transfer.createdAt)),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.darkGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(9),
                            ),
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            localization.clone.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        onPressed: () => AppRouter.go(
                          context,
                          PagesRoutes.creditTransaction.create(
                            CreditTransactionParams(
                              buyerPhoneNumber: transfer.buyerPhoneNumber,
                              receiverPhoneNumber: transfer.receiverPhoneNumber,
                              amountInXaf: transfer.amount.toString(),
                              buyerGatewayId: transfer.buyerGateway.key,
                              receiverOperator: transfer.receiverOperator,
                              featureReference: transfer.feature.key,
                              forfeitId: transfer.forfeitId,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
