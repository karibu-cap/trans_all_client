import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/forfeitRepository.dart';
import 'package:app_customer/data/repository/tranfersRepository.dart';
import 'package:app_customer/pages/transfer/transfer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:trans_all_common_config/config.dart';

import '../golden.dart';

class CreditTransferViewWidget extends StatelessWidget {
  final String? forfeitId;

  CreditTransferViewWidget({
    this.forfeitId,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(TransferRepository(HiveService(HiveServiceType.fake)));
    Get.put(ContactRepository(HiveService(HiveServiceType.fake)));
    Get.put(ForfeitRepository(HiveService(HiveServiceType.fake)));

    return TransfersView(
      displayInternetMessage: false,
    );
  }
}

void main() {
  group('Goldens', () {
    testGoldens('Credit Transfer view', (tester) async {
      await multiScreenMultiLocaleGolden(
        tester,
        CreditTransferViewWidget(),
        'credit_transfer',
      );
    });

    testGoldens('Credit Transfer with forfeit view', (tester) async {
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
        CreditTransferViewWidget(),
        'credit_transfer_with_forfeit',
      );
    });
  });
}
