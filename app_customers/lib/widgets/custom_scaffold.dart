import 'dart:math';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:trans_all_common_config/config.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routes/app_router.dart';
import '../themes/app_colors.dart';
import '../util/drawer_controller.dart';
import '../util/themes.dart';
import 'internet_connection.dart';

/// The custom scaffold widget.
class CustomScaffold extends StatelessWidget {
  /// The first child of the silver list view.
  final Widget child;

  /// The leading widget of app bar.
  final Widget? leadingAppBar;

  /// The title of the app bar.
  final String? title;

  /// Check if we can display internet message of the app bar.
  final bool displayInternetMessage;

  /// Construct new custom scaffold.
  const CustomScaffold({
    Key? key,
    this.leadingAppBar,
    this.displayInternetMessage = true,
    this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Links remote config
    final String facebookLink = RemoteConfig().getString(
      RemoteConfigKeys.linkFacebookPage,
    );
    final String instagramLink = RemoteConfig().getString(
      RemoteConfigKeys.linkInstagramPage,
    );
    final String twitterLink = RemoteConfig().getString(
      RemoteConfigKeys.linkTwitterPage,
    );

    /// activation drawer remote config
    final displayDrawerMenuEnabled = RemoteConfig().getBool(
      RemoteConfigKeys.displayDrawerMenuEnabled,
    );

    /// show links remote config
    final followUsEnabled = RemoteConfig().getBool(
      RemoteConfigKeys.followUsEnabled,
    );

    final localization = Get.find<AppInternationalization>();
    final addThemeData = Get.find<ThemeManager>();
    final canPop = AppRouter.canPop(context);
    final theme = Theme.of(context);
    final customDrawerController = Get.find<CustomDrawerController>();

    return displayDrawerMenuEnabled
        ? Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: addThemeData.themeMode == ThemeMode.dark
                          ? [Colors.transparent, Colors.transparent]
                          : [Colors.white, Colors.white],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      color: theme.appBarTheme.backgroundColor,
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      width: 200.0,
                      child: Column(
                        children: [
                          DrawerHeader(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 45,
                                  child: Image.asset(
                                    addThemeData.themeMode != ThemeMode.dark
                                        ? 'assets/icons/logo.png'
                                        : 'assets/icons/transTu_white_icon.png',
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  localization.transAll.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color:
                                        addThemeData.themeMode == ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: followUsEnabled,
                            child: Expanded(
                              child: ListView(
                                padding: const EdgeInsets.only(
                                  top: 290,
                                ),
                                children: [
                                  ListTile(
                                    title: Text(
                                      localization.followUs,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      FontAwesomeIcons.facebook,
                                      color: Colors.blueAccent,
                                    ),
                                    title: Text(localization.facebook),
                                    onTap: () {
                                      if (facebookLink != '') {
                                        launchUrl(
                                          Uri.parse(facebookLink),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      FontAwesomeIcons.instagram,
                                      color: Color.fromARGB(255, 170, 96, 197),
                                    ),
                                    title: Text(localization.instagram),
                                    onTap: () {
                                      if (instagramLink != '') {
                                        launchUrl(
                                          Uri.parse(instagramLink),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      FontAwesomeIcons.twitter,
                                      color: Color.fromARGB(255, 101, 186, 255),
                                    ),
                                    title: Text(localization.twitter),
                                    onTap: () {
                                      if (twitterLink != '') {
                                        launchUrl(
                                          Uri.parse(twitterLink),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => TweenAnimationBuilder(
                      tween: Tween<double>(
                          begin: 0,
                          end: customDrawerController.value.toDouble()),
                      duration: const Duration(milliseconds: 500),
                      builder: (_, val, __) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..setEntry(0, 3, val * 200)
                            ..rotateY((pi / 12) * val),
                          child: Material(
                            elevation: val > 0 ? 20.0 : 0.0,
                            shadowColor: AppColors.black,
                            child: Scaffold(
                              backgroundColor: theme.scaffoldBackgroundColor,
                              appBar: canPop
                                  ? AppBar(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              customDrawerController.raduis
                                                  .toDouble()),
                                        ),
                                      ),
                                      backgroundColor:
                                          theme.appBarTheme.backgroundColor,
                                      elevation: 0.0,
                                      leading: InkWell(
                                        child: Container(
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: theme
                                                .appBarTheme.backgroundColor,
                                            border: Border.fromBorderSide(
                                              BorderSide(
                                                color: theme.textTheme
                                                        .titleSmall?.color ??
                                                    AppColors.gray,
                                              ),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(9)),
                                          ),
                                          child: Icon(
                                            size: 15,
                                            Icons.arrow_back_ios,
                                          ),
                                        ),
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    )
                                  : null,
                              body: SafeArea(
                                bottom: false,
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 750),
                                    child: Column(
                                      children: [
                                        if (displayInternetMessage)
                                          FadedSlideAnimation(
                                            beginOffset: Offset(0, -0.3),
                                            endOffset: Offset(0, 0),
                                            slideCurve: Curves.linearToEaseOut,
                                            child: displayInternetMessage
                                                ? InternetConnectivityView()
                                                : SizedBox.shrink(),
                                          ),
                                        title != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  title ?? '',
                                                  style: TextStyle(
                                                    color: theme.appBarTheme
                                                        .titleTextStyle?.color,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        Expanded(
                                          child: child,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragUpdate: (e) {
                      customDrawerController.updateValue(e.delta.dx);
                    },
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: canPop
                ? AppBar(
                    backgroundColor: theme.appBarTheme.backgroundColor,
                    elevation: 0.0,
                    leading: InkWell(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.appBarTheme.backgroundColor,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: theme.textTheme.titleSmall?.color ??
                                  AppColors.gray,
                            ),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                        ),
                        child: Icon(
                          size: 15,
                          Icons.arrow_back_ios,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  )
                : null,
            body: SafeArea(
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 750),
                  child: Column(
                    children: [
                      if (displayInternetMessage)
                        FadedSlideAnimation(
                          beginOffset: Offset(0, -0.3),
                          endOffset: Offset(0, 0),
                          slideCurve: Curves.linearToEaseOut,
                          child: displayInternetMessage
                              ? InternetConnectivityView()
                              : SizedBox.shrink(),
                        ),
                      title != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                title ?? '',
                                style: TextStyle(
                                  color:
                                      theme.appBarTheme.titleTextStyle?.color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      Expanded(
                        child: child,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
