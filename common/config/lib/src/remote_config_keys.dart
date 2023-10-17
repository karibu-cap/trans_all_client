/// Keys used to fetch remote configuration data for the app.
///
/// Keys must be added to the database before they are added here.
/// Eventually, we will need a way to strictly tie the keys declared here,
/// to the ones created in the database.
class RemoteConfigKeys {
  /// Boolean to activate or deactivate the possibility for a user to
  /// make airtime transfer request by sms.
  static const userCanRequestAirtimeBySms = 'users_can_request_airtime_by_sms';

  /// Feature follow us enabled.
  static const followUsEnabled = 'follow_us_enabled';

  /// Enable drawer menu.
  static const displayDrawerMenuEnabled = 'display_drawer_menu_enabled';

  /// Link for facebook page.
  static const linkFacebookPage = 'link_facebook_page';

  /// Link for instagram page.
  static const linkInstagramPage = 'link_instagram_page';

  /// Link for twitter page.
  static const linkTwitterPage = 'link_twitter_page';

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
