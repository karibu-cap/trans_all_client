import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:trans_all_common_config/config.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes/app_colors.dart';
import '../alert_box.dart';
import 'contact_service_model.dart';

/// The ContactChatButton widget.
class ContactButtonService extends StatelessWidget {
  /// DeleteWidgetAnimationDuration accepts an animation duration value which
  /// is used to animate the delete widget.
  final int deleteWidgetAnimationDuration;

  /// HasDeleteWidgetAnimationDuration accepts an animation duration value
  ///  which is used to animate the delete widget.
  final int hasDeleteWidgetAnimationDuration;

  /// Constructor of [ContactButtonService].
  const ContactButtonService({
    Key? key,
    this.deleteWidgetAnimationDuration = 200,
    this.hasDeleteWidgetAnimationDuration = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double floatingWidgetWidth = 60;
    final double floatingWidgetHeight = 60;

    return _FloatingDraggableWidgetView(
      deleteWidgetAnimationDuration: deleteWidgetAnimationDuration,
      hasDeleteWidgetAnimationDuration: hasDeleteWidgetAnimationDuration,
      floatingWidgetWidth: floatingWidgetWidth,
      floatingWidgetHeight: floatingWidgetHeight,
    );
  }
}

class _FloatingDraggableWidgetView extends GetView<ContactServiceModel> {
  final double floatingWidgetWidth;
  final double floatingWidgetHeight;
  final int deleteWidgetAnimationDuration;
  final int hasDeleteWidgetAnimationDuration;

  const _FloatingDraggableWidgetView({
    Key? key,
    this.deleteWidgetAnimationDuration = 700,
    this.hasDeleteWidgetAnimationDuration = 900,
    required this.floatingWidgetWidth,
    required this.floatingWidgetHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();

    final deleteWidgetKey = GlobalKey();
    final floatingWidgetKey = GlobalKey();

    return GetBuilder<ContactServiceModel>(
      builder: (controller) => FutureBuilder<bool>(
        future: controller.onButtonCollapsed(),
        builder: (context, snapshot) {
          final isButtonCollapsed = snapshot.data;

          if (isButtonCollapsed == null) {
            return SizedBox();
          }

          Future<void> confirmationBox() async {
            showAlertBoxView(
              context: context,
              icon: Icon(
                Icons.question_mark,
                color: AppColors.white,
                size: 30,
              ),
              topBackgroundColor: AppColors.darkGray,
              negativeBtnText: localization.noThank,
              positiveBtnText: localization.yes,
              positiveBtnPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                final String contactCustomerSupportLink =
                    RemoteConfig().getString(
                  RemoteConfigKeys.customerServiceLink,
                );
                await launchUrl(
                  Uri.parse(contactCustomerSupportLink),
                  mode: LaunchMode.externalApplication,
                );
              },
              content: Text(localization.chatServiceMessage),
            );
          }

          return GestureDetector(
            child: LayoutBuilder(
              builder: (context, boxConstraint) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(seconds: 1),
                        top: MediaQuery.of(context).size.height / 4,
                        left: isButtonCollapsed
                            ? MediaQuery.of(context).size.width - 25
                            : MediaQuery.of(context).size.width,
                        child: Material(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 5,
                            ),
                            width: 30,
                            decoration: BoxDecoration(
                              color: AppColors.darkGray,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: confirmationBox,
                              child: Transform.rotate(
                                angle: 3.14,
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Text(
                                    localization.chatHelperMessage,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        top: controller.isDragging
                            ? MediaQuery.of(context).size.height - 180
                            : MediaQuery.of(context).size.height +
                                floatingWidgetHeight,
                        left: boxConstraint.maxWidth / 2 - floatingWidgetWidth,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 50),
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            key: deleteWidgetKey,
                            height: 60,
                            width: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.darkGray,
                                shape: BoxShape.circle,
                                border: const Border.fromBorderSide(
                                  BorderSide(width: 4, color: AppColors.white),
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!isButtonCollapsed)
                        AnimatedPositioned(
                          top: controller.top == -1
                              ? (MediaQuery.of(context).size.height -
                                      floatingWidgetHeight -
                                      MediaQuery.of(context).padding.top -
                                      floatingWidgetWidth) -
                                  200
                              : controller.top - floatingWidgetHeight,
                          left: controller.left == -1 ? 10 : controller.left,
                          duration: Duration(
                            milliseconds: controller.isDragging ? 100 : 700,
                          ),
                          curve:
                              controller.top >=
                                          (MediaQuery.of(context).size.height -
                                              floatingWidgetHeight) ||
                                      controller.left >=
                                          (MediaQuery.of(context).size.width -
                                              floatingWidgetWidth) ||
                                      controller.top <= floatingWidgetHeight ||
                                      controller.left <= 1
                                  ? Curves.bounceOut
                                  : Curves.ease,
                          child: GestureDetector(
                            onPanStart: (_) => controller.onPanStart(),
                            onPanUpdate: (details) => controller.onPanUpdate(
                              details: details,
                              context: context,
                            ),
                            onPanEnd: (details) => controller.onPanEnd(
                              details: details,
                              context: context,
                              floatingWidgetKey: floatingWidgetKey,
                              deleteWidgetKey: deleteWidgetKey,
                            ),
                            onTap: confirmationBox,
                            child: SizedBox(
                              key: floatingWidgetKey,
                              child: _FloatingButton(),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _FloatingButton extends GetView<ContactServiceModel> {
  const _FloatingButton();

  @override
  Widget build(BuildContext context) {
    final tooltipController = JustTheController();
    final localization = Get.find<AppInternationalization>();
    if (controller.displayTooltip) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) =>
            Future.delayed(Duration(seconds: 2), tooltipController.showTooltip),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          child: JustTheTooltip(
            onDismiss: controller.cancelDisplayOfTooltip,
            backgroundColor: AppColors.darkGray,
            controller: tooltipController,
            preferredDirection: AxisDirection.up,
            child: Column(
              children: [
                SizedBox(height: 8),
                FloatingActionButton(
                  backgroundColor: AppColors.darkGray,
                  onPressed: null,
                  child: Icon(
                    Icons.support_agent,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            content: !controller.displayTooltip
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      localization.chatHelperMessage,
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
