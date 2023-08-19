/// The base model declaration.
abstract class BaseModel {
  /// Constructs a new [Model] from [Map] object.
  const BaseModel.fromJson();

  /// Converts the current object to json object.
  Map<String, dynamic> toJson();

  @override
  String toString() => toJson().toString();
}
