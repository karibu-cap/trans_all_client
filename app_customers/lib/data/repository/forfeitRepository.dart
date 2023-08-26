import 'package:trans_all_common_models/models.dart';

import '../database/hive_service.dart';

/// The transfer repository.
class ForfeitRepository {
  final HiveService _hiveService;

  /// Constructs a new [ForfeitRepository].
  ForfeitRepository(this._hiveService);

  /// Retrieves all the local forfeit.
  Future<List<Forfeit>?> getAllForfeit() => _hiveService.getAllForfeit();

  /// Retrieves forfeit by id.
  Forfeit? getForfeitById(String forfeitId) =>
      _hiveService.getForfeitById(forfeitId);
}
