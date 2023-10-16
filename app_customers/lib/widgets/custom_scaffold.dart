import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:trans_all_common_config/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../routes/app_router.dart';
import '../themes/app_colors.dart';
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
    final canPop = AppRouter.canPop(context);
    final theme = Theme.of(context);

    return Scaffold(
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
                        color:
                            theme.textTheme.titleSmall?.color ?? AppColors.gray,
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
      drawer: const NavigationDrawer(),
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
                            color: theme.appBarTheme.titleTextStyle?.color,
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

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) {
    final localization = Get.find<AppInternationalization>();

    return Container(
      padding: const EdgeInsets.only(
        top: 60,
        bottom: 40,
      ),
      child: Column(children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 70,
          child: Image.asset(
            'assets/icons/logo.png',
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            localization.transAll.toUpperCase(),
            style: TextStyle(
              fontSize: 34,
              color: Colors.black,
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final String facebookLink = RemoteConfig().getString(
      RemoteConfigKeys.launchFacebookLink,
    );
    final String instagramLink = RemoteConfig().getString(
      RemoteConfigKeys.launchInstagramLink,
    );
    final String twitterLink = RemoteConfig().getString(
      RemoteConfigKeys.launchTwitterLink,
    );
    final enableLaunchUrl = RemoteConfig().getBool(
          RemoteConfigKeys.launchUrl,
        );

    return Wrap(
      runSpacing: 20,
      children: [
        const Divider(
          color: Colors.grey,
          height: 110,
        ),
        ListTile(
          title: Text(
            localization.followUs,
            style: TextStyle(fontSize: 25),
          ),
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.facebook),
          title: Text(localization.facebook),
          onTap: () {
            if(enableLaunchUrl){
              launchUrl(
              Uri.parse(facebookLink),
              mode: LaunchMode.externalApplication,
            );
            }
            launchUrl(
              Uri.parse(facebookLink),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.instagram),
          title: Text(localization.instagram),
          onTap: () {
            launchUrl(
              Uri.parse(instagramLink),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.twitter),
          title: Text(localization.twitter),
          onTap: () {
            launchUrl(
              Uri.parse(twitterLink),
              mode: LaunchMode.externalApplication,
            );
          },
        )
      ],
    );
  }
}
