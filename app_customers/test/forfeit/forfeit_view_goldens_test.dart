import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/forfeitRepository.dart';
import 'package:app_customer/data/repository/tranferRepository.dart';
import 'package:app_customer/pages/transfer/transfer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:trans_all_common_config/config.dart';

import '../golden.dart';

class ForfeitViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(TransferRepository(HiveService(HiveServiceType.fake)));
    Get.put(ContactRepository(HiveService(HiveServiceType.fake)));
    Get.put(ForfeitRepository(HiveService(HiveServiceType.fake)));

    return TransfersView(
      displayInternetMessage: false,
      activePageIndex: 1,
    );
  }
}

void main() {
  group('Goldens', () {
    testGoldens('Forfeit Transfer view', (tester) async {
      final remoteConfigDefaults = getRemoteConfigDefaults();
      remoteConfigDefaults[RemoteConfigKeys.featureForfeitEnable] = false;
      await RemoteConfig.init(
        service: RemoteConfigType.fake,
        defaults: getRemoteConfigDefaults(),
      );
      await RemoteConfig.init(service: RemoteConfigType.fake, defaults: {
        RemoteConfigKeys.featureForfeitEnable: true,
      });
      await multiScreenMultiLocaleGolden(
        tester,
        ForfeitViewWidget(),
        'forfeit_transfer',
      );
    });
  });
}
