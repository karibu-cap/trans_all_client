import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/tranferRepository.dart';
import 'package:app_customer/pages/welcome/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../golden.dart';

class WelcomeViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(TransferRepository(HiveService(HiveServiceType.fake)));
    Get.put(ContactRepository(HiveService(HiveServiceType.fake)));

    return WelcomeView();
  }
}

void main() {
  group('Goldens', () {
    testGoldens('welcome us view', (tester) async {
      await multiScreenMultiLocaleGolden(
        tester,
        WelcomeViewWidget(),
        'welcome_view',
      );
    });
  });
}
