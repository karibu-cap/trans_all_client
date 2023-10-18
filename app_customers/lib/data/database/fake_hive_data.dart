import 'package:trans_all_common_models/models.dart';

/// Fake forfeit.
final fakeForfeits = {
  'data': [
    Forfeit.fromJson({
      Forfeit.keyAmountInXAF: 500,
      Forfeit.keyCurrency: 'XAF',
      Forfeit.keyCategory: Category.sms.key,
      Forfeit.keyDescription: {
        ForfeitDescription.keyEn: 'infinite sms for 30 day',
        ForfeitDescription.keyFr: 'sms illimite pendant 30 jour',
      },
      Forfeit.keyName: 'Blue Night',
      Forfeit.keyValidity: Validity.month.key,
      Forfeit.keyOperatorName: 'Orange',
      Forfeit.keyReference: 'Blue-Mo-M',
      Forfeit.keyExactMatchRegex: '^((\\+)?237)?(69\\d{7}\$|65[5-9]\\d{6}\$)',
      Forfeit.keyTolerantRegex: '^((\\+)?237)?(69\\d{0,7}\$|65[5-9]\\d{0,6}\$)',
    }),
    Forfeit.fromJson({
      Forfeit.keyAmountInXAF: 500,
      Forfeit.keyCurrency: 'XAF',
      Forfeit.keyCategory: Category.data.key,
      Forfeit.keyDescription: {
        ForfeitDescription.keyEn: '1.5 Go valid for 24h',
        ForfeitDescription.keyFr: '1.5 Go valide 24h',
      },
      Forfeit.keyName: 'Blue Night',
      Forfeit.keyValidity: Validity.day.key,
      Forfeit.keyOperatorName: 'Camtel',
      Forfeit.keyReference: 'Blue-Mo-L',
      Forfeit.keyExactMatchRegex: '^((\\+)?237)?(69\\d{7}\$|65[5-9]\\d{6}\$)',
      Forfeit.keyTolerantRegex: '^((\\+)?237)?(69\\d{0,7}\$|65[5-9]\\d{0,6}\$)',
    }),
    Forfeit.fromJson({
      Forfeit.keyAmountInXAF: 5000,
      Forfeit.keyCurrency: 'XAF',
      Forfeit.keyCategory: Category.data.key,
      Forfeit.keyDescription: {
        ForfeitDescription.keyEn: '1.5 Go valid for 24h',
        ForfeitDescription.keyFr: '1.5 Go valide 24h',
      },
      Forfeit.keyName: 'Blue Mo M(Cool)',
      Forfeit.keyValidity: Validity.day.key,
      Forfeit.keyOperatorName: 'Mtn',
      Forfeit.keyReference: 'Blue-Mo-LL',
      Forfeit.keyExactMatchRegex: '^((\\+)?237)?(69\\d{7}\$|65[5-9]\\d{6}\$)',
      Forfeit.keyTolerantRegex: '^((\\+)?237)?(69\\d{0,7}\$|65[5-9]\\d{0,6}\$)',
    }),
    Forfeit.fromJson({
      Forfeit.keyAmountInXAF: 5000,
      Forfeit.keyCurrency: 'XAF',
      Forfeit.keyCategory: Category.data.key,
      Forfeit.keyDescription: {
        ForfeitDescription.keyEn: '250 Mo for 1 jour',
        ForfeitDescription.keyFr: '250 Mo pour 1 jour',
      },
      Forfeit.keyName: 'Surf Day 250',
      Forfeit.keyValidity: Validity.day.key,
      Forfeit.keyOperatorName: 'Camtel',
      Forfeit.keyReference: 'Blue-Mo-LA',
      Forfeit.keyExactMatchRegex: '^((\\+)?237)?(69\\d{7}\$|65[5-9]\\d{6}\$)',
      Forfeit.keyTolerantRegex: '^((\\+)?237)?(69\\d{0,7}\$|65[5-9]\\d{0,6}\$)',
    }),
    Forfeit.fromJson({
      Forfeit.keyAmountInXAF: 20000,
      Forfeit.keyCategory: Category.data.key,
      Forfeit.keyCurrency: 'XAF',
      Forfeit.keyDescription: {
        ForfeitDescription.keyEn: '2 Go by day for 30 days',
        ForfeitDescription.keyFr: '2 Go par jour pendant 30 jours',
      },
      Forfeit.keyName: 'Blue One L',
      Forfeit.keyValidity: Validity.month.key,
      Forfeit.keyOperatorName: 'Camtel',
      Forfeit.keyReference: 'Blue-Mo',
      Forfeit.keyExactMatchRegex: '^((\\+)?237)?(69\\d{7}\$|65[5-9]\\d{6}\$)',
      Forfeit.keyTolerantRegex: '^((\\+)?237)?(69\\d{0,7}\$|65[5-9]\\d{0,6}\$)',
    }),
    Forfeit.fromJson({
      Forfeit.keyAmountInXAF: 2040,
      Forfeit.keyCurrency: 'XAF',
      Forfeit.keyCategory: Category.data.key,
      Forfeit.keyDescription: {
        ForfeitDescription.keyEn: '3 Go/days for 30 days',
        ForfeitDescription.keyFr: '3 Go par jour pendant 30 jours',
      },
      Forfeit.keyName: '30 Jours Nuit',
      Forfeit.keyValidity: Validity.month.key,
      Forfeit.keyOperatorName: 'Camtel',
      Forfeit.keyReference: 'Blue-Mo-L1',
      Forfeit.keyExactMatchRegex: '^((\\+)?237)?(69\\d{7}\$|65[5-9]\\d{6}\$)',
      Forfeit.keyTolerantRegex: '^((\\+)?237)?(69\\d{0,7}\$|65[5-9]\\d{0,6}\$)',
    }),
  ],
};

/// Fake transaction.
final fakeTransactions = {
  'f3f7c1b6-7c1e-484d-9f2c-2e3d7d5c0441': TransferInfo.fromJson(json: {
    TransferInfo.keyId: 'f3f7c1b6-7c1e-484d-9f2c-2e3d7d5c0441',
    TransferInfo.keyAmountXAF: 5000,
    TransferInfo.keyBuyerPhoneNumber: '697783748',
    TransferInfo.keyCreatedAt: '2022-10-12 15:30:00Z',
    TransferInfo.keyFeature: 'camtelUnitTransfer',
    TransferInfo.keyReason: null,
    TransferInfo.keyReceiverPhoneNumber: '673729299',
    TransferInfo.keyStatus: TransferStatus.waitingRequest.key,
    TransferInfo.keyCategory: 'unit',
    TransferInfo.keyOperatorName: 'Camtel',
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
    TransferInfo.keyBuyerPhoneNumber: '696689073',
    TransferInfo.keyCreatedAt: '2022-10-12 15:30:00Z',
    TransferInfo.keyFeature: 'mtnUnitTransfer',
    TransferInfo.keyReason: null,
    TransferInfo.keyReceiverPhoneNumber: '673729217',
    TransferInfo.keyStatus: TransferStatus.completed.key,
    TransferInfo.keyId: 'cc7c33c5-ec6d-4b1f-9f10-8c8c1c7c0afb',
    TransferInfo.keyCategory: 'unit',
    TransferInfo.keyOperatorName: 'Mtn',
    TransferInfo.keyPayments: [
      {
        TransTuPayment.keyGateway: PaymentId.mtnPaymentId.key,
        TransTuPayment.keyPhoneNumber: '687768765',
        TransTuPayment.keyStatus: PaymentStatus.succeeded.key,
      },
    ],
  }),
  'cc7c33c5-ec6d-4b1f-9f10-8c8c1c7c0af1': TransferInfo.fromJson(json: {
    TransferInfo.keyAmountXAF: 500,
    TransferInfo.keyBuyerPhoneNumber: '696689073',
    TransferInfo.keyCreatedAt: '2022-10-12 15:30:00Z',
    TransferInfo.keyFeature: 'Blue-Mo-M',
    TransferInfo.keyReason: null,
    TransferInfo.keyReceiverPhoneNumber: '620209501',
    TransferInfo.keyStatus: TransferStatus.paymentFailed.key,
    TransferInfo.keyId: 'cc7c33c5-ec6d-4b1f-9f10-8c8c1c7c0af1',
    TransferInfo.keyCategory: 'data',
    TransferInfo.keyOperatorName: 'Camtel',
    TransferInfo.keyPayments: [
      {
        TransTuPayment.keyGateway: PaymentId.mtnPaymentId.key,
        TransTuPayment.keyPhoneNumber: '687768765',
        TransTuPayment.keyStatus: PaymentStatus.failed.key,
      },
    ],
  }),
  '5f3c9b61-e7f3-4c0e-9f3f-9f5f8d4c4b4c': TransferInfo.fromJson(json: {
    TransferInfo.keyAmountXAF: 9000,
    TransferInfo.keyBuyerPhoneNumber: '697783748',
    TransferInfo.keyCreatedAt: '2022-10-18 15:30:00Z',
    TransferInfo.keyFeature: 'mtnUnitTransfer',
    TransferInfo.keyReason: null,
    TransferInfo.keyReceiverPhoneNumber: '67372922',
    TransferInfo.keyStatus: TransferStatus.requestSend.key,
    TransferInfo.keyId: '5f3c9b61-e7f3-4c0e-9f3f-9f5f8d4c4b4c',
    TransferInfo.keyCategory: 'unit',
    TransferInfo.keyOperatorName: 'Mtn',
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
    TransferInfo.keyBuyerPhoneNumber: '697783748',
    TransferInfo.keyCreatedAt: '2022-10-13 15:30:00Z',
    TransferInfo.keyFeature: 'mtnUnitTransfer',
    TransferInfo.keyReason: null,
    TransferInfo.keyReceiverPhoneNumber: '673729217',
    TransferInfo.keyStatus: TransferStatus.waitingRequest.key,
    TransferInfo.keyId: '4b3f3f02-0e6b-4c3c-8c4e-3b5e5cdec50b',
    TransferInfo.keyCategory: 'unit',
    TransferInfo.keyOperatorName: 'Mtn',
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
      OperationGateways.keyCategory: Category.unit.key,
      OperationGateways.keyReference: 'orangeUnitTransfer',
      OperationGateways.keyExactMatchRegex:
          '^((\\+)?237)?(69\\d{7}\$|65[5-9]\\d{6}\$)',
      OperationGateways.keyTolerantRegex:
          '^((\\+)?237)?(69\\d{0,7}\$|65[5-9]\\d{0,6}\$)',
    },
  ),
  OperationGateways.fromJson(
    {
      OperationGateways.keyOperatorName: 'Mtn',
      OperationGateways.keyCategory: Category.unit.key,
      OperationGateways.keyReference: 'mtnUnitTransfer',
      OperationGateways.keyExactMatchRegex:
          '^((\\+)?237)?(67\\d{7}\$|68\\d{7}\$|65[0-4]\\d{6}\$)',
      OperationGateways.keyTolerantRegex:
          '^((\\+)?237)?(67\\d{0,7}\$|68\\d{0,7}\$|65[0-4]\\d{0,6}\$)',
    },
  ),
  OperationGateways.fromJson(
    {
      OperationGateways.keyOperatorName: 'Camtel',
      OperationGateways.keyCategory: Category.unit.key,
      OperationGateways.keyReference: 'camtelUnitTransfer',
      OperationGateways.keyExactMatchRegex:
          '^((\\+)?237)?(67\\d{7}\$|68\\d{7}\$|65[0-4]\\d{6}\$)',
      OperationGateways.keyTolerantRegex:
          '^((\\+)?237)?(67\\d{0,7}\$|68\\d{0,7}\$|65[0-4]\\d{0,6}\$)',
    },
  ),
  OperationGateways.fromJson(
    {
      OperationGateways.keyOperatorName: 'Camtel',
      OperationGateways.keyCategory: Category.unit.key,
      OperationGateways.keyReference: 'camtelUnitTransfer',
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
      Contact.keyPhoneNumber: '696689073',
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
