import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../themes/app_colors.dart';

/// The [Tooltip].
class MTooltip extends StatelessWidget {
  /// The tooltip controller.
  final TooltipController controller;

  /// The tooltip message.
  final String message;

  /// Constructor of new [MTooltip].
  const MTooltip({
    Key? key,
    required this.controller,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentDisplayIndex = controller.nextPlayIndex + 1;
    final totalLength = controller.playWidgetLength;
    final hasNextItem = currentDisplayIndex < totalLength;
    final hasPreviousItem = currentDisplayIndex != 1;
    final localization = Get.find<AppInternationalization>();

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(9)),
      ),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: totalLength == 1 ? 0 : 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '$currentDisplayIndex ${localization.of} $totalLength',
                    style: TextStyle(
                      color: AppColors.gray,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: controller.dismiss,
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircleAvatar(
                    backgroundColor: AppColors.darkBlack,
                    child: Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(message),
          const SizedBox(
            height: 16,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.lightGray,
          ),
          const SizedBox(
            height: 16,
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: hasPreviousItem ? 1 : 0,
                  child: TextButton(
                    onPressed: controller.previous,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(9)),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        localization.prev,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: controller.next,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(9)),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      hasNextItem ? localization.next : localization.complete,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
