import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../../themes/app_colors.dart';
import '../../../util/constant.dart';
import '../../../util/sort_contact.dart';
import '../../../util/user_contact.dart';
import '../../../widgets/contact_list_widget.dart';
import '../../../widgets/m_tooltip.dart';
import '../transfer_controller_view.dart';

/// The contact view.
class ContactWidget extends StatelessWidget {
  /// The function using to update the contact field.
  final Function(String number) onPressToContact;

  /// The tooltip description message.
  final String tooltipDescriptionMessage;

  /// The tooltip index .
  final int index;

  /// The box title.
  final String title;

  /// The list of contact.
  final List<Contact> contacts;

  /// Constructor of new [ContactWidget].
  const ContactWidget({
    required this.onPressToContact,
    required this.index,
    required this.tooltipDescriptionMessage,
    required this.title,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    final border = Radius.circular(25.0);

    return OverlayTooltipItem(
      displayIndex: index,
      tooltip: (controller) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: MTooltip(
          controller: controller,
          message: tooltipDescriptionMessage,
        ),
      ),
      child: InkWell(
        onLongPress: () =>
            OverlayTooltipScaffold.of(context)?.controller.start(index),
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: border,
              topRight: border,
            ),
          ),
          builder: (context) => Builder(
            builder: (context) {
              return _ContactsView(
                onPressToContact: onPressToContact,
                contacts: contacts,
                title: title,
              );
            },
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.people,
              color: AppColors.black,
            ),
            Icon(
              Icons.keyboard_arrow_down_sharp,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactsView extends StatelessWidget {
  /// The function using to update the contact field.
  final Function(String number) onPressToContact;

  /// The list of contact.
  final List<Contact> contacts;

  /// The box title.
  final String title;

  const _ContactsView({
    required this.onPressToContact,
    required this.title,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final controller = Get.find<TransfersController>();
    final contactPermissionState = UserContactConfig.contactPermissionState;

    return StreamBuilder<List<Contact>>(
      stream: controller.streamOfContact.stream,
      builder: (context, snapshot) {
        final contactsList = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.only(
            top: 25.0,
            left: 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.contact,
                style: TextStyle(
                  color: AppColors.darkBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (contactsList.isNotEmpty)
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              if (contactsList.isNotEmpty) _SearchContact(),
              SizedBox(
                height: 10,
              ),
              if (contactsList.isEmpty &&
                  contactPermissionState == ContactPermissionState.allow)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        AnimationAsset.noItem,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        localization.noContactFound,
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              if (contactsList.isEmpty &&
                  contactPermissionState != ContactPermissionState.allow)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      localization.contactRequestMessage,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        controller.updateLoadOfContacts(true);
                        await UserContactConfig.init(
                            requestContactPermission: true);
                        final PermissionStatus permission =
                            await Permission.contacts.status;
                        if (!permission.isGranted) {
                          controller.updateLoadOfContacts(false);

                          return;
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.darkBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(9)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          localization.allowAccess,
                          style: const TextStyle(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: controller.loadTheContacts,
                      builder: (context, value, child) {
                        return controller.loadTheContacts.value &&
                                contactsList.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: Lottie.asset(
                                      AnimationAsset.loading,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    localization.waitMessage,
                                    style: const TextStyle(
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox();
                      },
                    ),
                  ],
                ),
              if (controller.contactFilterTextController.text.isNotEmpty &&
                  controller.filterContactList.value.isEmpty)
                Expanded(
                  child: Center(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            AnimationAsset.noItem,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            localization.noResultFound,
                            style: TextStyle(
                              color: AppColors.darkBlack,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    ContactListWidget(
                      listOfContact:
                          controller.contactFilterTextController.text.isEmpty
                              ? sortContactByName(contactsList)
                              : sortContactByName(
                                  controller.filterContactList.value,
                                ),
                      onContactPressed: (contactValue) {
                        onPressToContact(
                          contactValue.phoneNumber,
                        );
                        Navigator.pop(context);
                      },
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: FloatingActionButton(
                        backgroundColor: AppColors.darkBlack,
                        tooltip: localization.refresh,
                        onPressed: () async {
                          unawaited(
                              controller.animateController.value.repeat());
                          final request = await UserContactConfig.init(
                              requestContactPermission: true);
                          await Future.delayed(
                            const Duration(seconds: 3),
                          );
                          if (request) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.darkBlack,
                                behavior: SnackBarBehavior.floating,
                                dismissDirection: DismissDirection.up,
                                content: Text(
                                  localization.contactRefreshed,
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                          controller.animateController.value.stop();
                        },
                        child: RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0).animate(
                            controller.animateController.value,
                          ),
                          child: Icon(Icons.refresh),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransfersController>();
    final localization = Get.find<AppInternationalization>();

    return TextField(
      controller: controller.contactFilterTextController,
      onChanged: controller.filterUserContact,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.gray.withOpacity(0.07),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkBlack,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkBlack,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        suffixIcon: Icon(
          Icons.search,
          color: AppColors.black,
        ),
        labelText: localization.search,
        labelStyle: TextStyle(color: AppColors.black),
        hintStyle: TextStyle(
          color: AppColors.lightGray.withOpacity(
            0.4,
          ),
        ),
      ),
    );
  }
}
