import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/forfeitRepository.dart';
import 'package:app_customer/data/repository/tranferRepository.dart';
import 'package:app_customer/pages/init_tranction/init_transaction.dart';
import 'package:app_customer/routes/pages_routes.dart';
import 'package:app_customer/util/drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../golden.dart';

class InitTransferViewWidget extends StatelessWidget {
  final String transferId;

  InitTransferViewWidget({required this.transferId});

  @override
  Widget build(BuildContext context) {
    Get.create(() => TransferRepository(HiveService(HiveServiceType.fake)));
    Get.create(() => ContactRepository(HiveService(HiveServiceType.fake)));
    Get.create(() => ForfeitRepository(HiveService(HiveServiceType.fake)));
    Get.create(CustomDrawerController.new);

    return InitTransaction(
      creditTransactionParams: CreditTransactionParams(
        transactionId: transferId,
        amountInXaf: '500',
        buyerGatewayId: 'OM',
        buyerPhoneNumber: '696689073',
        category: 'data',
        featureReference: 'Blue-Mo-M',
        operatorName: 'Camtel',
        receiverPhoneNumber: '620209878',
      ),
      isTesting: true,
    );
  }
}

void main() {
  group('Goldens', () {
    testGoldens('Failed Init Transfer view', (tester) async {
      await multiScreenMultiLocaleGolden(
        tester,
        InitTransferViewWidget(
          transferId: 'cc7c33c5-ec6d-4b1f-9f10-8c8c1c7c0af1',
        ),
        'init_transfer',
      );
    });
  });
}
