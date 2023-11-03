import 'dart:async';

import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
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
  final logger = Logger('Init Hive box');
  Hive.registerAdapter(TransferInfoAdapter());
  Hive.registerAdapter(PaymentGatewaysAdapter());
  Hive.registerAdapter(OperationGatewaysAdapter());
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(DefaultBuyerContactAdapter());
  Hive.registerAdapter(ForfeitAdapter());

  await Hive.close();

  try {
    await Hive.openBox<PaymentGateways>(Constant.paymentGatewaysTable);
  } catch (e) {
    logger.severe(
      'An error occurs when open payment gateways box data, the data will be clear.',
    );
    await Hive.deleteBoxFromDisk(Constant.paymentGatewaysTable);
    await Hive.openBox<PaymentGateways>(Constant.paymentGatewaysTable);
  }
  try {
    await Hive.openBox<OperationGateways>(Constant.operatorTable);
  } catch (e) {
    logger.severe(
      'An error occurs when open operator box data, the data will be clear.',
    );
    await Hive.deleteBoxFromDisk(Constant.operatorTable);
    await Hive.openBox<OperationGateways>(Constant.operatorTable);
  }
  try {
    await Hive.openBox<TransferInfo>(Constant.creditTransactionTable);
  } catch (e) {
    logger.severe(
      'An error occurs when open transaction table, the data will be clear.',
    );
    await Hive.deleteBoxFromDisk(Constant.creditTransactionTable);
    await Hive.openBox<TransferInfo>(Constant.creditTransactionTable);
  }
  try {
    await Hive.openBox<Forfeit>(Constant.forfeitTable);
  } catch (e) {
    logger.severe(
      'An error occurs when open forfeit table, the data will be clear.',
    );
    await Hive.deleteBoxFromDisk(Constant.forfeitTable);
    await Hive.openBox<Forfeit>(Constant.forfeitTable);
  }

  await Hive.openBox<Contact>(Constant.contactTable);
  await Hive.openBox<Contact>(Constant.defaultBuyerContactsTable);
}
