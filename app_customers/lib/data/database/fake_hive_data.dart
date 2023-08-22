import 'package:trans_all_common_models/models.dart';

/// Fake forfeit.
final fakeForfeits = [
  Forfeit.fromJson({
    Forfeit.keyId: 'f3f7c1b6-7c1e-484d-9f2c-2e3d7d5c0441',
    Forfeit.keyAmountInXAF: 500,
    Forfeit.keyCurrency: 'XAF',
    Forfeit.keyCategory: Category.data,
    Forfeit.keyDescription: {
      ForfeitDescription.keyEn: '1.5 Go valid for 24h',
      ForfeitDescription.keyFr: '1.5 Go valide 24h',
    },
    Forfeit.keyName: 'Blue Night',
    Forfeit.keyReference: OperationTransferType.camtelUnitTransfer,
    Forfeit.keyValidity: Validity.day,
  }),
  Forfeit.fromJson({
    Forfeit.keyId: 'f3f7c1b6-7c1e-484d-9f2c-2e3d7d5c0423',
    Forfeit.keyAmountInXAF: 5000,
    Forfeit.keyCurrency: 'XAF',
    Forfeit.keyCategory: Category.data,
    Forfeit.keyDescription: {
      ForfeitDescription.keyEn: '1.5 Go valid for 24h',
      ForfeitDescription.keyFr: '1.5 Go valide 24h',
    },
    Forfeit.keyName: 'Blue Mo M(Cool)',
    Forfeit.keyReference: OperationTransferType.camtelUnitTransfer,
    Forfeit.keyValidity: Validity.day,
  }),
  Forfeit.fromJson({
    Forfeit.keyId: 'f3f7c1b6-7c1e-484d-9f2c-2e3d7d5c23',
    Forfeit.keyAmountInXAF: 5000,
    Forfeit.keyCurrency: 'XAF',
    Forfeit.keyCategory: Category.data,
    Forfeit.keyDescription: {
      ForfeitDescription.keyEn: '250 Mo for 1 jour',
      ForfeitDescription.keyFr: '250 Mo pour 1 jour',
    },
    Forfeit.keyName: 'Surf Day 250',
    Forfeit.keyReference: OperationTransferType.mtnUnitTransfer,
    Forfeit.keyValidity: Validity.day,
  }),
  Forfeit.fromJson({
    Forfeit.keyId: 'f3f7c1b6-7c1e-484d-9f2c-2e3d7d5c011',
    Forfeit.keyAmountInXAF: 20000,
    Forfeit.keyCategory: Category.data,
    Forfeit.keyCurrency: 'XAF',
    Forfeit.keyDescription: {
      ForfeitDescription.keyEn: '2 Go by day for 30 days',
      ForfeitDescription.keyFr: '2 Go par jour pendant 30 jours',
    },
    Forfeit.keyName: 'Blue One L',
    Forfeit.keyReference: OperationTransferType.camtelUnitTransfer,
    Forfeit.keyValidity: Validity.month,
  }),
  Forfeit.fromJson({
    Forfeit.keyId: 'f3f7c1b6-7c1e-484d-9f2c-2e3d7d5c000',
    Forfeit.keyAmountInXAF: 2040,
    Forfeit.keyCurrency: 'XAF',
    Forfeit.keyCategory: Category.data,
    Forfeit.keyDescription: {
      ForfeitDescription.keyEn: '3 Go/days for 30 days',
      ForfeitDescription.keyFr: '3 Go par jour pendant 30 jours',
    },
    Forfeit.keyName: '30 Jours Nuit',
    Forfeit.keyReference: OperationTransferType.camtelUnitTransfer,
    Forfeit.keyValidity: Validity.month,
  }),
];

/// Fake transaction.
final fakeTransactions = {
  'f3f7c1b6-7c1e-484d-9f2c-2e3d7d5c0441': TransferInfo.fromJson(json: {
    TransferInfo.keyId: 'f3f7c1b6-7c1e-484d-9f2c-2e3d7d5c0441',
    TransferInfo.keyAmountXAF: 5000,
    TransferInfo.keyBuyerGateway: PaymentId.mtnPaymentId.key,
    TransferInfo.keyBuyerPhoneNumber: '697783748',
    TransferInfo.keyCreatedAt: DateTime.now().toString(),
    TransferInfo.keyFeature: OperationTransferType.camtelUnitTransfer.key,
    TransferInfo.keyReason: null,
    TransferInfo.keyReceiverOperator: 'mtn',
    TransferInfo.keyReceiverPhoneNumber: '673729217',
    TransferInfo.keyStatus: TransferStatus.waitingRequest.key,
    TransferInfo.keyPayments: [
      {
        TransTuPayment.keyGateway: PaymentId.mtnPaymentId.key,
        TransTuPayment.keyPhoneNumber: '697783748',
        TransTuPayment.keyStatus: PaymentStatus.pending.key,
      },
    ],
  }),
  'cc7c33c5-ec6d-4b1f-9f10-8c8c1c7c0afb': TransferInfo.fromJson(json: {
    TransferInfo.keyAmountXAF: 500,
    TransferInfo.keyBuyerGateway: PaymentId.mtnPaymentId.key,
    TransferInfo.keyBuyerPhoneNumber: '62783748',
    TransferInfo.keyCreatedAt: DateTime.now().toString(),
    TransferInfo.keyFeature: OperationTransferType.camtelUnitTransfer.key,
    TransferInfo.keyReason: null,
    TransferInfo.keyReceiverOperator: 'mtn',
    TransferInfo.keyReceiverPhoneNumber: '673729217',
    TransferInfo.keyStatus: TransferStatus.completed.key,
    TransferInfo.keyId: 'cc7c33c5-ec6d-4b1f-9f10-8c8c1c7c0afb',
    TransferInfo.keyPayments: [
      {
        TransTuPayment.keyGateway: PaymentId.mtnPaymentId.key,
        TransTuPayment.keyPhoneNumber: '697783748',
        TransTuPayment.keyStatus: PaymentStatus.succeeded.key,
      },
    ],
  }),
  '5f3c9b61-e7f3-4c0e-9f3f-9f5f8d4c4b4c': TransferInfo.fromJson(json: {
    TransferInfo.keyAmountXAF: 9000,
    TransferInfo.keyBuyerGateway: PaymentId.mtnPaymentId.key,
    TransferInfo.keyBuyerPhoneNumber: '697783748',
    TransferInfo.keyCreatedAt: DateTime.now().toString(),
    TransferInfo.keyFeature: OperationTransferType.camtelUnitTransfer.key,
    TransferInfo.keyReason: null,
    TransferInfo.keyReceiverOperator: 'mtn',
    TransferInfo.keyReceiverPhoneNumber: '673729217',
    TransferInfo.keyStatus: TransferStatus.requestSend.key,
    TransferInfo.keyId: '5f3c9b61-e7f3-4c0e-9f3f-9f5f8d4c4b4c',
    TransferInfo.keyPayments: [
      {
        TransTuPayment.keyGateway: PaymentId.mtnPaymentId.key,
        TransTuPayment.keyPhoneNumber: '697783748',
        TransTuPayment.keyStatus: PaymentStatus.succeeded.key,
      },
    ],
  }),
  '4b3f3f02-0e6b-4c3c-8c4e-3b5e5cdec50b': TransferInfo.fromJson(json: {
    TransferInfo.keyAmountXAF: 59000,
    TransferInfo.keyBuyerGateway: PaymentId.mtnPaymentId.key,
    TransferInfo.keyBuyerPhoneNumber: '697783748',
    TransferInfo.keyCreatedAt: DateTime.now().toString(),
    TransferInfo.keyFeature: OperationTransferType.camtelUnitTransfer.key,
    TransferInfo.keyReason: null,
    TransferInfo.keyReceiverOperator: 'mtn',
    TransferInfo.keyReceiverPhoneNumber: '673729217',
    TransferInfo.keyStatus: TransferStatus.waitingRequest.key,
    TransferInfo.keyId: '4b3f3f02-0e6b-4c3c-8c4e-3b5e5cdec50b',
    TransferInfo.keyPayments: [
      {
        TransTuPayment.keyGateway: PaymentId.mtnPaymentId.key,
        TransTuPayment.keyPhoneNumber: '697783748',
        TransTuPayment.keyStatus: PaymentStatus.failed.key,
      },
    ],
  }),
};

final List<PaymentGateways> fakeSupportedPayment = [
  PaymentGateways.fromJson(
    {
      PaymentGateways.keyId: PaymentId.orangePaymentId.key,
      PaymentGateways.keyDisplayName: 'ORANGE MONEY',
      PaymentGateways.keyExactMatchRegex:
          '^((\\+)?237)?(69\\d{7}\$|65[5-9]\\d{6}\$)',
      PaymentGateways.keyTolerantRegex:
          '^((\\+)?237)?(69\\d{0,7}\$|65[5-9]\\d{0,6}\$)',
    },
  ),
  PaymentGateways.fromJson(
    {
      PaymentGateways.keyId: PaymentId.mtnPaymentId.key,
      PaymentGateways.keyDisplayName: 'MTN MOMO',
      PaymentGateways.keyExactMatchRegex:
          '^((\\+)?237)?(67\\d{7}\$|68\\d{7}\$|65[0-4]\\d{6}\$)',
      PaymentGateways.keyTolerantRegex:
          '^((\\+)?237)?(67\\d{0,7}\$|68\\d{0,7}\$|65[0-4]\\d{0,6}\$)',
    },
  ),
];
final List<OperationGateways> fakeOperatorGateWays = [
  OperationGateways.fromJson(
    {
      OperationGateways.keyOperatorName: 'Orange',
      OperationGateways.keyReference:
          OperationTransferType.orangeUnitTransfer.key,
      OperationGateways.keyExactMatchRegex:
          '^((\\+)?237)?(69\\d{7}\$|65[5-9]\\d{6}\$)',
      OperationGateways.keyTolerantRegex:
          '^((\\+)?237)?(69\\d{0,7}\$|65[5-9]\\d{0,6}\$)',
    },
  ),
  OperationGateways.fromJson(
    {
      OperationGateways.keyOperatorName: 'Mtn',
      OperationGateways.keyReference: OperationTransferType.mtnUnitTransfer.key,
      OperationGateways.keyExactMatchRegex:
          '^((\\+)?237)?(67\\d{7}\$|68\\d{7}\$|65[0-4]\\d{6}\$)',
      OperationGateways.keyTolerantRegex:
          '^((\\+)?237)?(67\\d{0,7}\$|68\\d{0,7}\$|65[0-4]\\d{0,6}\$)',
    },
  ),
  OperationGateways.fromJson(
    {
      OperationGateways.keyOperatorName: 'Camtel',
      OperationGateways.keyReference:
          OperationTransferType.camtelUnitTransfer.key,
      OperationGateways.keyExactMatchRegex:
          '^((\\+)?237)?(67\\d{7}\$|68\\d{7}\$|65[0-4]\\d{6}\$)',
      OperationGateways.keyTolerantRegex:
          '^((\\+)?237)?(67\\d{0,7}\$|68\\d{0,7}\$|65[0-4]\\d{0,6}\$)',
    },
  ),
  OperationGateways.fromJson(
    {
      OperationGateways.keyOperatorName: 'Camtel',
      OperationGateways.keyReference:
          OperationTransferType.camtelUnitTransfer.key,
      OperationGateways.keyExactMatchRegex:
          '^((\\+)?237)?(67\\d{7}\$|68\\d{7}\$|65[0-4]\\d{6}\$)',
      OperationGateways.keyTolerantRegex:
          '^((\\+)?237)?(67\\d{0,7}\$|68\\d{0,7}\$|65[0-4]\\d{0,6}\$)',
    },
  ),
];

final fakeUserContacts = {
  '4b3f3f02': Contact.fromJson(
    {
      Contact.keyId: '4b3f3f02',
      Contact.keyIsBuyerContact: false,
      Contact.keyName: 'jhon',
      Contact.keyPhoneNumber: '687768765',
    },
  ),
  '4b3f3f00000': Contact.fromJson(
    {
      Contact.keyId: '4b3f3f02',
      Contact.keyIsBuyerContact: false,
      Contact.keyName: 'steve',
      Contact.keyPhoneNumber: '687768765',
    },
  ),
  '4b3f3f088888': Contact.fromJson(
    {
      Contact.keyId: '4b3f3f02',
      Contact.keyIsBuyerContact: false,
      Contact.keyName: 'warren',
      Contact.keyPhoneNumber: '687768765',
    },
  ),
};
