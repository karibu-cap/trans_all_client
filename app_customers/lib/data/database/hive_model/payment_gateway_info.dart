import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

/// The adapter of PaymentGateways.
class PaymentGatewaysAdapter extends TypeAdapter<PaymentGateways> {
  @override
  int get typeId => 2;

  @override
  PaymentGateways read(BinaryReader reader) {
    final Map<String, dynamic> json = Map.from(reader.readMap());

    return PaymentGateways.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, PaymentGateways obj) {
    final json = obj.toJson();
    writer.writeMap(json);
  }
}
