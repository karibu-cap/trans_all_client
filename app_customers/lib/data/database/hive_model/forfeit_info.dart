import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

/// The adapter of ForfeitAdapter.
class ForfeitAdapter extends TypeAdapter<Forfeit> {
  @override
  int get typeId => 5;

  @override
  Forfeit read(BinaryReader reader) {
    final Map<String, dynamic> json = Map.from(reader.readMap());

    return Forfeit.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, Forfeit obj) {
    final json = obj.toJson();
    writer.writeMap(json);
  }
}
