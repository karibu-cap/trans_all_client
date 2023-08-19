import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

/// The adapter of OperationGateways.
class OperationGatewaysAdapter extends TypeAdapter<OperationGateways> {
  @override
  int get typeId => 1;

  @override
  OperationGateways read(BinaryReader reader) {
    final Map<String, dynamic> json = Map.from(reader.readMap());

    return OperationGateways.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, OperationGateways obj) {
    final json = obj.toJson();
    writer.writeMap(json);
  }
}
