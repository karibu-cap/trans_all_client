import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Drawer menu controller.
class CustomDrawerController extends GetxController {
  Rx<int> value = Rx<int>(0);
  Rx<double> raduis = Rx<double>(0.0);

  /// Function that determines activation.
  void updateValue(double delta) {
    value.value = (delta > 0 ? 1 : 0);
    raduis.value = (delta > 0 ? 20.0 : 0.0);
  }

  /// Function for load links.
  void UrlLaunch(String Url) {
    launchUrl(Uri.parse(Url));
  }
}