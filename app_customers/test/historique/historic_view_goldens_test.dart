import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/forfeitRepository.dart';
import 'package:app_customer/data/repository/tranferRepository.dart';
import 'package:app_customer/pages/historiques_transaction/history_view.dart';
import 'package:app_customer/util/drawer_controller.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../golden.dart';

class HistoryViewWidget extends StatelessWidget {
  HistoryViewWidget();

  @override
  Widget build(BuildContext context) {
    Get.put(TransferRepository(HiveService(HiveServiceType.fake)));
    Get.put(ContactRepository(HiveService(HiveServiceType.fake)));
    Get.put(ForfeitRepository(HiveService(HiveServiceType.fake)));
    Get.create(CustomDrawerController.new);


    return HistoryView(
      displayInternetMessage: false,
    );
  }
}

void main() {
  group('Goldens', () {
    testGoldens('history us view', (tester) async {
      final fakeClock = Clock.fixed(DateTime(2023, 1, 1, 12, 0, 0));

      return withClock(
        fakeClock,
        () async {
          await multiScreenMultiLocaleGolden(
            tester,
            HistoryViewWidget(),
            'history_view',
          );
        },
      );
    });
  });
}
