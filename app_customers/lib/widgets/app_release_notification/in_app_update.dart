import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:logging/logging.dart';

/// An implementation of the native android in app update plugin api.
class InAppUpdateCheck extends StatelessWidget {
  final _logger = Logger('InAppUpdateCheck');

  /// A method called when we found a new update. If provided, the method should
  /// resolve to true to automatically start the update.
  final Future<bool> Function()? onUpdateAvailable;

  /// The child widget to show.
  final Widget? child;

  /// Creates a new [InAppUpdateCheck].
  InAppUpdateCheck({
    this.child,
    this.onUpdateAvailable,
    bool? preferBackgroundUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkForUpdate(),
      builder: (_, __) => child ?? SizedBox.shrink(),
    );
  }

  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<bool> checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability != UpdateAvailability.updateAvailable) {
        return false;
      }
      if (onUpdateAvailable == null) {
        return _autoUpdate(updateInfo);
      }
      final canUpdate = await onUpdateAvailable?.call();
      if (canUpdate == true) {
        return _autoUpdate(updateInfo);
      }
    } on PlatformException catch (e) {
      _logger.severe(e.toString(), e, StackTrace.current);
    }

    return false;
  }

  Future<bool> _autoUpdate(AppUpdateInfo updateInfo) async {
    try {
      if (updateInfo.flexibleUpdateAllowed) {
        final response = await InAppUpdate.startFlexibleUpdate();
        if (response == AppUpdateResult.success) {
          unawaited(InAppUpdate.completeFlexibleUpdate());
        }

        return response == AppUpdateResult.success;
      }
      if (updateInfo.immediateUpdateAllowed) {
        final response = await InAppUpdate.performImmediateUpdate();

        return response == AppUpdateResult.success;
      }
    } on PlatformException catch (e) {
      _logger.severe(e.toString(), e, StackTrace.current);
    }

    return false;
  }
}
