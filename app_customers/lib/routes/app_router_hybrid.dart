import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'app_router.dart';
import 'app_router_beamer.dart';
import 'app_router_single_stack.dart';

/// AppRouter implementation using Beamer and SingleStack navigator.
class AppRouterHybrid extends AppRouterSubsystem {
  @override
  Future<void> init() {
    return BeamerRoutesProvider.init();
  }

  @override
  void push(BuildContext context, String uri, {Object? extra}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SingleStackNavigator(
          uri,
          extraArguments: extra,
        ),
      ),
    );
    Beamer.of(context).updateRouteInformation(RouteInformation(location: uri));
  }

  @override
  void go(BuildContext context, String uri, {Object? extra}) {
    context.beamToNamed(
      uri,
      data: extra,
    );
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
    Beamer.of(context).updateRouteInformation(RouteInformation(location: uri));
  }

  @override
  bool canPop(BuildContext context) {
    return Beamer.of(context).canBeamBack;
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
