import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/welcome/welcome_view.dart';
import '../util/preferences_keys.dart';
import 'app_page.dart';
import 'app_router.dart';
import 'pages_routes.dart';

/// Beamer's routes provider.
class BeamerRoutesProvider {
  /// True if the app is opened for the first time.
  static bool _isFirstOpen = false;

  /// The random number generator to circumvent specific cases where we
  /// want Beamer to rebuild the page.
  static final _rand = Random();

  /// The routes provider.
  static final routerDelegate = BeamerDelegate(
    initialPath: firstRouteToOpen(_isFirstOpen),
    locationBuilder: RoutesLocationBuilder(
      routes: {
        PagesRoutes.welcome.pattern: (context, state, data) {
          return BeamPage(
            key: ValueKey('welcome'),
            type: BeamPageType.slideRightTransition,
            child: AppPage(
              child: WelcomeView(),
            ),
          );
        },
        PagesRoutes.creditTransaction.pattern: (context, state, data) {
          // Deletes the transfer controller instance if it exist.

          final paymentNumber = state.queryParameters[
              CreditTransactionParams.keyParamBuyerPhoneNumber];
          final receiverNumber = state.queryParameters[
              CreditTransactionParams.keyParamReceiverPhoneNumber];
          final amount = state
              .queryParameters[CreditTransactionParams.keyParamAmountInXaf];
          final buyerGatewayId = state
              .queryParameters[CreditTransactionParams.keyParamBuyerGatewayId];
          final featureReference = state.queryParameters[
              CreditTransactionParams.keyParamFeatureReference];

          if (paymentNumber == null ||
              receiverNumber == null ||
              amount == null ||
              buyerGatewayId == null ||
              featureReference == null) {
            return BeamPage(
              key:
                  ValueKey('dashboard-transaction-${_rand.nextInt(100000000)}'),
              type: BeamPageType.slideRightTransition,
              child: SizedBox(),
            );
          }

          return BeamPage(
            key: ValueKey('dashboard-transaction-${_rand.nextInt(100000000)}'),
            type: BeamPageType.slideRightTransition,
            child: AppPage(
              child: SizedBox(),
            ),
          );
        },
        PagesRoutes.moneyTransaction.pattern: (context, state, data) {
          return BeamPage(
            key: ValueKey('dashboard-money-${_rand.nextInt(100000000)}'),
            type: BeamPageType.slideRightTransition,
            child: AppPage(
              child: SizedBox(),
            ),
          );
        },
        PagesRoutes.initTransaction.pattern: (context, state, data) {
          final paymentNumber = state.queryParameters[
              CreditTransactionParams.keyParamBuyerPhoneNumber];
          final receiverNumber = state.queryParameters[
              CreditTransactionParams.keyParamReceiverPhoneNumber];
          final amount = state
              .queryParameters[CreditTransactionParams.keyParamAmountInXaf];
          final buyerGatewayId = state
              .queryParameters[CreditTransactionParams.keyParamBuyerGatewayId];
          final featureReference = state.queryParameters[
              CreditTransactionParams.keyParamFeatureReference];

          if (paymentNumber == null ||
              receiverNumber == null ||
              amount == null ||
              buyerGatewayId == null ||
              featureReference == null) {
            return BeamPage(child: AppPageNotFound());
          }

          return BeamPage(
            key: ValueKey('initTransaction'),
            type: BeamPageType.slideTransition,
            child: AppPage(child: SizedBox.shrink()),
          );
        },
        PagesRoutes.historic.pattern: (context, state, data) {
          return BeamPage(
            key: ValueKey('dashboard-transaction-${_rand.nextInt(100000000)}'),
            type: BeamPageType.slideRightTransition,
            child: AppPage(
              child: SizedBox(),
            ),
          );
        },
      },
    ),
    setBrowserTabTitle: false,
  );

  ///
  static Future<void> init() async {
    Beamer.setPathUrlStrategy();

    _isFirstOpen = (await SharedPreferences.getInstance())
            .getBool(PreferencesKeys.isFirstOpenWelcomeScreen) ??
        true;
  }
}

/// Returns the initial pages route.
String firstRouteToOpen(
  bool isFirstOpen,
) {
  if (isFirstOpen) {
    return PagesRoutes.welcome.pattern;
  }

  return PagesRoutes.creditTransaction.pattern;
}

/// AppRouter implementation using Beamer.
class AppRouterBeamer extends AppRouterSubsystem {
  @override
  Future<void> init() {
    return BeamerRoutesProvider.init();
  }

  @override
  void push(BuildContext context, String uri, {Object? extra}) {
    context.beamToNamed(uri, data: extra);
  }

  @override
  void go(BuildContext context, String uri, {Object? extra}) {
    context.beamToNamed(uri, data: extra);
  }

  @override
  void pushReplacementNamed(
    BuildContext context,
    String uri, {
    Object? extra,
  }) {
    context.beamToReplacementNamed(uri, data: extra);
  }

  @override
  String getCurrentLocation(BuildContext context) {
    return Beamer.of(context).configuration.location ?? '';
  }

  @override
  void updateRouteInformation(BuildContext context, String uri) {
    Beamer.of(context).update(
      configuration: RouteInformation(
        location: uri,
      ),
      rebuild: false,
    );
  }

  @override
  bool canPop(BuildContext context) {
    return Beamer.of(context).canBeamBack;
  }

  @override
  void onPop(BuildContext context) {
    Beamer.of(context).beamBack();
  }

  @override
  RouterConfig<Object>? get routerConfig => null;

  @override
  BackButtonDispatcher? get backButtonDispatcher => null;

  @override
  RouteInformationParser<Object>? get routeInformationParser => BeamerParser();

  @override
  RouterDelegate<Object>? get routerDelegate =>
      BeamerRoutesProvider.routerDelegate;

  @override
  RouteInformationProvider? get routeInformationProvider =>
      throw UnimplementedError();
}
