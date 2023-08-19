import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

/// The adapter of contact model to json data model.
class DefaultBuyerContactAdapter extends TypeAdapter<Contact> {
  @override
  int get typeId => 4;

  @override
  Contact read(BinaryReader reader) {
    final Map<String, dynamic> data = Map.from(reader.readMap());

    return Contact.fromJson(data);
  }

  @override
  void write(BinaryWriter writer, Contact obj) {
    final data = obj.toJson();
    writer.writeMap(data);
  }
}
