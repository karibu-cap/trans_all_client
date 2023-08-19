import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../../themes/app_colors.dart';
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
                  color: AppColors.darkBlack,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (defaultBuyerNumber.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/icons/no_item.json',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          localization.emptyBuyerContactsList,
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (defaultBuyerNumber.isNotEmpty)
                Expanded(
                  child: ContactListWidget(
                    listOfContact: defaultBuyerNumber,
                    onContactPressed: (contact) {
                      controller.updatePayerContact(
                        contact.phoneNumber,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
