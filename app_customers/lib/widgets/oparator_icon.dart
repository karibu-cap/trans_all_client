import 'package:flutter/material.dart';
import 'package:trans_all_common_models/models.dart';

import '../themes/app_colors.dart';

/// The [OperatorIcon].
class OperatorIcon extends StatelessWidget {
  /// The operator type.
  final String operatorType;

  /// Constructor of new [OperatorIcon].
  const OperatorIcon({required this.operatorType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (operatorType == PaymentId.orangePaymentId.key) {
      return Container(
        height: 40,
        width: 40,
        padding: const EdgeInsets.all(2.0),
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border.fromBorderSide(
            BorderSide(color: AppColors.lightGray),
          ),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: FittedBox(
          child: Image.asset(
            'assets/icons/payment_orange_icon.png',
            height: 30,
            width: 20,
          ),
        ),
      );
    }
    if (operatorType == PaymentId.mtnPaymentId.key) {
      return Image.asset(
        'assets/icons/payment_mtn_icon.png',
        height: 40,
        width: 40,
      );
    }
    if (operatorType == OperationTransferType.mtnUnitTransfer.key) {
      return Image.asset(
        'assets/icons/mtn_operator.png',
        height: 40,
        width: 40,
      );
    }
    if (operatorType == OperationTransferType.orangeUnitTransfer.key) {
      return Container(
        alignment: Alignment.center,
        height: 40,
        width: 40,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: AppColors.orange,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: FittedBox(
          child: Text(
            'orange',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    if (operatorType == OperationTransferType.camtelUnitTransfer.key) {
      return Image.asset(
        'assets/icons/camtel.png',
        height: 40,
        width: 40,
      );
    }

    if (operatorType == OperationTransferType.yoomeeUnitTransfer.key) {
      return Container(
        alignment: Alignment.center,
        height: 40,
        width: 40,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: FittedBox(
          child: Text(
            'Yoomee',
            style: TextStyle(
              color: AppColors.red2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return SizedBox();
  }
}
