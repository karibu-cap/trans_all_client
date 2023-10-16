import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

/// The adapter of transferInfo model to firebase data model.
class TransferInfoAdapter extends TypeAdapter<TransferInfo> {
  @override
  int get typeId => 0;

  @override
  TransferInfo read(BinaryReader reader) {
    final Map<String, dynamic> data = Map.from(reader.readMap());

    return TransferInfo.fromJson(json: {
      TransferInfo.keyAmountXAF: data[TransferInfo.keyAmountXAF],
      TransferInfo.keyBuyerPhoneNumber: data[TransferInfo.keyBuyerPhoneNumber],
      TransferInfo.keyId: data[TransferInfo.keyId],
      TransferInfo.keyCreatedAt: data[TransferInfo.keyCreatedAt].toString(),
      TransferInfo.keyUpdateAt: data[TransferInfo.keyUpdateAt].toString(),
      TransferInfo.keyFeature: data[TransferInfo.keyFeature],
      TransferInfo.keyForfeitReference: data[TransferInfo.keyForfeitReference],
      TransferInfo.keyReason: data[TransferInfo.keyReason],
      TransferInfo.keyReceiverPhoneNumber:
          data[TransferInfo.keyReceiverPhoneNumber],
      TransferInfo.keyStatus: data[TransferInfo.keyStatus],
      TransferInfo.keyPayments: data[TransferInfo.keyPayments]
          .map(
            (payment) => {
              TransTuPayment.keyGateway: payment[TransTuPayment.keyGateway],
              TransTuPayment.keyPhoneNumber:
                  payment[TransTuPayment.keyPhoneNumber],
              TransTuPayment.keyStatus: payment[TransTuPayment.keyStatus],
            },
          )
          .toList(),
    });
  }

  @override
  void write(BinaryWriter writer, TransferInfo obj) {
    final data = obj.toJson();
    writer.writeMap(data);
  }
}
