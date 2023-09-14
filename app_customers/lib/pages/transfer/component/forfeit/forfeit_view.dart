import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karibu_capital_core_utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../../../data/repository/forfeitRepository.dart';
import '../../../../themes/app_colors.dart';
import '../../../../util/constant.dart';
import '../../../../util/key_internationalization.dart';
import '../../../../widgets/oparator_icon.dart';
import '../../transfer_controller_view.dart';
import 'forfeit_controller.dart';
import 'forfeit_view_model.dart';

/// The forfeit view.
class ForfeitView extends StatelessWidget {
  /// Constructs a new [ForfeitView].
  const ForfeitView({super.key});

  @override
  Widget build(BuildContext context) {
    final forfeitRepository = Get.find<ForfeitRepository>();
    final localization = Get.find<AppInternationalization>();
    final model = ForfeitViewModel(forfeitRepository);

    return ChangeNotifierProvider(
      create: (_) => ForfeitController(
        model: model,
        localization: localization,
      ),
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: _ForfeitBody(),
          );
        },
      ),
    );
  }
}

class _ForfeitBody extends StatelessWidget {
  const _ForfeitBody();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ForfeitController>(context);
    final localization = Get.find<AppInternationalization>();

    return FutureBuilder(
      future: controller.initializeDone.future,
      builder: (context, snapshot) {
        final listOfForfeit = controller.listOfForfeit;
        if (!controller.initializeDone.isCompleted) {
          return Center(
            child: Lottie.asset(
              AnimationAsset.loading,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          );
        }
        if (listOfForfeit.isEmpty) {
          return Center(
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
                  localization.noForfeitFound,
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        return _ForfeitSkeleton(
          listOfForfeit: listOfForfeit,
        );
      },
    );
  }
}

class _ForfeitSkeleton extends StatelessWidget {
  final List<Forfeit> listOfForfeit;
  const _ForfeitSkeleton({
    required this.listOfForfeit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        _OperatorView(),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: [
              _ForfeitCategoryView(),
              SizedBox(
                width: 3,
              ),
              _ValidityView(),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(child: _ForfeitFilterView()),
      ],
    );
  }
}

class _OperatorView extends StatelessWidget {
  const _OperatorView();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ForfeitController>(context);
    final localization = Get.find<AppInternationalization>();

    return controller.listOfOperatorType.length == 1
        ? SizedBox()
        : SizedBox(
            height: 40,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:
                  [localization.all, ...controller.listOfOperatorType].length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final operator = [
                  localization.all,
                  ...controller.listOfOperatorType,
                ].toList()[index];
                final operatorName = controller.getOperatorName(operator);

                return StreamBuilder<String>(
                  stream: controller.selectedOperator.stream,
                  builder: (context, snapshot) {
                    final isSelected = snapshot.data == operator;

                    return GestureDetector(
                      onTap: (() {
                        controller.selectedOperator.add(operator);
                        controller.updateFilterListOfForfeit();
                      }),
                      child: Container(
                        width: 90,
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppColors.darkGray : AppColors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
                          border: const Border.fromBorderSide(BorderSide(
                            color: AppColors.lightGray,
                          )),
                        ),
                        child: Center(
                          child: Text(
                            operator == localization.all
                                ? localization.all
                                : (operatorName ?? ''),
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
  }
}

class _ForfeitCategoryView extends StatelessWidget {
  const _ForfeitCategoryView();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ForfeitController>(context);

    return controller.listOfForfeitCategory.length == 1
        ? SizedBox()
        : SizedBox(
            height: 40,
            child: Row(
              children: List.generate(
                controller.listOfForfeitCategory.length,
                ((index) {
                  final forfeitCategory =
                      controller.listOfForfeitCategory.toList()[index];

                  if (forfeitCategory.category == Category.unknown) {
                    return SizedBox();
                  }

                  return GestureDetector(
                    onTap: () => controller.changeCategoryState(
                      !forfeitCategory.isSelected,
                      forfeitCategory,
                    ),
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: forfeitCategory.isSelected
                            ? AppColors.darkGray
                            : AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                        border: Border.all(
                          color: AppColors.lightGray,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          forfeitCategoryTranslate(
                              forfeitCategory.category.key),
                          style: TextStyle(
                            color: forfeitCategory.isSelected
                                ? AppColors.white
                                : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
  }
}

class _ValidityView extends StatelessWidget {
  const _ValidityView();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ForfeitController>(context);

    return controller.listOfForfeitValidity.length == 1
        ? SizedBox()
        : SizedBox(
            height: 40,
            child: Row(
              children: List.generate(
                controller.listOfForfeitValidity.length,
                ((index) {
                  final validity =
                      controller.listOfForfeitValidity.toList()[index];

                  if (validity.validity == Validity.unknown) {
                    return SizedBox();
                  }

                  return GestureDetector(
                    onTap: () => controller.changeValidityState(
                      !validity.isSelected,
                      validity,
                    ),
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: validity.isSelected
                            ? AppColors.darkGray
                            : AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                        border: Border.all(
                          color: AppColors.lightGray,
                        ),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          forfeitValidityTranslate(validity.validity.key),
                          maxLines: 1,
                          style: TextStyle(
                            color: validity.isSelected
                                ? AppColors.white
                                : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
  }
}

class _ForfeitFilterView extends StatelessWidget {
  const _ForfeitFilterView();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ForfeitController>(context);
    final localization = Get.find<AppInternationalization>();
    final transferController = Get.find<TransfersController>();

    return StreamBuilder(
      stream: controller.filterListOfForfeit.stream,
      builder: (context, snapshot) {
        final listOfForfeit = snapshot.data;

        if (listOfForfeit == null) {
          return Center(
            child: Lottie.asset(
              AnimationAsset.loading,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          );
        }

        if (listOfForfeit.isEmpty) {
          return Center(
            child: Column(
              children: [
                Lottie.asset(
                  AnimationAsset.noItem,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                Text(
                  localization.noForfeitFound,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: listOfForfeit.length,
          itemBuilder: (context, index) {
            final forfeit = listOfForfeit[index];

            return GestureDetector(
              onTap: (() {
                transferController.setActiveForfeit(forfeit);
                transferController.setActivePage(0);
              }),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OperatorIcon(
                      operatorType: forfeit.operatorName.key,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            forfeit.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            localization.locale.languageCode == 'en'
                                ? forfeit.description.en
                                : forfeit.description.fr,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      Currency.formatWithCurrency(
                        price: num.parse(forfeit.amountInXAF.toString()),
                        locale: localization.locale,
                        currencyCodeAlpha3: DefaultCurrency.xaf,
                      ),
                      style: TextStyle(color: AppColors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
