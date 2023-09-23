import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/forfeitRepository.dart';
import 'package:app_customer/data/repository/tranfersRepository.dart';
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
      creditTransactionParams:
          CreditTransactionParams(transactionId: transferId),
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
          transferId: '5f3c9b61-e7f3-4c0e-9f3f-9f5f8d4c4b4c',
        ),
        'init_transfer',
      );
    });
  });
}
