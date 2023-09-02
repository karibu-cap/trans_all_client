import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/forfeitRepository.dart';
import 'package:app_customer/data/repository/tranfersRepository.dart';
import 'package:app_customer/pages/historiques_transaction/history_view.dart';
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

    return HistoryView(
      displayInternetMessage: false,
    );
  }
}

void main() {
  group('Goldens', () {
    testGoldens('history us view', (tester) async {
      return withClock(
        Clock.fixed(DateTime.parse('2022-10-13 15:30:00Z').toUtc()),
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
