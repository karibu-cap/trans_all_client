import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/dashboard/dashboard_view.dart';
import '../pages/init_tranction/init_transaction.dart';
import '../pages/init_tranction/init_transaction_controller.dart';
import '../pages/transfer/transfer_controller_view.dart';
import '../pages/welcome/welcome_view.dart';
import '../util/preferences_keys.dart';
import 'app_page.dart';
import 'app_router.dart';
import 'pages_routes.dart';

/// The route navigation.
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// The shell navigation.
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

/// The routes representation.
class _GoRouterRoutesProvider {
  /// True if the app is opened for the first time.
  static bool _isFirstOpen = false;

  /// The routes provider.
  static final routerProvider = GoRouter(
    initialLocation: firstRouteToOpen(_isFirstOpen),
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: PagesRoutes.welcome.pattern,
        builder: (context, state) => AppPage(
          child: WelcomeView(),
        ),
      ),
      GoRoute(
        path: PagesRoutes.historic.pattern,
        builder: (context, state) => AppPage(
          child: DashboardView(
            dashboardPageType: DashboardPageType.historical,
          ),
        ),
      ),
      GoRoute(
        path: PagesRoutes.creditTransaction.pattern,
        builder: (context, state) {
          if (Get.isRegistered<TransfersController>()) {
            Get.delete<TransfersController>();
          }
          final paymentNumber = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamBuyerPhoneNumber,
          );
          final receiverNumber = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamReceiverPhoneNumber,
          );
          final amount = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamAmountInXaf,
          );
          final buyerGatewayId = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamBuyerGatewayId,
          );
          final featureReference = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamFeatureReference,
          );
          final category = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamCategory,
          );
          final operatorName = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamOperatorName,
          );
          final transferId = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamTransactionId,
          );
          if (paymentNumber == null ||
              receiverNumber == null ||
              amount == null ||
              operatorName == null ||
              category == null ||
              buyerGatewayId == null ||
              featureReference == null) {
            return AppPage(
              requestContactPermission: true,
              child: DashboardView(
                additionalData: AdditionalData(displayInternetMessage: true),
                dashboardPageType: DashboardPageType.creditTransaction,
              ),
            );
          }

          return AppPage(
            requestContactPermission: true,
            child: DashboardView(
              additionalData: AdditionalData(
                displayInternetMessage: true,
                localCreditTransaction: CreditTransactionParams(
                  amountInXaf: amount,
                  buyerGatewayId: buyerGatewayId,
                  receiverPhoneNumber: receiverNumber,
                  buyerPhoneNumber: paymentNumber,
                  featureReference: featureReference,
                  category: category,
                  transactionId: transferId,
                  operatorName: operatorName,
                ),
              ),
              dashboardPageType: DashboardPageType.creditTransaction,
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: PagesRoutes.initTransaction.pattern,
        builder: (context, state) {
          if (Get.isRegistered<InitTransactionController>()) {
            Get.delete<InitTransactionController>();
          }
          final paymentNumber = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamBuyerPhoneNumber,
          );
          final receiverNumber = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamReceiverPhoneNumber,
          );
          final amount = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamAmountInXaf,
          );
          final buyerGatewayId = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamBuyerGatewayId,
          );
          final featureReference = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamFeatureReference,
          );
          final category = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamCategory,
          );
          final operatorName = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamOperatorName,
          );
          final transferId = getQueryParameter(
            state.queryParameters,
            CreditTransactionParams.keyParamTransactionId,
          );

          if (paymentNumber == null ||
              receiverNumber == null ||
              amount == null ||
              operatorName == null ||
              category == null ||
              buyerGatewayId == null ||
              featureReference == null) {
            return AppPage(
              child: AppPageNotFound(),
            );
          }

          return AppPage(
            child: InitTransaction(
              creditTransactionParams: CreditTransactionParams(
                amountInXaf: amount,
                buyerGatewayId: buyerGatewayId,
                receiverPhoneNumber: receiverNumber,
                buyerPhoneNumber: paymentNumber,
                featureReference: featureReference,
                transactionId: transferId,
                category: category,
                operatorName: operatorName,
              ),
            ),
          );
        },
      ),
    ],
  );

  /// Determines if the use opens the application for the first time.
  static Future<void> init() async {
    usePathUrlStrategy();

    _isFirstOpen = (await SharedPreferences.getInstance())
            .getBool(PreferencesKeys.isFirstOpenWelcomeScreen) ??
        true;
  }

  /// Retrieves the value of key.
  static String? getQueryParameter(
    Map<String, String> queryParameters,
    String key,
  ) {
    final value = queryParameters[key];
    if (value == 'null' || value == null || value.isEmpty) return null;

    return value;
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

/// AppROuter implementation using GoRouter.
class AppRouterGoRouter extends AppRouterSubsystem {
  @override
  Future<void> init() {
    return _GoRouterRoutesProvider.init();
  }

  @override
  void push(BuildContext context, String uri, {Object? extra}) {
    context.push(uri, extra: extra);
  }

  @override
  void go(BuildContext context, String uri, {Object? extra}) {
    context.go(uri, extra: extra);
  }

  @override
  void pushReplacementNamed(
    BuildContext context,
    String uri, {
    Object? extra,
  }) {
    context.go(uri, extra: extra);
  }

  @override
  String getCurrentLocation(BuildContext context) {
    return GoRouterState.of(context).location;
  }

  @override
  void updateRouteInformation(BuildContext context, String uri) => null;

  @override
  bool canPop(BuildContext context) {
    return GoRouter.of(context).canPop();
  }

  @override
  void replace(BuildContext context, String uri, {Object? extra}) {
    context.replace(uri, extra: extra);
  }

  @override
  void onPop(BuildContext context) {
    GoRouter.of(context).pop();
  }

  @override
  RouterConfig<Object>? get routerConfig =>
      _GoRouterRoutesProvider.routerProvider;

  @override
  BackButtonDispatcher? get backButtonDispatcher =>
      _GoRouterRoutesProvider.routerProvider.backButtonDispatcher;

  @override
  RouteInformationParser<Object>? get routeInformationParser =>
      _GoRouterRoutesProvider.routerProvider.routeInformationParser;

  @override
  RouterDelegate<Object>? get routerDelegate =>
      _GoRouterRoutesProvider.routerProvider.routerDelegate;

  @override
  RouteInformationProvider? get routeInformationProvider =>
      _GoRouterRoutesProvider.routerProvider.routeInformationProvider;
}
