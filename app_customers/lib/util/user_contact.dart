import 'package:contacts_service/contacts_service.dart' as contactService;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trans_all_common_models/models.dart';

import '../data/repository/contactRepository.dart';
import 'preferences_keys.dart';

/// The user contact.
class UserContactConfig {
  /// Get contact permission state.
  static ContactPermissionState contactPermissionState =
      ContactPermissionState.pending;

  static BehaviorSubject<List<Contact>> userContact =
      BehaviorSubject.seeded([]);

  /// Init user contact.
  static Future<bool> init({bool? requestContactPermission}) async {
    final pref = await SharedPreferences.getInstance();

    final canRequestToContactPermission =
        (await SharedPreferences.getInstance())
            .getBool(PreferencesKeys.requestContactPermission);
    if (canRequestToContactPermission == true ||
        requestContactPermission == true) {
      final contactRepository = Get.find<ContactRepository>();
      final PermissionStatus permission = await Permission.contacts.status;
      if (permission != PermissionStatus.granted &&
          permission != PermissionStatus.permanentlyDenied) {
        final PermissionStatus permissionStatus =
            await Permission.contacts.request();
        if (permissionStatus == PermissionStatus.granted) {
          await pref.setBool(PreferencesKeys.requestContactPermission, true);
          final contacts = await contactService.ContactsService.getContacts();
          contactPermissionState = ContactPermissionState.allow;
          final Map<String, String> setOfContact = {};
          for (final contact in contacts) {
            final name = contact.displayName;
            final phones = contact.phones;
            if (name != null &&
                name.isNotEmpty &&
                phones != null &&
                phones.isNotEmpty) {
              for (final phone in phones) {
                setOfContact[clearPhoneNumber(phone.value ?? '')] = name;
              }
            }
          }

          final List<Contact> newContacts = await listOfContact(
            setOfContact,
            contactRepository,
          );

          userContact.add(newContacts);

          return true;
        }
        contactPermissionState = ContactPermissionState.denied;

        return false;
      } else {
        if (permission == PermissionStatus.granted) {
          contactPermissionState = ContactPermissionState.allow;
          await pref.setBool(PreferencesKeys.requestContactPermission, true);

          final localContact = contactRepository.getAllLocalContact();
          if (localContact.isNotEmpty) {
            userContact.add(localContact.toList());

            return true;
          }
          final contacts = await contactService.ContactsService.getContacts();
          final Map<String, String> setOfContact = {};
          for (final contact in contacts) {
            final name = contact.displayName;
            final phones = contact.phones;
            if (name != null &&
                name.isNotEmpty &&
                phones != null &&
                phones.isNotEmpty) {
              for (final phone in phones) {
                setOfContact[clearPhoneNumber(phone.value ?? '')] = name;
              }
            }
          }

          final List<Contact> newContacts = await listOfContact(
            setOfContact,
            contactRepository,
          );

          userContact.add(newContacts);

          return true;
        }
        contactPermissionState = ContactPermissionState.denied;

        return false;
      }
    }
    return false;
  }

  static String clearPhoneNumber(String phoneNumber) {
    return phoneNumber
        .replaceAll('+', '')
        .replaceAll('237', '')
        .replaceAll(' ', '');
  }
}

/// Construct the list of contact.
Future<List<Contact>> listOfContact(
  Map<String, String> setOfContact,
  ContactRepository contactRepository,
) async {
  final List<Contact> listOfContact = [];
  for (var entry in setOfContact.entries) {
    final contact = Contact.fromJson({
      Contact.keyId: DateTime.now().hashCode.toString(),
      Contact.keyIsBuyerContact: false,
      Contact.keyName: entry.value,
      Contact.keyPhoneNumber: entry.key,
    });
    await contactRepository.createUserContact(
      contact,
      contactId: DateTime.now().hashCode.toString(),
    );
    listOfContact.add(contact);
  }

  return listOfContact;
}

enum ContactPermissionState {
  allow,
  denied,
  pending,
}
