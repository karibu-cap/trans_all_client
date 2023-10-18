import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/forfeitRepository.dart';
import 'package:app_customer/data/repository/tranferRepository.dart';
import 'package:app_customer/pages/init_tranction/init_transaction.dart';
import 'package:app_customer/routes/pages_routes.dart';
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

    return InitTransaction(
      creditTransactionParams: CreditTransactionParams(
        transactionId: transferId,
        amountInXaf: '500',
        buyerGatewayId: 'OM',
        buyerPhoneNumber: '696689073',
        category: 'unit',
        featureReference: 'mtnUnitTransfer',
        operatorName: 'Mtn',
        receiverPhoneNumber: '672419098',
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
          transferId: '4b3f3f02-0e6b-4c3c-8c4e-3b5e5cdec50b',
        ),
        'failed_init_transfer',
      );
    });
  });
}
