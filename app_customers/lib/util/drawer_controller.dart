import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Drawer menu controller.
class CustomDrawerController extends GetxController {
  Rx<double> value = Rx<double>(0);
  Rx<double> raduis = Rx<double>(0.0);
  int clickCount = 0;

  /// Determines activation.
  void updateValue(double delta) {
    value.value = (delta > 0 ? 1 : 0);
    raduis.value = (delta > 0 ? 20.0 : 0.0);
  }

  /// Loads links.
  void UrlLaunch(String Url) {
    launchUrl(Uri.parse(Url));
  }

  // Callback to display or close the drawer menu.
  void showDrawer() {
    if (clickCount == 0) {
      value.value = 1;
      raduis.value = 20.0;
      clickCount = 1;
    } else if (clickCount == 1) {
      value.value = 0;
      raduis.value = 0.0;
      clickCount = 0;
    }
  }
}
