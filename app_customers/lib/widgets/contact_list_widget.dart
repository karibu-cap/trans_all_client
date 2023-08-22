import 'package:flutter/material.dart';
import 'package:trans_all_common_models/models.dart';

import '../themes/app_colors.dart';

/// Display the list of contact view.
class ContactListWidget extends StatelessWidget {
  /// The scroll controller.
  final ScrollController? scrollController;

  /// The list of contact to display.
  final List<Contact> listOfContact;

  /// Action onPress to the contact.
  final void Function(Contact) onContactPressed;

  /// Constructs a new [ContactListWidget].
  const ContactListWidget({
    super.key,
    required this.listOfContact,
    required this.onContactPressed,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: listOfContact.length,
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final contact = listOfContact[index];

        final firstValue = RegExp(r'[a-zA-Z]').hasMatch(contact.name)
            ? contact.name.length > 1
                ? contact.name.substring(0, 2).toUpperCase()
                : contact.name[0]
            : '';

        return InkWell(
          onTap: () => onContactPressed(contact),
          child: Card(
            child: ListTile(
              leading: firstValue.isEmpty
                  ? CircleAvatar(
                      backgroundColor: contact.color,
                      child: Icon(
                        Icons.person,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: contact.color,
                      child: Text(
                        firstValue,
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              title: Text(contact.name),
              subtitle: Text(contact.phoneNumber),
            ),
          ),
        );
      },
    );
  }
}
