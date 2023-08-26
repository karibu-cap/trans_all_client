import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karibu_capital_core_utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/forfeitRepository.dart';
import '../../routes/app_router.dart';
import '../../routes/pages_routes.dart';
import '../../themes/app_colors.dart';
import '../../util/constant.dart';
import '../../util/key_internationalization.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/oparator_icon.dart';
import 'forfeit_controller.dart';
import 'forfeit_view_model.dart';

/// The forfeit view.
class ForfeitView extends StatelessWidget {
  /// Constructs a new [ForfeitView].
  const ForfeitView({super.key});

  @override
  Widget build(BuildContext context) {
    final forfeitRepository = Get.find<ForfeitRepository>();

    final model = ForfeitViewModel(forfeitRepository);

    return ChangeNotifierProvider(
      create: (_) => ForfeitController(model: model),
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            displayInternetMessage: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _ForfeitBody(),
            ),
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
        _ForfeitCategoryView(),
        SizedBox(
          height: 10,
        ),
        _ValidityView(),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
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
                    if (snapshot.data == null ||
                        snapshot.data == 'All' ||
                        snapshot.data == 'Tout') {
                      controller.selectedOperator.add(localization.all);
                    }
                    final isSelected = snapshot.data == operator;

                    return GestureDetector(
                      onTap: () {
                        controller.selectedOperator.add(operator);
                        controller.updateFilterListOfForfeit();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.listOfForfeitCategory.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
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
                        forfeitCategoryTranslate(forfeitCategory.category.key),
                        style: TextStyle(
                          color: forfeitCategory.isSelected
                              ? AppColors.white
                              : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.listOfForfeitValidity.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
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
                      child: Text(
                        forfeitValidityTranslate(validity.validity.key),
                        style: TextStyle(
                          color: validity.isSelected
                              ? AppColors.white
                              : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
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
              onTap: () => AppRouter.go(
                context,
                PagesRoutes.creditTransaction.create(CreditTransactionParams(
                  forfeitId: forfeit.id,
                )),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OperatorIcon(
                        operatorType: forfeit.reference.key,
                      ),
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
                    Expanded(
                      child: Text(
                        Currency.formatWithCurrency(
                          price: num.parse(forfeit.amountInXAF.toString()),
                          locale: localization.locale,
                          currencyCodeAlpha3: DefaultCurrency.xaf,
                        ),
                        style: TextStyle(color: AppColors.black),
                      ),
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
