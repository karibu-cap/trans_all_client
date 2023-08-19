import 'base_model.dart';

/// The contact model.
class Contact extends BaseModel {
  /// The stored key ref for the [phoneNumber] property.
  static const keyPhoneNumber = 'phoneNumber';

  /// The stored key ref for the [id] property.
  static const keyId = 'id';

  /// The stored key ref for the [isBuyerContact] property.
  static const keyIsBuyerContact = 'isBuyerContact';

  /// The stored key ref for the [name] property.
  static const keyName = 'name';

  /// The name of contact.
  final String name;

  /// The name of id.
  final String id;

  /// The phone of contact.
  final String phoneNumber;

  /// Define the contact as default buyer.
  final bool isBuyerContact;

  @override
  int get hashCode => name.hashCode ^ phoneNumber.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          phoneNumber
                  .replaceAll('+', '')
                  .replaceAll('237', '')
                  .replaceAll(' ', '') ==
              other.phoneNumber
                  .replaceAll('+', '')
                  .replaceAll('237', '')
                  .replaceAll(' ', '');

  /// Constructs a new [Contact] from [Map] object.
  Contact.fromJson(
    Map<String, dynamic> json,
  )   : name = json[keyName],
        phoneNumber = json[keyPhoneNumber],
        id = json[keyId],
        isBuyerContact = json[keyIsBuyerContact],
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyName: name,
        keyPhoneNumber: phoneNumber,
        keyId: id,
        keyIsBuyerContact: isBuyerContact,
      };
}
