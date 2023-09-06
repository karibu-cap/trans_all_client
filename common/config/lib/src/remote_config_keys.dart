/// Keys used to fetch remote configuration data for the app.
///
/// Keys must be added to the database before they are added here.
/// Eventually, we will need a way to strictly tie the keys declared here,
/// to the ones created in the database.
class RemoteConfigKeys {
  /// Boolean to activate or deactivate the possibility for a user to
  /// make airtime transfer request by sms.
  static const userCanRequestAirtimeBySms = 'users_can_request_airtime_by_sms';

  /// The Orange sim number for that receives message in cas of sms transaction.
  static const orangeNumberForSmsTransaction =
      'orange_number_for_sms_transaction';

  /// The MTN sim number for that receives message in cas of sms transaction.
  static const mtnNumberForSmsTransaction = 'mtn_number_for_sms_transaction';

  /// Boolean to active or disable the forfeit feature.
  static const featureForfeitEnable = 'feature_forfeit_enable';

  /// Boolean to enabled or disable the customer service button.
  static const featureCustomerServiceEnabled =
      'feature_customer_service_enabled';

  /// The of customer service link.
  static const customerServiceLink = 'customer_service_link';
}
