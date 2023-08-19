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

/// The payment methods available.
class PaymentMethodView extends StatelessWidget {
  /// The list of supported payment gateway.
  final List<PaymentGateways> supportedPayment;

  /// Constructor of new [PaymentMethodView].
  const PaymentMethodView(this.supportedPayment);

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();

    return Container(
      height: 100,
      padding: EdgeInsets.all(10),
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
                  '${localization.availablePayment} ',
                  style: AppTextStyles.headerH3Label,
                ),
                OverlayTooltipItem(
                  displayIndex: 0,
                  tooltipHorizontalPosition: TooltipHorizontalPosition.LEFT,
                  tooltip: (controller) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: MTooltip(
                      controller: controller,
                      message: localization.availablePaymentDescription,
                    ),
                  ),
                  child: QuestionMaskView(
                    index: 0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          _AvailablePaymentGateway(supportedPayment),
        ],
      ),
    );
  }
}

class _AvailablePaymentGateway extends StatelessWidget {
  final List<PaymentGateways> supportedPayment;

  const _AvailablePaymentGateway(this.supportedPayment);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: supportedPayment.map<Widget>((currentPayment) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: OperatorIcon(operatorType: currentPayment.id.key),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
