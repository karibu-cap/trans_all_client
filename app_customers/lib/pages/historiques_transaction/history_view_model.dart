import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/contactRepository.dart';
import '../../data/repository/tranferRepository.dart';
import '../../themes/app_colors.dart';

/// The history view model.
class HistoryViewModel {
  final TransferRepository _transferRepository;
  final ContactRepository _contactRepository;

  /// Returns the list of transfers.
  final Rx<List<TransferInfo>?> _listOfTransfers =
      Rx<List<TransferInfo>?>(null);

  /// The list of stats.
  Rx<List<TransferStat>> listOfStats = Rx<List<TransferStat>>([]);

  /// The list of contact.
  List<Contact> listOfContact = [];

  /// Returns the list of transfers.
  Rx<List<TransferInfo>?> get listOfTransfers => _listOfTransfers;

  /// Constructs a new History model.
  HistoryViewModel({
    required TransferRepository transferRepository,
    required ContactRepository contactRepository,
  })  : _transferRepository = transferRepository,
        _contactRepository = contactRepository {
    _fetchAllLocalTransaction();
  }

  void _fetchAllLocalTransaction() {
    _listOfTransfers.value?.clear();
    final allTransaction = _transferRepository.getAllLocalTransaction();
    _listOfTransfers.value = allTransaction;
    updateTransactionStat(allTransaction);
    updateUserContacts();
  }

  /// Gets user new contact.
  void updateUserContacts() {
    listOfContact = _contactRepository.getAllLocalContact().toList();

    return;
  }

  /// Updates the list of stats.
  void updateTransactionStat(List<TransferInfo> allTransaction) {
    final intl = Get.find<AppInternationalization>();
    int successTransferCount = 0;
    int failedTransferCount = 0;
    int waitingTransferCount = 0;

    for (final transaction in allTransaction) {
      final paymentStatus = transaction.payments.last.status.key;
      final transferStatus = transaction.status.key;

      if (transferStatus == TransferStatus.completed.key ||
          transferStatus == TransferStatus.succeeded.key) {
        successTransferCount++;
      } else if (transferStatus == TransferStatus.failed.key ||
          transferStatus == TransferStatus.paymentFailed.key ||
          paymentStatus == PaymentStatus.failed.key) {
        failedTransferCount++;
      } else {
        waitingTransferCount++;
      }
    }
    listOfStats.value = [
      TransferStat(
        transferCount: successTransferCount,
        transferStatus: intl.succeed,
        color: AppColors.lightGreen,
      ),
      TransferStat(
        transferCount: failedTransferCount,
        transferStatus: intl.cancelled,
        color: AppColors.red2,
      ),
      TransferStat(
        transferCount: waitingTransferCount,
        transferStatus: intl.pending,
        color: AppColors.purple,
      ),
    ];
  }
}

/// The transfer stat.
class TransferStat {
  /// The transfer status.
  final String transferStatus;

  /// The list of transfer base on the status.
  final int transferCount;

  /// The range color.
  final Color color;

  /// Constructor of new [TransferStat].
  TransferStat({
    required this.transferStatus,
    required this.transferCount,
    required this.color,
  });
}
