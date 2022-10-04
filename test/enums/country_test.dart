import 'package:geos/src/enums/country.dart';
import 'package:test/test.dart';

void main() {
  group('The transitive and the symmetric property:', () {
    test(
      'The transitive property: if [b] = [a] and [c] = [b], then [c] = [a].',
      () {
        for (final Country country in Country.values) {
          final Country a = country;
          final Country b = a;
          final Country c = b;
          expect(c, equals(a));
        }
      },
    );
    test(
      'The symmetric property: if [a] = [b], then [b] = [a].',
      () {
        for (final Country country in Country.values) {
          final Country a = country;
          final Country b = country;
          expect(a, equals(b));
          expect(b, equals(a));
        }
      },
    );
  });

  group('factory Country.parse:', () {
    test('Uniqueness of properties.', () {
      for (final Country country in Country.values) {
        expect(
          Country.values
              .where((final c) => c.alpha2Code == country.alpha2Code)
              .length,
          1,
          reason: '$country [alpha2Code] must be unique.',
        );
        expect(
          Country.values
              .where((final c) => c.alpha3Code == country.alpha3Code)
              .length,
          1,
          reason: '$country [alpha3Code] must be unique.',
        );
        expect(
          Country.values
              .where((final c) => c.englishName == country.englishName)
              .length,
          1,
          reason: '$country [englishName] must be unique.',
        );
        expect(
          Country.values
              .where((final c) => c.flagEmoji == country.flagEmoji)
              .length,
          1,
          reason: '$country [flagEmoji] must be unique.',
        );
        expect(
          Country.values
              .where((final c) => c.numericCode == country.numericCode)
              .length,
          1,
          reason: '$country [numericCode] must be unique.',
        );
      }
    });
    test(
        'From any string that is a valid representation of one of a [Country]’s'
        ' properties, this constructor must construct a new [Country]'
        ' instance.', () {
      // [alpha2Code] property
      expect(
        Country.parse('SC'),
        Country.seychelles,
        reason: 'SC is the [alpha2Code] code for the country of Seychelles.',
      );
      expect(
        Country.parse('sc'),
        Country.seychelles,
        reason: 'SC is the [alpha2Code] code for the country of Seychelles, and'
            ' this constructor is not case sensitive.',
      );
      expect(
        Country.parse(' sc '),
        Country.seychelles,
        reason:
            'SC is the [alpha2Code] code for the country of Seychelles, this'
            ' constructor is not case sensitive and does not take into account'
            ' leading and trailing white spaces.',
      );
      // [alpha3Code] property
      expect(
        Country.parse('PRY'),
        Country.paraguay,
        reason: 'PRY is the [alpha3Code] code for the country of Paraguay.',
      );
      expect(
        Country.parse('pry'),
        Country.paraguay,
        reason: 'PRY is the [alpha3Code] code for the country of Paraguay, and'
            ' this constructor is not case sensitive.',
      );
      expect(
        Country.parse(' pry '),
        Country.paraguay,
        reason: 'PRY is the [alpha3Code] code for the country of Paraguay, this'
            ' constructor is not case sensitive and does not take into account'
            ' leading and trailing white spaces.',
      );
      // [englishName] property
      expect(
        Country.parse('Åland Islands'),
        Country.alandIslands,
        reason: 'Åland Islands is the [englishName] for the country of Åland'
            ' Islands.',
      );
      expect(
        Country.parse('åland islands'),
        Country.alandIslands,
        reason: 'Åland Islands is the [englishName] for the country of Åland'
            ' Islands, and this constructor is not case sensitive.',
      );
      expect(
        Country.parse(' åland islands '),
        Country.alandIslands,
        reason: 'Åland Islands is the [englishName] for the country of Åland'
            ' Islands, this constructor is not case sensitive and does not take'
            ' into account leading and trailing white spaces.',
      );
      // [flagEmoji] property
      expect(
        Country.parse('🇦🇶'),
        Country.antarctica,
        reason: '🇦🇶 is the [flagEmoji] for the country of Antarctica.',
      );
      expect(
        Country.parse(' 🇦🇶 '),
        Country.antarctica,
        reason: '🇦🇶 is the [flagEmoji] for the country of Antarctica, this'
            ' constructor does not take into account leading and trailing white'
            ' spaces.',
      );
      // [numericCode] property
      expect(
        Country.parse('184'),
        Country.cookIslands,
        reason:
            '184 is the [numericCode] code for the country of Cook Islands.',
      );
      expect(
        Country.parse(' 184 '),
        Country.cookIslands,
        reason: '184 is the [numericCode] code for the country of Cook Islands,'
            ' this constructor does not take into account leading and trailing'
            ' white spaces.',
      );
    });
    test(
        'Throws a [FormatException] if the [formattedString] does not contain a'
        ' valid representation of a [Country].', () {
      expect(
        () => Country.parse(''),
        throwsFormatException,
        reason: 'There is no instance of [Country] that has a property'
            ' uniquely represented by an empty string.',
      );
      expect(
        () => Country.parse('1234'),
        throwsFormatException,
        reason: 'There is no instance of [Country] that has a property that'
            ' is uniquely represented by a 4-digit string.',
      );
      expect(
        () => Country.parse('.'),
        throwsFormatException,
        reason: 'There is no instance of [Country] that has a property that'
            ' is uniquely represented by a string that contains a period.',
      );
    });
  });

  group('compareTo:', () {
    test('Must compare a Country value to another one.', () {
      expect(
        Country.antarctica.compareTo(Country.unitedStatesOfAmerica),
        isNegative,
      );
      expect(Country.italy.compareTo(Country.italy), isZero);
      expect(Country.costaRica.compareTo(Country.alandIslands), isPositive);
    });
  });

  group('toString:', () {
    test(
        'This string must match [englishName] property of this [Country]'
        ' instance.', () {
      expect(
        Country.cocosKeelingIslands.toString(),
        Country.cocosKeelingIslands.englishName,
        reason: 'The string representation of [Country.cocosKeelingIslands]'
            ' must match the English name string of the country itself.',
      );
      expect(
        Country.haiti.toString(),
        Country.haiti.englishName,
        reason: 'The string representation of [Country.haiti] must match the'
            ' English name string of the country itself.',
      );
      expect(
        Country.portugal.toString(),
        Country.portugal.englishName,
        reason: 'The string representation of [Country.portugal] must match the'
            ' English name string of the country itself.',
      );
    });
    test('This string must be able to be parsed back using [Country.parse].',
        () {
      expect(
        Country.parse(Country.andorra.toString()),
        Country.andorra,
        reason: 'The result of [toString] method applied to [Country.andorra]'
            ' must be able to be parsed back using [Country.parse] to construct'
            ' the corresponding instance: [Country.andorra] itself.',
      );
      expect(
        Country.parse(Country.gambia.toString()),
        Country.gambia,
        reason: 'The result of [toString] method applied to [Country.gambia]'
            ' must be able to be parsed back using [Country.parse] to construct'
            ' the corresponding instance: [Country.gambia] itself.',
      );
      expect(
        Country.parse(Country.vanuatu.toString()),
        Country.vanuatu,
        reason: 'The result of [toString] method applied to [Country.vanuatu]'
            ' must be able to be parsed back using [Country.parse] to construct'
            ' the corresponding instance: [Country.vanuatu] itself.',
      );
    });
  });
}
