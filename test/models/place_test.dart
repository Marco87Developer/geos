import 'dart:collection';
import 'dart:io';

import 'package:geos/src/models/place.dart';
import 'package:test/test.dart';

void main() {
  group('The transitive and the symmetric property:', () {
    test(
      'The transitive property: if [b] = [a] and [c] = [b], then [c] = [a].',
      () {
        final Place a = Place(
          address: 'Address',
          latitude: 0,
          longitude: 0,
          name: 'Name',
          tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
        );
        final Place b = a;
        final Place c = b;
        expect(c, equals(a));
      },
    );
    test(
      'The symmetric property: if [a] = [b], then [b] = [a].',
      () {
        final Place a = Place(
          address: 'Address',
          latitude: 0,
          longitude: 0,
          name: 'Name',
          tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
        );
        final Place b = Place(
          address: 'Address',
          latitude: 0,
          longitude: 0,
          name: 'Name',
          tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
        );
        expect(a, equals(b));
        expect(b, equals(a));
      },
    );
  });

  group('factory Place.fromJson:', () {
    test(
        'If the JSON string is a valid representation of a [Place], must'
        ' construct a [Place] instance.', () async {
      final File file = File('test/models/place_test.json');
      final String json = await file.readAsString();
      expect(
        Place.fromJson(json),
        Place(
          address: 'This is the address',
          isFavorite: true,
          latitude: 0,
          longitude: 0,
          name: 'This is the name',
          tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
        ),
        reason: 'The JSON string is a valid representation of a [Place]'
            ' instance.',
      );
    });
    test(
        'If the JSON string is not a valid representation of a [Place], this'
        ' constructor must throw a [FormatException] or an [Error].', () async {
      final File file1 = File('test/models/place_not_valid_1_test.json');
      final String json1 = await file1.readAsString();
      expect(
        () => Place.fromJson(json1),
        throwsFormatException,
        reason: 'Parameter "latitude" is a string instead of a number.',
      );
      final File file2 = File('test/models/place_not_valid_2_test.json');
      final String json2 = await file2.readAsString();
      // ignore: prefer_typing_uninitialized_variables
      var error;
      try {
        Place.fromJson(json2);
        // ignore: avoid_catching_errors
      } on Error catch (e) {
        error = e;
      }
      expect(
        error is Error,
        true,
        reason: 'The JSON file contains only an empty object.',
      );
    });
  });

  group('Place.fromMap:', () {
    test(
        'If the map is a valid representation of a [Place] instance, this'
        ' constructor must create that instance.', () {
      final Map<String, dynamic> map = {
        'address': 'address',
        'name': 'name',
        'isfavorite': false,
        'latitude': 0,
        'longitude': 0,
        'tags': <dynamic>['tag1', 'tag2', 'tag3'],
      };
      expect(
        Place.fromMap(map),
        Place(
          address: 'address',
          latitude: 0,
          longitude: 0,
          name: 'name',
          tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
        ),
        reason: '[map] is a valid representation of a [Place] instance',
      );
    });
    test(
        'If the map is not a valid representation of a [Place] instance, this'
        ' constructor must throw an [Error].', () {
      final Map<String, dynamic> invalidMap = {
        'latitude': 0,
        'longitude': 0,
        'tags': <dynamic>['tag1', 'tag2', 'tag3'],
      };
      // ignore: prefer_typing_uninitialized_variables
      var error;
      try {
        Place.fromMap(invalidMap);
        // ignore: avoid_catching_errors
      } on Error catch (e) {
        error = e;
      }
      expect(
        error is Error,
        true,
        reason: 'The [invalidMap] is not valid because it does not contain some'
            ' necessary parameters ([address], [name] and [isfavorite]).',
      );
    });
  });

  group('copyWith', () {
    final Place place = Place(
      address: 'Address',
      isFavorite: true,
      latitude: 0,
      longitude: 0,
      name: 'Name',
      tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
    );
    test('This method must copy all parameters and update the ones provided.',
        () {
      expect(
        place.copyWith(),
        place,
        reason:
            'Without any parameters passed to [copyWith], it must return the'
            ' original [place].',
      );
      expect(
        place.copyWith(address: 'New address'),
        Place(
          address: 'New address',
          isFavorite: true,
          latitude: 0,
          longitude: 0,
          name: 'Name',
          tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
        ),
        reason: 'Must change the value of [address] property.',
      );
      expect(
        place.copyWith(isFavorite: false),
        Place(
          address: 'Address',
          latitude: 0,
          longitude: 0,
          name: 'Name',
          tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
        ),
        reason: 'Must change the value of [isFavorite] property.',
      );
      expect(
        place.copyWith(latitude: 7.75),
        Place(
          address: 'Address',
          isFavorite: true,
          latitude: 7.75,
          longitude: 0,
          name: 'Name',
          tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
        ),
        reason: 'Must change the value of [latitude] property.',
      );
      expect(
        place.copyWith(longitude: 5.85),
        Place(
          address: 'Address',
          isFavorite: true,
          latitude: 0,
          longitude: 5.85,
          name: 'Name',
          tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
        ),
        reason: 'Must change the value of [longitude] property.',
      );
      expect(
        place.copyWith(name: 'New name'),
        Place(
          address: 'Address',
          isFavorite: true,
          latitude: 0,
          longitude: 0,
          name: 'New name',
          tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
        ),
        reason: 'Must change the value of [name] property.',
      );
      expect(
        place.copyWith(tags: SplayTreeSet.from(['tag1'])),
        Place(
          address: 'Address',
          isFavorite: true,
          latitude: 0,
          longitude: 0,
          name: 'Name',
          tags: SplayTreeSet<String>.from(['tag1']),
        ),
        reason: 'Must change the value of [tags] property.',
      );
    });
  });

  group('distanceWGS84:', () {
    final Place place1 = Place(
      address: 'address',
      latitude: 50,
      longitude: 120.537,
      name: 'name',
      tags: SplayTreeSet.from([]),
    );
    final Place place2 = Place(
      address: 'address',
      latitude: -35,
      longitude: 1.5,
      name: 'name',
      tags: SplayTreeSet.from([]),
    );
    final Place place3 = Place(
      address: 'address',
      latitude: 35,
      longitude: -1.5,
      name: 'name',
      tags: SplayTreeSet.from([]),
    );
    test(
        'This method must correctly calculate the distance between two'
        ' [Place]s.', () {
      expect(
        place1.distanceWGS84(place2).toStringAsFixed(3),
        '14893927.432',
        reason: 'The distance between [place1] and [place2] is equal to'
            ' 14893927.432.',
      );
      expect(
        place2.distanceWGS84(place1).toStringAsFixed(3),
        '14893927.432',
        reason: 'The distance between [place1] and [place2] is the same as that'
            ' between [place2] and [place1].',
      );
      expect(
        place1.distanceWGS84(place3).toStringAsFixed(3),
        '9005181.491',
        reason: 'The distance between [place1] and [place2] is equal to'
            ' 9005181.491.',
      );
    });
  });

  group('toJson:', () {
    test('This method must return the corresponding JSON string.', () {
      final Place place1 = Place(
        address: 'This is the address',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'This is the name',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      // ignore: prefer_single_quotes
      expect(
        place1.toJson(),
        // ignore: missing_whitespace_between_adjacent_strings
        '{"address":"This is the address","isfavorite":true,"latitude":0.0,'
        // ignore: missing_whitespace_between_adjacent_strings
        '"longitude":0.0,"name":"This is the name","tags":["tag1","tag2",'
        '"tag3"]}',
        reason: '[latitude] and [longitude] are passed as 0.',
      );
      final Place place2 = Place(
        address: 'This is the address',
        isFavorite: true,
        latitude: 0.123456789012,
        longitude: 0.123456789012,
        name: 'This is the name',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      // ignore: prefer_single_quotes
      expect(
        place2.toJson(),
        // ignore: missing_whitespace_between_adjacent_strings
        '{"address":"This is the address","isfavorite":true,'
        '"latitude":0.123456789012,"longitude":0.123456789012,'
        '"name":"This is the name","tags":["tag1","tag2","tag3"]}',
        reason: '[latitude] and [longitude] are passed with 12 decimal places.',
      );
    });
  });

  group('toMap:', () {
    test('This method must return a map (String, dynamic).', () {
      final Place place1 = Place(
        address: 'This is the address',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'This is the name',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      expect(
        place1.toMap(),
        {
          'address': 'This is the address',
          'isfavorite': true,
          'latitude': 0,
          'longitude': 0,
          'name': 'This is the name',
          'tags': ['tag1', 'tag2', 'tag3'],
        },
        reason: 'All parameters are specified.',
      );
      final Place place2 = Place(
        address: 'This is the address',
        latitude: 0,
        longitude: 0,
        name: 'This is the name',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      expect(
        place2.toMap(),
        {
          'address': 'This is the address',
          'isfavorite': false,
          'latitude': 0,
          'longitude': 0,
          'name': 'This is the name',
          'tags': ['tag1', 'tag2', 'tag3'],
        },
        reason: 'The parameter [isFavorite] is not specified.',
      );
      final Place place3 = Place(
        address: 'This is the address',
        latitude: 0,
        longitude: 0,
        name: 'This is the name',
        tags: SplayTreeSet.from([]),
      );
      expect(
        place3.toMap(),
        {
          'address': 'This is the address',
          'isfavorite': false,
          'latitude': 0,
          'longitude': 0,
          'name': 'This is the name',
          'tags': [],
        },
        reason: 'The parameter [isFavorite] is not specified and the [tags]'
            ' parameter is an empty set of strings.',
      );
    });
  });

  group('@override compareTo and inequality operators:', () {
    final Place place = Place(
      address: 'Address',
      isFavorite: true,
      latitude: 1.5,
      longitude: 1.5,
      name: 'Name',
      tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
    );
    test('With only one different property.', () {
      // [address]
      final Place placeDifferentAddress =
          place.copyWith(address: 'New address');
      expect(
        placeDifferentAddress.compareTo(place),
        isPositive,
        reason: 'In alphabetical order, the address of [placeDifferentAddress]'
            ' comes after that of [place].',
      );
      expect(placeDifferentAddress < place, isFalse);
      expect(placeDifferentAddress <= place, isFalse);
      expect(placeDifferentAddress >= place, isTrue);
      expect(placeDifferentAddress > place, isTrue);
      // [isFavorite]
      final Place placeDifferentIsFavorite = place.copyWith(isFavorite: false);
      expect(
        placeDifferentIsFavorite.compareTo(place),
        isPositive,
        reason: '[placeDifferentIsFavorite] is not a favorite, and therefore'
            ' comes after [place], which is a favorite.',
      );
      expect(placeDifferentIsFavorite < place, isFalse);
      expect(placeDifferentIsFavorite <= place, isFalse);
      expect(placeDifferentIsFavorite >= place, isTrue);
      expect(placeDifferentIsFavorite > place, isTrue);
      // [latitude]
      final Place placeDifferentLatitude = place.copyWith(latitude: 0);
      expect(
        placeDifferentLatitude.compareTo(place),
        isNegative,
        reason: '[placeDifferentLatitude] is closer to the point with'
            ' coordinates (0, 0), since it coincides with the that, and'
            ' therefore comes before [place], which has a certain distance from'
            ' the point (0, 0).',
      );
      expect(placeDifferentLatitude < place, isTrue);
      expect(placeDifferentLatitude <= place, isTrue);
      expect(placeDifferentLatitude >= place, isFalse);
      expect(placeDifferentLatitude > place, isFalse);
      // [longitude]
      final Place placeDifferentLongitude = place.copyWith(longitude: 0);
      expect(
        placeDifferentLongitude.compareTo(place),
        isNegative,
        reason: '[placeDifferentLongitude] is closer to the point with'
            ' coordinates (0, 0), since it coincides with the that, and'
            ' therefore comes before [place], which has a certain distance from'
            ' the point (0, 0).',
      );
      expect(placeDifferentLongitude < place, isTrue);
      expect(placeDifferentLongitude <= place, isTrue);
      expect(placeDifferentLongitude >= place, isFalse);
      expect(placeDifferentLongitude > place, isFalse);
      // [name]
      final Place placeDifferentName = place.copyWith(name: 'New name');
      expect(
        placeDifferentName.compareTo(place),
        isPositive,
        reason: 'In alphabetical order, the name of [placeDifferentName]'
            ' comes after that of [place].',
      );
      expect(placeDifferentName < place, isFalse);
      expect(placeDifferentName <= place, isFalse);
      expect(placeDifferentName >= place, isTrue);
      expect(placeDifferentName > place, isTrue);
      // [tags] (with a different number of tags)
      final Place placeDifferentTags = place.copyWith(
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3', 'tag4', 'tag5']),
      );
      expect(
        placeDifferentTags.compareTo(place),
        isNegative,
        reason: '[placeDifferentTags] has more associated tags than [place],'
            ' and therefore comes first.',
      );
      expect(placeDifferentTags < place, isTrue);
      expect(placeDifferentTags <= place, isTrue);
      expect(placeDifferentTags >= place, isFalse);
      expect(placeDifferentTags > place, isFalse);
      // [tags] (with the same number of tags)
      final Place placeDifferentTagsSameNumber = place.copyWith(
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag4']),
      );
      expect(
        placeDifferentTagsSameNumber.compareTo(place),
        isPositive,
        reason: 'The tag that belongs to only one of the 2 places, and which'
            ' comes first alphabetically, is tag3, which belongs to the'
            ' [place].',
      );
      expect(placeDifferentTagsSameNumber < place, isFalse);
      expect(placeDifferentTagsSameNumber <= place, isFalse);
      expect(placeDifferentTagsSameNumber >= place, isTrue);
      expect(placeDifferentTagsSameNumber > place, isTrue);
    });
    test('With more different properties.', () {
      // 1st step: the distance from the point (0, 0)
      final Place placeX = Place(
        address: 'address',
        isFavorite: true,
        latitude: 0,
        longitude: 3.752,
        name: 'name',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      final Place placeY = Place(
        address: 'address2',
        isFavorite: true,
        latitude: 3.7521,
        longitude: 0,
        name: 'name',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      expect(
        placeX.compareTo(placeY),
        isNegative,
        reason: 'The comparison stops at the 1st step, because the distance'
            ' from the point (0, 0) is greater in the case of [placeY] than in'
            ' the case of [placeX].',
      );
      expect(placeX < placeY, isTrue);
      expect(placeX <= placeY, isTrue);
      expect(placeX >= placeY, isFalse);
      expect(placeX > placeY, isFalse);
      // 2nd step: the address
      final Place placeAddress1 = Place(
        address: 'address1',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'name',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      final Place placeAddress2 = Place(
        address: 'address2',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'name2',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      expect(
        placeAddress1.compareTo(placeAddress2),
        isNegative,
        reason: 'The comparison stops at the 2nd step, because the distance'
            ' from the point (0, 0) is the same, but the address of'
            ' [placeAddress2] comes after that of [placeAddress1] in'
            ' alphabetical order.',
      );
      expect(placeAddress1 < placeAddress2, isTrue);
      expect(placeAddress1 <= placeAddress2, isTrue);
      expect(placeAddress1 >= placeAddress2, isFalse);
      expect(placeAddress1 > placeAddress2, isFalse);
      // 3rd step: the name
      final Place placeName1 = Place(
        address: 'address1',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'name1',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      final Place placeName2 = Place(
        address: 'address1',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'name2',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      expect(
        placeName1.compareTo(placeName2),
        isNegative,
        reason: 'The comparison stops at the 3rd step, because the distance'
            ' from the point (0, 0) and the address are the same, but the name'
            ' of [placeName1] comes after that of [placeName2] in alphabetical'
            ' order.',
      );
      expect(placeName1 < placeName2, isTrue);
      expect(placeName1 <= placeName2, isTrue);
      expect(placeName1 >= placeName2, isFalse);
      expect(placeName1 > placeName2, isFalse);
      // 4th step: the favorite
      final Place placeIsFavorite1 = Place(
        address: 'address1',
        latitude: 0,
        longitude: 0,
        name: 'name1',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      final Place placeIsFavorite2 = Place(
        address: 'address1',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'name1',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      expect(
        placeIsFavorite1.compareTo(placeIsFavorite2),
        isPositive,
        reason: 'The comparison stops at the 4th step, because the distance'
            ' from the point (0, 0), the address and the name are the same, but'
            ' while [placeIsFavorite1] is not a favorite place,'
            ' [placeIsFavorite2] is.',
      );
      expect(placeIsFavorite1 < placeIsFavorite2, isFalse);
      expect(placeIsFavorite1 <= placeIsFavorite2, isFalse);
      expect(placeIsFavorite1 >= placeIsFavorite2, isTrue);
      expect(placeIsFavorite1 > placeIsFavorite2, isTrue);
      // 5th step: fewer associated tags
      final Place placeTags1 = Place(
        address: 'address1',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'name1',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      final Place placeTags2 = Place(
        address: 'address1',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'name1',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3', 'tag4']),
      );
      expect(
        placeTags1.compareTo(placeTags2),
        isPositive,
        reason: 'The comparison stops at the 5th step, because the distance'
            ' from the point (0, 0), the address and the name are the same, and'
            ' both are favorite places, but [placeTags1] has fewer associated'
            ' tags than [placeTags2].',
      );
      expect(placeTags1 < placeTags2, isFalse);
      expect(placeTags1 <= placeTags2, isFalse);
      expect(placeTags1 >= placeTags2, isTrue);
      expect(placeTags1 > placeTags2, isTrue);
      // 6th step: the tag that comes first alphabetically among those not
      // shared
      final Place placeTags3 = Place(
        address: 'address1',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'name1',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      final Place placeTags4 = Place(
        address: 'address1',
        isFavorite: true,
        latitude: 0,
        longitude: 0,
        name: 'name1',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag4']),
      );
      expect(
        placeTags3.compareTo(placeTags4),
        isNegative,
        reason: 'The comparison stops at the 6th step, because the distance'
            ' from the point (0, 0), the address, the name are the same, both'
            ' are favorite places, the number of associated tags is the same,'
            ' but [placeTags3] has the tag that comes first alphabetically'
            ' among those not shared.',
      );
      expect(placeTags3 < placeTags4, isTrue);
      expect(placeTags3 <= placeTags4, isTrue);
      expect(placeTags3 >= placeTags4, isFalse);
      expect(placeTags3 > placeTags4, isFalse);
    });
  });

  group('hashCode and == operator:', () {
    final Place place = Place(
      address: 'This is the address',
      isFavorite: true,
      latitude: 3.57,
      longitude: 1.175,
      name: 'This is the name',
      tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
    );
    test('The [hashCode] of two equal places must be the same.', () {
      final Place equalToPlace = Place(
        address: 'This is the address',
        isFavorite: true,
        latitude: 3.57,
        longitude: 1.175,
        name: 'This is the name',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
      );
      expect(
        place.hashCode == equalToPlace.hashCode,
        isTrue,
        reason: '[place] and [equalToPlace] have the exact same properties.',
      );
    });
    test('If even one property is different, the [hashCode] must be different.',
        () {
      final Place slightlyDifferentFromPlace = Place(
        address: 'This is the address',
        isFavorite: true,
        latitude: 3.57,
        longitude: 1.175,
        name: 'This is the name',
        tags: SplayTreeSet.from(['tag1', 'tag2', 'tag4']),
      );
      expect(
        place.hashCode != slightlyDifferentFromPlace.hashCode,
        isTrue,
        reason: 'The [slightlyDifferentFromPlace] tag list does not contain'
            ' tag3 (which instead contains the [place] tag list), but contains'
            ' tag4 (which the [place] tag list does not contain).',
      );
    });
  });
}
