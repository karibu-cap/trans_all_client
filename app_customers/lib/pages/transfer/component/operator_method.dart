import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../widgets/m_tooltip.dart';
import '../../../widgets/oparator_icon.dart';
import 'question_mask_view.dart';

/// Transfer airtime methods.
class TransferAirtimeMethod extends StatelessWidget {
  /// The supported operation.
  final List<OperationGateways> supportedOperation;

  /// Constructor of the [TransferAirtimeMethod].
  const TransferAirtimeMethod(this.supportedOperation);

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();

    return Container(
      padding: EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border.fromBorderSide(
          BorderSide(color: AppColors.lightGray),
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Row(
              children: [
                Text(
                  '${localization.availableOperator} ',
                  style: AppTextStyles.headerH3Label,
                ),
                OverlayTooltipItem(
                  displayIndex: 1,
                  tooltip: (controller) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: MTooltip(
                      controller: controller,
                      message: localization.availableOperatorDescription,
                    ),
                  ),
                  child: QuestionMaskView(
                    index: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          _AvailableOperatorGateway(supportedOperation),
        ],
      ),
    );
  }
}

class _AvailableOperatorGateway extends StatelessWidget {
  final List<OperationGateways> supportedOperation;

  const _AvailableOperatorGateway(this.supportedOperation);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: supportedOperation.map<Widget>((currentOperator) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: OperatorIcon(
              operatorType: currentOperator.operatorName.key,
            ),
          );
        }).toList(),
      ),
    );
  }
}
