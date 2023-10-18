import 'dart:async';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:trans_all_common_models/models.dart';

import '../data/repository/tranferRepository.dart';

/// Checks if the transaction is on pending state.
bool isPendingTransaction(TransferInfo transferInfo) {
  if (transferInfo.status.key == TransferStatus.succeeded.key ||
      transferInfo.status.key == TransferStatus.completed.key ||
      transferInfo.status.key == TransferStatus.failed.key ||
      transferInfo.payments.last.status.key == PaymentStatus.failed.key ||
      transferInfo.status.key == TransferStatus.paymentFailed.key) {
    return false;
  }

  return true;
}

/// Checks if the transaction is on failed state.
bool isFailedTransaction(TransferInfo transferInfo) {
  if (transferInfo.status.key == TransferStatus.failed.key ||
      transferInfo.payments.last.status.key == PaymentStatus.failed.key ||
      transferInfo.status.key == TransferStatus.paymentFailed.key) {
    return true;
  }

  return false;
}

/// Checks if the transaction is on success state.
bool isSuccessTransaction(TransferInfo transferInfo) {
  if (transferInfo.status.key == TransferStatus.succeeded.key ||
      transferInfo.status.key == TransferStatus.completed.key) {
    return true;
  }

  return false;
}

/// Streams and updates the pending transaction.
Future<void> streamPendingTransaction() async {
  final Logger _logger = Logger('Schedule airtime transaction update');
  final TransferRepository transferRepository = Get.find<TransferRepository>();

  /// Schedule every 15 seconds.
  Timer.periodic(Duration(seconds: 15), (timer) async {
    /// Retrieve the pending  airtime transaction.
    final pendingTransaction =
        transferRepository.getAllLocalTransaction().where(isPendingTransaction);
    _logger.info(
      'There are ${pendingTransaction.length} transaction with pending status.',
    );
    if (pendingTransaction.isNotEmpty) {
      for (final transaction in pendingTransaction) {
        _logger.info(
          'the transaction id ${transaction.id} have a '
          'transfer status ${transaction.status.key} and '
          'payment status ${transaction.payments.first.status.key}.',
        );

        /// Set to failed if the transaction status is pending since 1 week.
        if (transaction.isOlderThanAWeek()) {
          _logger.info(
            'the transaction id ${transaction.id} have a '
            'transaction status ${transaction.status.key} and '
            'payment status ${transaction.payments.first.status.key} is passed '
            '1 week; the transaction will be set to failed.',
          );
          await transferRepository.updateLocalTransactionStatus(
            transaction.id,
            TransferStatus.failed.key,
            false,
          );
        } else {
          final remoteTransaction = await transferRepository.getTheTransaction(
            transactionId: transaction.id,
          );

          if (remoteTransaction != null) {
            _logger.info(
              'New update of  transaction with id ${transaction.id} is received with data: ${remoteTransaction.toJson()}',
            );

            await transferRepository.updateLocalTransaction(
              transaction.id,
              remoteTransaction,
            );
          }
        }
      }
    }
  });
}
