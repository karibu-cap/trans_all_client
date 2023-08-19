import 'package:trans_all_common_models/models.dart';

/// Sort the contact list base on the list.
/// we need to display firstly the contact with name before
///  display display those who are not register.
List<Contact> sortContactByName(List<Contact> listOfContact) {
  listOfContact.sort((a, b) {
    if (_isStartByLetter(a.name) && !_isStartByLetter(b.name)) {
      return -1;
    } else if (!_isStartByLetter(a.name) && _isStartByLetter(b.name)) {
      return 1;
    } else if (_isStartByLetter(a.name) && _isStartByLetter(b.name)) {
      return a.name.compareTo(b.name);
    } else {
      return 0;
    }
  });

  return listOfContact;
}

bool _isStartByLetter(String value) {
  final letterRegex = RegExp(r'^[a-zA-Z]');

  return letterRegex.hasMatch(value);
}
