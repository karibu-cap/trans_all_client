import 'package:trans_all_common_utils/utils.dart';

import 'remote_config_keys.dart';

Map<String, dynamic> _remoteConfigDefaultsDev = {
  RemoteConfigKeys.userCanRequestAirtimeBySms: true,
  RemoteConfigKeys.orangeNumberForSmsTransaction: '657569424',
  RemoteConfigKeys.mtnNumberForSmsTransaction: '676714797',
  RemoteConfigKeys.featureForfeitEnable: true,
  RemoteConfigKeys.featureCustomerServiceEnabled: true,
  RemoteConfigKeys.customerServiceLink: 'https://wa.me/237696404016',
  RemoteConfigKeys.orangeMoneyGatewayEnabled: true,
  RemoteConfigKeys.orangeOperatorEnabled: true,
  RemoteConfigKeys.mtnMomoGatewayEnabled: true,
  RemoteConfigKeys.mtnOperatorEnabled: true,
  RemoteConfigKeys.camtelOperatorEnabled: true,
};

Map<String, dynamic> _remoteConfigDefaultsStaging = {
  RemoteConfigKeys.userCanRequestAirtimeBySms: true,
  RemoteConfigKeys.orangeNumberForSmsTransaction: '657569424',
  RemoteConfigKeys.mtnNumberForSmsTransaction: '676714797',
  RemoteConfigKeys.featureForfeitEnable: true,
  RemoteConfigKeys.featureCustomerServiceEnabled: true,
  RemoteConfigKeys.customerServiceLink: 'https://wa.me/237696404016',
  RemoteConfigKeys.orangeMoneyGatewayEnabled: true,
  RemoteConfigKeys.orangeOperatorEnabled: true,
  RemoteConfigKeys.mtnMomoGatewayEnabled: true,
  RemoteConfigKeys.mtnOperatorEnabled: true,
  RemoteConfigKeys.camtelOperatorEnabled: true,
};

Map<String, dynamic> _remoteConfigDefaultsProd = {
  RemoteConfigKeys.userCanRequestAirtimeBySms: false,
  RemoteConfigKeys.orangeNumberForSmsTransaction: '657569424',
  RemoteConfigKeys.mtnNumberForSmsTransaction: '676714797',
  RemoteConfigKeys.featureForfeitEnable: false,
  RemoteConfigKeys.featureCustomerServiceEnabled: false,
  RemoteConfigKeys.customerServiceLink: 'https://wa.me/237696404016',
  RemoteConfigKeys.orangeMoneyGatewayEnabled: true,
  RemoteConfigKeys.orangeOperatorEnabled: true,
  RemoteConfigKeys.mtnMomoGatewayEnabled: true,
  RemoteConfigKeys.mtnOperatorEnabled: true,
  RemoteConfigKeys.camtelOperatorEnabled: true,
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
