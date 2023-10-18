import 'dart:async';

import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

import '../data/database/hive_model/contacts.dart';
import '../data/database/hive_model/default_buyer_contact.dart';
import '../data/database/hive_model/forfeit_info.dart';
import '../data/database/hive_model/operator_info.dart';
import '../data/database/hive_model/payment_gateway_info.dart';
import '../data/database/hive_model/transfert_info.dart';
import '../util/constant.dart';

/// The app config function.
Future<void> appConfig() async {
  Hive.registerAdapter(TransferInfoAdapter());
  Hive.registerAdapter(PaymentGatewaysAdapter());
  Hive.registerAdapter(OperationGatewaysAdapter());
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(DefaultBuyerContactAdapter());
  Hive.registerAdapter(ForfeitAdapter());

  await Hive.openBox<TransferInfo>(Constant.creditTransactionTable);
  await Hive.openBox<Contact>(Constant.contactTable);
  await Hive.openBox<Contact>(Constant.defaultBuyerContactsTable);
  await Hive.openBox<OperationGateways>(Constant.operatorTable);
  await Hive.openBox<PaymentGateways>(Constant.paymentGatewaysTable);
  await Hive.openBox<Forfeit>(Constant.forfeitTable);
}
