import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:karibu_capital_core_internationalization/internationalization.dart';

void main() {
  group('LocalizedString', () {
    const englishText = 'text in english';
    const frenchText = 'texte en francais';
    final raw = {
      'en': englishText,
      'fr': frenchText,
    };
    final localizedString = LocalizedString(raw);

    test('returns the english text', () {
      expect(localizedString.get(Locale('en')), englishText);
    });

    test('returns the french text', () {
      expect(localizedString.get(Locale('fr')), frenchText);
    });

    test("returns the english text when the language doesn't exist", () {
      // The localized string doesn't include a spanish translation.
      // So the defualt ('en') should be returned.
      expect(localizedString.get(Locale('es')), englishText);
    });
  });
}
