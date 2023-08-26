import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/forfeitRepository.dart';
import 'package:app_customer/data/repository/tranfersRepository.dart';
import 'package:app_customer/pages/forfeit/forfeit_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../golden.dart';

class ForfeitViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(TransferRepository(HiveService(HiveServiceType.fake)));
    Get.put(ContactRepository(HiveService(HiveServiceType.fake)));
    Get.put(ForfeitRepository(HiveService(HiveServiceType.fake)));

    return ForfeitView();
  }
}

void main() {
  group('Goldens', () {
    testGoldens('Forfeit Transfer view', (tester) async {
      await multiScreenMultiLocaleGolden(
        tester,
        ForfeitViewWidget(),
        'forfeit_transfer',
      );
    });
  });
}
