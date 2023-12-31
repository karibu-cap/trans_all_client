import 'base_model.dart';

/// Model of forfeit.
class Forfeit extends BaseModel {
  /// The stored key ref for the [name] property.
  static const keyName = 'name';

  /// The stored key ref for the [validity] property.
  static const keyValidity = 'validity';

  /// The stored key ref for the [description] property.
  static const keyDescription = 'description';

  /// The stored key ref for the [category] property.
  static const keyCategory = 'category';

  /// The stored key ref for the [reference] property.
  static const keyReference = 'reference';

  /// The stored key ref for the [amountInXAF] property.
  static const keyAmountInXAF = 'amountInXAF';

  /// The stored key ref for the [currency] property.
  static const keyCurrency = 'currency';

  /// The stored key ref for the [operatorName] property.
  static const keyOperatorName = 'operatorName';

  /// The stored key ref for the [exactMatchRegex] property.
  static const keyExactMatchRegex = 'exactMatchRegex';

  /// The stored key ref for the [tolerantRegex] property.
  static const keyTolerantRegex = 'tolerantRegex';

  /// The name.
  final String name;

  /// The forfeit validity.
  final Validity validity;

  /// The description.
  final ForfeitDescription description;

  /// The category.
  final Category category;

  /// The currency.
  final String? currency;

  /// The amountInXAF of forfeit.
  final num amountInXAF;

  /// The forfeit operator.
  final Operator operatorName;

  /// The forfeit reference.
  final String reference;

  /// The exactMatchRegex.
  final String exactMatchRegex;

  /// The tolerantRegex.
  final String tolerantRegex;

  /// Constructs a new [Forfeit] from [Map] object.
  Forfeit.fromJson(
    Map<String, dynamic> json,
  )   : name = json[keyName],
        currency = json[keyCurrency] ?? 'XAF',
        amountInXAF = json[keyAmountInXAF],
        description = ForfeitDescription.fromJson(json[keyDescription]),
        validity = Validity.fromKey(json[keyValidity]),
        category = Category.fromKey(json[keyCategory]),
        reference = json[keyReference],
        operatorName = Operator.fromKey(json[keyOperatorName]),
        exactMatchRegex = json[keyExactMatchRegex],
        tolerantRegex = json[keyTolerantRegex],
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyName: name,
        keyDescription: description.toJson(),
        keyCategory: category.key,
        keyValidity: validity.key,
        keyCurrency: currency,
        keyAmountInXAF: amountInXAF,
        keyReference: reference,
        keyOperatorName: operatorName.key,
        keyExactMatchRegex: exactMatchRegex,
        keyTolerantRegex: tolerantRegex,
      };
}

/// The forfeit description.
class ForfeitDescription extends BaseModel {
  /// The stored key ref for the [fr] property.
  static const keyFr = 'fr';

  /// The stored key ref for the [en] property.
  static const keyEn = 'en';

  /// The description in english.
  final String en;

  /// The description in french.
  final String fr;

  /// Constructs a new [ForfeitDescription] from [Map] object.
  ForfeitDescription.fromJson(
    Map<String, dynamic> json,
  )   : en = json[keyEn],
        fr = json[keyFr],
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyEn: en,
        keyFr: fr,
      };
}

/// Represents the Operator.
class Operator {
  /// The operator.
  static final _data = <String, Operator>{
    camtel.key: camtel,
    orange.key: orange,
    mtn.key: mtn,
    unknown.key: unknown,
  };

  /// The camtel operator.
  static const camtel = Operator._('Camtel');

  /// The orange operator.
  static const orange = Operator._('Orange');

  /// The mtn operator.
  static const mtn = Operator._('Mtn');

  /// The unknown operator.
  static const unknown = Operator._('unknown');

  /// The operator key.
  final String key;

  const Operator._(this.key);

  /// Constructs a new [Operator] form [key].
  factory Operator.fromKey(String key) {
    return _data[key] ?? unknown;
  }
}

/// Represents the forfeit Validity.
class Validity {
  /// The forfeit Category.
  static final _data = <String, Validity>{
    month.key: month,
    week.key: week,
    day.key: day,
    unknown.key: unknown,
  };

  /// The month forfeit.
  static const month = Validity._('month');

  /// The week forfeit.
  static const week = Validity._('week');

  /// The day forfeit.
  static const day = Validity._('day');

  /// The unknown operator.
  static const unknown = Validity._('unknown');

  /// The operator key.
  final String key;

  const Validity._(this.key);

  /// Constructs a new [Validity] form [key].
  factory Validity.fromKey(String key) {
    return _data[key] ?? unknown;
  }
}

/// Represents the forfeit category.
class Category {
  /// The forfeit Category.
  static final _data = <String, Category>{
    sms.key: sms,
    data.key: data,
    call.key: call,
    unit.key: unit,
    unknown.key: unknown,
  };

  /// The sms forfeit.
  static const sms = Category._('sms');

  /// The data forfeit.
  static const data = Category._('data');

  /// The call forfeit.
  static const call = Category._('call');

  /// The call forfeit.
  static const unit = Category._('unit');

  /// The unknown operator.
  static const unknown = Category._('unknown');

  /// The operator key.
  final String key;

  const Category._(this.key);

  /// Constructs a new [OperationTransferType] form [key].
  factory Category.fromKey(String key) {
    return _data[key] ?? unknown;
  }
}
