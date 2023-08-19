/// The initialization response.
class InitializationResponse {
  /// Message on error occurred.
  final String? message;

  /// Transaction id.
  final String? transactionId;

  /// Constructor of [InitializationResponse].
  InitializationResponse({this.message, this.transactionId});
}
