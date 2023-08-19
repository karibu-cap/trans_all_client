import 'base_model.dart';

/// Abstract class that represent any document.
abstract class BaseDocument extends BaseModel {
  /// The path to the document.
  final String path;

  /// The id of the document.
  final String id;

  /// Constructs a new [BaseDocument].
  BaseDocument.fromJson(this.path)
      : id = path.split('/').last,
        super.fromJson();

  @override
  String toString() {
    return 'Document::$path => ${toJson()}';
  }
}
