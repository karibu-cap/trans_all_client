import 'package:trans_all_common_utils/utils.dart';

import 'remote_config_keys.dart';

Map<String, dynamic> _remoteConfigDefaultsDev = {
  RemoteConfigKeys.userCanRequestAirtimeBySms: true,
  RemoteConfigKeys.orangeNumberForSmsTransaction: '657569424',
  RemoteConfigKeys.mtnNumberForSmsTransaction: '676714797',
  RemoteConfigKeys.featureForfeitEnable: true,
  RemoteConfigKeys.featureCustomerServiceEnabled: true,
  RemoteConfigKeys.launchUrl: true,
  RemoteConfigKeys.customerServiceLink: 'https://wa.me/237696404016',
  RemoteConfigKeys.launchFacebookLink: 'https://www.facebook.com',
  RemoteConfigKeys.launchInstagramLink: 'https://www.intagram.com',
  RemoteConfigKeys.launchTwitterLink: 'https://www.twitter.com',
};

Map<String, dynamic> _remoteConfigDefaultsStaging = {
  RemoteConfigKeys.userCanRequestAirtimeBySms: true,
  RemoteConfigKeys.orangeNumberForSmsTransaction: '657569424',
  RemoteConfigKeys.mtnNumberForSmsTransaction: '676714797',
  RemoteConfigKeys.featureForfeitEnable: true,
  RemoteConfigKeys.featureCustomerServiceEnabled: true,
  RemoteConfigKeys.launchUrl: true,
  RemoteConfigKeys.customerServiceLink: 'https://wa.me/237696404016',
  RemoteConfigKeys.launchFacebookLink: 'https://www.facebook.com',
  RemoteConfigKeys.launchInstagramLink: 'https://www.intagram.com',
  RemoteConfigKeys.launchTwitterLink: 'https://www.twitter.com',
};

Map<String, dynamic> _remoteConfigDefaultsProd = {
  RemoteConfigKeys.userCanRequestAirtimeBySms: false,
  RemoteConfigKeys.orangeNumberForSmsTransaction: '657569424',
  RemoteConfigKeys.mtnNumberForSmsTransaction: '676714797',
  RemoteConfigKeys.featureForfeitEnable: false,
  RemoteConfigKeys.featureCustomerServiceEnabled: false,
  RemoteConfigKeys.launchUrl: true,
  RemoteConfigKeys.customerServiceLink: 'https://wa.me/237696404016',
  RemoteConfigKeys.launchFacebookLink: 'https://www.facebook.com',
  RemoteConfigKeys.launchInstagramLink: 'https://www.intagram.com',
  RemoteConfigKeys.launchTwitterLink: 'https://www.twitter.com',
};

/// Returns the default remote config for each environment.
Map<String, dynamic> getRemoteConfigDefaults() {
  switch (EnvironmentConfig.environmentType) {
    case EnvironmentType.prod:
      return _remoteConfigDefaultsProd;
    case EnvironmentType.staging:
      return _remoteConfigDefaultsStaging;
    case EnvironmentType.dev:
      return _remoteConfigDefaultsDev;
    default:
      return _remoteConfigDefaultsDev;
  }
}
