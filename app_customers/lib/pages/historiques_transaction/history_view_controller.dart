import 'package:get/get.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/forfeitRepository.dart';
import '../../data/repository/tranfersRepository.dart';
import 'history_view_model.dart';

/// The history view controller.
class HistoryViewController extends GetxController {
  final HistoryViewModel _historyModel;
  final TransferRepository _transferRepository;
  final ForfeitRepository _forfeitRepository;

  /// Returns the list of transfers.
  Rx<List<TransferInfo>?> get listOfTransfers => _historyModel.listOfTransfers;

  /// The list of contact.
  List<Contact> get listOfContact => _historyModel.listOfContact;

  /// The list of stats.
  Rx<List<TransferStat>> get listOfStats => _historyModel.listOfStats;

  /// Constructs the new  history view controller.
  HistoryViewController({
    required HistoryViewModel historyModel,
    required TransferRepository transferRepository,
    required ForfeitRepository forfeitRepository,
  })  : _historyModel = historyModel,
        _forfeitRepository = forfeitRepository,
        _transferRepository = transferRepository {
    watchTransferHistory();
  }

  /// Returns the list of transfer.
  Future<void> watchTransferHistory() async {
    _transferRepository.streamAllLocalTransaction().listen((event) {
      listOfTransfers.value?.clear();
      final allTransaction = _transferRepository.getAllLocalTransaction();
      listOfTransfers.value = allTransaction;
      _historyModel.updateTransactionStat(allTransaction);
    });
    update();
  }

  /// Gets the asset payment image.
  String? getAssetPaymentImage(String featureReference) {
    if (featureReference == OperationTransferType.mtnUnitTransfer.key) {
      return 'assets/icons/payment_mtn_icon.png';
    }
    if (featureReference == OperationTransferType.orangeUnitTransfer.key) {
      return 'assets/icons/payment_orange_icon.png';
    }
    if (featureReference == OperationTransferType.camtelUnitTransfer.key) {
      return 'assets/icons/camtel.png';
    }

    return null;
  }

  /// Returns the duration.
  int getDuration(DateTime preDate) {
    final Duration duration = DateTime.now().difference(preDate);

    return duration.inDays;
  }

  /// Gets the user name.
  String? getUserName(String phoneNumber) {
    if (listOfContact.isEmpty) {
      return null;
    }
    final contact = listOfContact
        .where((element) => RegExp(phoneNumber).hasMatch(element.phoneNumber
            .replaceAll('+', '')
            .replaceAll('237', '')
            .replaceAll(' ', '')))
        .toList();
    if (contact.isNotEmpty) {
      final newContact = contact.firstWhereOrNull((element) => !RegExp(r'^\d+$')
          .hasMatch(element.name
              .replaceAll('+', '')
              .replaceAll('237', '')
              .replaceAll(' ', '')));

      return newContact != null ? newContact.name : null;
    }

    return null;
  }

  /// Checks if user can save the number.
  bool canUserSaveNumber(String number) {
    if (number.isEmpty) {
      return false;
    }

    final saveContactNumber = listOfContact.firstWhereOrNull(
      (element) =>
          RegExp(number).hasMatch(element.phoneNumber
              .replaceAll('+', '')
              .replaceAll('237', '')
              .replaceAll(' ', '')) &&
          element.isBuyerContact,
    );
    if (saveContactNumber == null) {
      return true;
    }

    return false;
  }

  /// Retrieves the current forfeit.
  Forfeit? getCurrentForfeit(
    String? forfeitId,
  ) {
    if (forfeitId == null || forfeitId.isEmpty) {
      return null;
    }

    return _forfeitRepository.getForfeitById(forfeitId);
  }
}
