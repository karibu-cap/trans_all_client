import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

import '../database/hive_service.dart';

/// The user contact repository.
class ContactRepository {
  final HiveService _hiveService;

  /// Constructs a new [ContactRepository].
  ContactRepository(this._hiveService);

  /// Gets the local user contact.
  Set<Contact> getAllLocalContact() => _hiveService.getAllLocalContact();

  /// Gets the local user contact.
  Set<Contact> getAllLocalBuyerContact() =>
      _hiveService.getAllLocalBuyerContact();

  /// Gets set the local user contact.
  Future<void> createUserContact(
    Contact contactInFo, {
    String? contactId,
  }) =>
      _hiveService.createUserContact(
        contactInFo,
        contactId: contactId,
      );

  /// Updates user contact.
  Future<void> addUserBuyerContact(
    Contact contactInFo,
    String contactId,
  ) =>
      _hiveService.addUserBuyerContact(contactInFo, contactId: contactId);

  /// Updates user contact.
  Stream<BoxEvent> streamUserContact() => _hiveService.streamUserContact();
}
