import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../../widgets/contact_list_widget.dart';
import '../transfer_controller_view.dart';

/// The default buyer contacts view.
class DefaultBuyerContactsView extends StatelessWidget {
  /// The function using to update the contact field.
  final Function(String number) onPressToContact;

  /// Constructor of new [DefaultBuyerContactsView].
  const DefaultBuyerContactsView({required this.onPressToContact});

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final controller = Get.find<TransfersController>();

    return StreamBuilder<List<Contact>>(
      stream: controller.streamOfBuyerContact.stream,
      builder: (context, snapshot) {
        final defaultBuyerNumber = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.saveContactNumber,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (defaultBuyerNumber.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      localization.emptyBuyerContactsList,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              if (defaultBuyerNumber.isNotEmpty)
                Expanded(
                  child: ContactListWidget(
                    listOfContact: defaultBuyerNumber,
                    onContactPressed: ((contact) {
                      controller.updatePayerContact(
                        contact.phoneNumber,
                      );
                      Navigator.pop(context);
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
