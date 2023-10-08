import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../pages/init_tranction/init_transaction.dart';
import '../pages/transfer/transfer_view.dart';
import '../pages/welcome/welcome_view.dart';
import 'app_page.dart';
import 'app_router.dart';
import 'app_router_beamer.dart';
import 'pages_routes.dart';

/// Navigator that keeps a single stack of page (Navigator 1.0).
/// TODO: find a library that can do URL matching for us.
class SingleStackNavigator extends StatelessWidget {
  /// The url path.
  final String url;

  /// The extra argument passed to url.
  final Object? extraArguments;

  /// Constructs a new [SingleStackNavigator].
  SingleStackNavigator(this.url, {this.extraArguments});

  @override
  Widget build(BuildContext context) {
    final parsedUri = Uri.parse(url);
    final segments = parsedUri.pathSegments;
    final queryParameters = parsedUri.queryParameters;

    if (segments.isEmpty) {
      return AppPage(
        child: SizedBox(),
      );
    }

    if (segments.first == 'credit-transaction') {
      if (segments.length == 1) {
        return AppPage(
          child: TransfersView(),
        );
      }

      if (segments.length == 2 && segments[1] == 'init') {
        final paymentNumber =
            queryParameters[CreditTransactionParams.keyParamBuyerPhoneNumber];
        final receiverNumber = queryParameters[
            CreditTransactionParams.keyParamReceiverPhoneNumber];
        final amount =
            queryParameters[CreditTransactionParams.keyParamAmountInXaf];
        final buyerGatewayId =
            queryParameters[CreditTransactionParams.keyParamBuyerGatewayId];
        final featureReference =
            queryParameters[CreditTransactionParams.keyParamFeatureReference];

        if (paymentNumber == null ||
            receiverNumber == null ||
            amount == null ||
            buyerGatewayId == null ||
            featureReference == null) {
          return AppPageNotFound();
        }

        return AppPage(
          child: InitTransaction(
            creditTransactionParams: CreditTransactionParams(
              amountInXaf: amount,
              buyerGatewayId: buyerGatewayId,
              receiverPhoneNumber: receiverNumber,
              buyerPhoneNumber: paymentNumber,
              featureReference: featureReference,
            ),
          ),
        );
      }

      return AppPageNotFound();
    }
    if (segments.first == 'historic') {
      if (segments.length == 1) {
        return AppPage(
          child: TransfersView(),
        );
      }

      return AppPageNotFound();
    }
    if (segments.first == 'welcome') {
      if (segments.length == 1) {
        return AppPage(
          child: WelcomeView(),
        );
      }

      return AppPageNotFound();
    }

    return AppPageNotFound();
  }
}

/// AppRouter implementation using a SingleStackNavigator.
class AppRouterSingleStack extends AppRouterSubsystem {
  @override
  Future<void> init() async => null;

  @override
  void push(BuildContext context, String uri, {Object? extra}) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SingleStackNavigator(
            uri,
            extraArguments: extra,
          ),
        ),
      );

  @override
  void go(BuildContext context, String uri, {Object? extra}) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => SingleStackNavigator(
            uri,
            extraArguments: extra,
          ),
        ),
        (_) => false,
      );

  @override
  void pushReplacementNamed(
    BuildContext context,
    String uri, {
    Object? extra,
  }) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SingleStackNavigator(
            uri,
            extraArguments: extra,
          ),
        ),
      );

  @override
  String getCurrentLocation(BuildContext context) {
    return '';
  }

  @override
  void updateRouteInformation(BuildContext context, String uri) => null;

  @override
  bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  @override
  void onPop(BuildContext context) {
    Navigator.pop(context);
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
