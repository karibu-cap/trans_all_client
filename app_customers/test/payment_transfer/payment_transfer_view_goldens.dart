import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/tranfersRepository.dart';
import 'package:app_customer/pages/money_transfert/money_transfert_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

class PaymentTransferViewWidget extends StatelessWidget {
  final Locale locale;

  PaymentTransferViewWidget({required this.locale});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AppInternationalization(locale));
    Get.put(TransferRepository(HiveService(HiveServiceType.fake)));

    return GetMaterialApp(
      locale: locale,
      fallbackLocale: Locale('en', 'US'),
      translations: AppInternationalization(locale),
      home: MoneyTransferView(displayInternetMessage: false),
    );
  }
}

void main() {
  group('Goldens', () {
    testGoldens('Payment Transfer us view', (tester) async {
      await tester
          .pumpWidget(PaymentTransferViewWidget(locale: Locale('en', 'US')));
      await multiScreenGolden(tester, 'payment_transfer_us_view');
    });

    testGoldens('Payment Transfer fr view', (tester) async {
      await tester
          .pumpWidget(PaymentTransferViewWidget(locale: Locale('fr', 'FR')));
      await multiScreenGolden(tester, 'payment_transfer_fr_view_fr');
    });
  });
}
