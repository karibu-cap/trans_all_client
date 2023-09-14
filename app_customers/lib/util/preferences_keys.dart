/// A class that contains all preference keys used inside the application.
class PreferencesKeys {
  /// The variable that determines if the user
  /// has already opened the Welcome screen.
  static const String isFirstOpenWelcomeScreen = 'AlphaWelcomeScreenOpened';

  /// The variable that determines if the user dismiss the customer service.
  static const String isCustomerServiceFloatingButtonCollapsed =
      'isCustomerServiceFloatingButtonCollapsed';

  /// The content type key.
  static const String contentType = 'Content-Type';

  /// Checks when user is connected.
  static const String isConnected = 'isConnected';

  /// Can request to contact permission.
  static const String requestContactPermission = 'requestContactPermission';

  /// The content type of client version.
  static const String clientVersion = 'X-Client-Version';

  /// The content type of Accept-Language.
  static const String acceptLanguage = 'Accept-Language';
}
