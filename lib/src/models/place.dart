import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:meta/meta.dart';

const _addressKey = 'address';
const _isFavoriteKey = 'isfavorite';
const _latitudeKey = 'latitude';
const _longitudeKey = 'longitude';
const _nameKey = 'name';
const _tagsKey = 'tags';

/// A geographical **place**.
///
/// {@template geos.place.oncecreatednopropertieschanges}
/// Once created, no properties of a [Place] object may be changed.
/// {@endtemplate}
///
@immutable
class Place implements Comparable<Place> {
  /// Constructs a [Place] instance.
  ///
  /// {@macro geos.place.oncecreatednopropertieschanges}
  ///
  const Place({
    required this.address,
    this.isFavorite = false,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.tags,
  });

  /// Constructs a [Place] instance from the [json] string.
  ///
  /// {@macro geos.place.oncecreatednopropertieschanges}
  ///
  /// ### Examples
  ///
  /// #### With a valid representation
  ///
  /// Given a JSON file (`place.json`) with the following content:
  ///
  /// ```json
  /// {
  ///     "address": "This is the address",
  ///     "isfavorite": true,
  ///     "latitude": 0.0,
  ///     "longitude": 0.0,
  ///     "name": "This is the name",
  ///     "tags": [
  ///         "tag1",
  ///         "tag2",
  ///         "tag3"
  ///     ]
  /// }
  /// ```
  ///
  /// you can save the corresponding string like this:
  ///
  /// ```dart
  /// final File file = File('place.json');
  /// final String json = await file.readAsString();
  /// ```
  ///
  /// and then you can construct a new instance of [Place] like this:
  ///
  /// ```dart
  /// Place.fromJson(json);
  ///   // Place(
  ///   //   address: 'This is the address',
  ///   //   isFavorite: true,
  ///   //   latitude: 0,
  ///   //   longitude: 0,
  ///   //   name: 'This is the name',
  ///   //   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  ///   // );
  /// ```
  ///
  /// #### With an invalid representation (1st case)
  ///
  /// Given a JSON file (`place_not_valid_1.json`) with the following content:
  ///
  /// ```json
  /// {
  ///     "address": "This is the address",
  ///     "isfavorite": true,
  ///     "latitude": "zero",
  ///     "longitude": 0.0,
  ///     "name": "This is the name",
  ///     "tags": [
  ///         "tag1",
  ///         "tag2",
  ///         "tag3"
  ///     ]
  /// }
  /// ```
  ///
  /// the string you can get is an invalid representation of a [Place]
  /// instance (`"latitude"` is expected to be a number). Therefore:
  ///
  /// ```dart
  /// final File file1 = File('place_not_valid_1.json');
  /// final String json1 = await file1.readAsString();
  /// Place.fromJson(json1);
  /// ```
  ///
  /// throws a [FormatException].
  ///
  /// #### With an invalid representation (2nd case)
  ///
  /// Instead, given a JSON file (`place_not_valid_2.json`) with the following
  /// content:
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// the string you can get is an invalid representation of a [Place]
  /// instance (it does not contain any required parameters). But this time, the
  /// following code:
  ///
  /// ```dart
  /// final File file2 = File('place_not_valid_2.json');
  /// final String json2 = await file2.readAsString();
  /// Place.fromJson(json2);
  /// ```
  ///
  /// throws an [Error].
  ///
  factory Place.fromJson(final String json) =>
      Place.fromMap(jsonDecode(json) as Map<String, dynamic>);

  /// Constructs a [Place] instance from [map].
  ///
  /// {@macro geos.place.oncecreatednopropertieschanges}
  ///
  /// ### Examples
  ///
  /// #### With a valid representation
  ///
  /// ```dart
  /// final Map<String, dynamic> map = {
  ///   'address': 'address',
  ///   'name': 'name',
  ///   'isfavorite': false,
  ///   'latitude': 0,
  ///   'longitude': 0,
  ///   'tags': <dynamic>['tag1', 'tag2', 'tag3'],
  /// };
  /// Place.fromMap(map);
  ///   // Place(
  ///   //   address: 'address',
  ///   //   latitude: 0,
  ///   //   longitude: 0,
  ///   //   name: 'name',
  ///   //   tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
  ///   // );
  /// ```
  ///
  /// #### With an invalid representation
  ///
  /// The following code:
  ///
  /// ```dart
  /// final Map<String, dynamic> invalidMap = {
  ///   'latitude': 0,
  ///   'longitude': 0,
  ///   'tags': <dynamic>['tag1', 'tag2', 'tag3'],
  /// };
  /// Place.fromMap(invalidMap);
  /// ```
  ///
  /// throws an [Error].
  ///
  Place.fromMap(final Map<String, dynamic> map)
      : address = '${map[_addressKey]}',
        isFavorite = map[_isFavoriteKey] as bool,
        latitude = double.parse('${map[_latitudeKey]}'),
        longitude = double.parse('${map[_longitudeKey]}'),
        name = '${map[_nameKey]}',
        tags = SplayTreeSet.from(
          (map[_tagsKey] as List<dynamic>).map((final e) => '$e'),
        );

  /// The **address** expressed with a string.
  final String address;

  /// Whether this place is **favorite or not**.
  final bool isFavorite;

  /// The **latitude** coordinate.
  final double latitude;

  /// The **longitude** coordinate.
  final double longitude;

  /// The **name** assigned to this place.
  final String name;

  /// The **tags** associated with this place.
  final SplayTreeSet<String> tags;

  /// Creates a **copy** of this [Place] instance but with the **given fields
  /// replaced** with the new values.
  ///
  /// ### Examples
  ///
  /// Given:
  ///
  /// ```dart
  /// final Place place = Place(
  ///   address: 'Address',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'Name',
  ///   tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// ```
  ///
  /// You will get:
  ///
  /// ```dart
  /// place.copyWith(); // place;
  /// place.copyWith(address: 'New address');
  ///   // Place(
  ///   //   address: 'New address',
  ///   //   isFavorite: true,
  ///   //   latitude: 0,
  ///   //   longitude: 0,
  ///   //   name: 'Name',
  ///   //   tags: SplayTreeSet<String>.from(['tag1', 'tag2', 'tag3']),
  ///   // );
  /// ```
  ///
  Place copyWith({
    final String? address,
    final bool? isFavorite,
    final double? latitude,
    final double? longitude,
    final String? name,
    final SplayTreeSet<String>? tags,
  }) =>
      Place(
        address: address ?? this.address,
        isFavorite: isFavorite ?? this.isFavorite,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        name: name ?? this.name,
        tags: tags ?? this.tags,
      );

  /// Calculates the **distance** (m) between this place and [other] place on
  /// the *WGS-84 ellipsoidal earth* to within a few millimeters of accuracy
  /// using
  /// [Vincenty’s algorithm](https://en.wikipedia.org/wiki/Vincenty%27s_formulae).
  ///
  /// ### Examples:
  ///
  /// Given the following [Place] instances:
  ///
  /// ```dart
  /// final Place place1 = Place(
  ///   address: 'address',
  ///   latitude: 50,
  ///   longitude: 120.537,
  ///   name: 'name',
  ///   tags: SplayTreeSet.from([]),
  /// );
  /// final Place place2 = Place(
  ///   address: 'address',
  ///   latitude: -35,
  ///   longitude: 1.5,
  ///   name: 'name',
  ///   tags: SplayTreeSet.from([]),
  /// );
  /// final Place place3 = Place(
  ///   address: 'address',
  ///   latitude: 35,
  ///   longitude: -1.5,
  ///   name: 'name',
  ///   tags: SplayTreeSet.from([]),
  /// );
  /// ```
  ///
  /// You will get:
  ///
  /// ```dart
  /// place1.distanceWGS84(place2); // 14893927.432...
  /// place2.distanceWGS84(place1); // 14893927.432...
  /// place1.distanceWGS84(place3); // 9005181.491...
  /// ```
  ///
  /// as expected.
  ///
  double distanceWGS84(final Place other) {
    const double a = 6378137;
    const double b = 6356752.31424518;
    const double f = (a - b) / a;

    /// From degrees to radians
    double lat1 = latitude * pi / 180;
    double lng1 = longitude * pi / 180;
    double lat2 = other.latitude * pi / 180;
    double lng2 = other.longitude * pi / 180;

    /// Correct for error at exact poles by adjusting 0.6 mm
    if ((pi / 2 - lat1.abs()).abs() < 1e-10) {
      lat1 = lat1.sign * (pi / 2 - 1e-10);
    }
    if ((pi / 2 - lat2.abs()).abs() < 1e-10) {
      lat2 = lat2.sign * (pi / 2 - 1e-10);
    }

    final double u1 = atan((1 - f) * tan(lat1));
    final double u2 = atan((1 - f) * tan(lat2));

    lng1 = lng1 % (2 * pi);
    lng2 = lng2 % (2 * pi);

    double l = (lng2 - lng1).abs();
    if (l > pi) {
      l = 2 * pi - l;
    }

    double lambda = l;
    double lambdaOld = 0;
    late double alpha;
    late double cos2SigmaM;
    late double sigma;

    for (int i = 0; (lambda - lambdaOld).abs() > 1e-12; i++) {
      if (i > 50) {
        lambda = pi;
      }

      lambdaOld = lambda;

      final double sinSigma = sqrt(
        pow(cos(u2) * sin(lambda), 2) +
            pow(cos(u1) * sin(u2) - sin(u1) * cos(u2) * cos(lambda), 2),
      );
      final double cosSigma =
          sin(u1) * sin(u2) + cos(u1) * cos(u2) * cos(lambda);
      sigma = atan2(sinSigma, cosSigma);
      alpha = asin(cos(u1) * cos(u2) * sin(lambda) / sin(sigma));
      cos2SigmaM = cos(sigma) - 2 * sin(u1) * sin(u2) / pow(cos(alpha), 2);
      final double c =
          f / 16 * pow(cos(alpha), 2) * (4 + f * (4 - 3 * pow(cos(alpha), 2)));

      lambda = l +
          (1 - c) *
              f *
              sin(alpha) *
              (sigma +
                  c *
                      sin(sigma) *
                      (cos2SigmaM +
                          c * cos(sigma) * (2 * pow(cos2SigmaM, 2) - 1)));

      if (lambda > pi) {
        lambda = pi;
        break;
      }
    }

    final double minorU2 =
        pow(cos(alpha), 2) * (pow(a, 2) - pow(b, 2)) / pow(b, 2);
    final double bigA = 1 +
        minorU2 /
            16384 *
            (4096 + minorU2 * (-768 + minorU2 * (320 - 175 * minorU2)));
    final double bigB = minorU2 /
        1024 *
        (256 + minorU2 * (-128 + minorU2 * (74 - 47 * minorU2)));
    final double deltaSigma = bigB *
        sin(sigma) *
        (cos2SigmaM +
            bigB /
                4 *
                (cos(sigma) * (-1 + 2 * pow(cos2SigmaM, 2)) -
                    bigB /
                        6 *
                        cos2SigmaM *
                        (-3 + 4 * pow(sin(sigma), 2)) *
                        (-3 + 4 * pow(cos2SigmaM, 2))));

    return b * bigA * (sigma - deltaSigma);
  }

  /// Creates a **JSON string representing** this [Place] instance.
  ///
  /// The resulting map can be parsed back using [Place.fromJson].
  ///
  /// ### Examples:
  ///
  /// ```dart
  /// Place(
  ///   address: 'This is the address',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'This is the name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// ).toJson();
  ///   // '{"address":"This is the address","isfavorite":true,"latitude":0.0,'
  ///   // '"longitude":0.0,"name":"This is the name","tags":["tag1","tag2",'
  ///   // '"tag3"]}';
  /// Place(
  ///   address: 'This is the address',
  ///   isFavorite: true,
  ///   latitude: 0.123456789012,
  ///   longitude: 0.123456789012,
  ///   name: 'This is the name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// ).toJson();
  ///   // '{"address":"This is the address","isfavorite":true,'
  ///   // '"latitude":0.123456789012,"longitude":0.123456789012,'
  ///   // '"name":"This is the name","tags":["tag1","tag2","tag3"]}'
  /// ```
  ///
  String toJson() => jsonEncode(toMap());

  /// Creates a **[Map<String, dynamic>] representing** this [Place] instance.
  ///
  /// The resulting map can be parsed back using [Place.fromMap].
  ///
  /// ### Examples:
  ///
  /// In case all parameters are specified:
  ///
  /// ```dart
  /// Place(
  ///   address: 'This is the address',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'This is the name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// ).toMap();
  ///   // {
  ///   //   'address': 'This is the address',
  ///   //   'isfavorite': true,
  ///   //   'latitude': 0,
  ///   //   'longitude': 0,
  ///   //   'name': 'This is the name',
  ///   //   'tags': ['tag1', 'tag2', 'tag3'],
  ///   // };
  /// ```
  ///
  /// In case the parameter [isFavorite] is not specified:
  ///
  /// ```dart
  /// Place(
  ///   address: 'This is the address',
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'This is the name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// ).toMap();
  ///   // {
  ///   //   'address': 'This is the address',
  ///   //   'isfavorite': false,
  ///   //   'latitude': 0,
  ///   //   'longitude': 0,
  ///   //   'name': 'This is the name',
  ///   //   'tags': ['tag1', 'tag2', 'tag3'],
  ///   // };
  /// ```
  ///
  /// In case the parameter [isFavorite] is not specified and the [tags]
  /// parameter is an empty set of strings:
  ///
  /// ```dart
  /// Place(
  ///   address: 'This is the address',
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'This is the name',
  ///   tags: SplayTreeSet.from([]),
  /// ).toMap();
  ///   // {
  ///   //   'address': 'This is the address',
  ///   //   'isfavorite': false,
  ///   //   'latitude': 0,
  ///   //   'longitude': 0,
  ///   //   'name': 'This is the name',
  ///   //   'tags': [],
  ///   // };
  /// ```
  ///
  Map<String, dynamic> toMap() => <String, dynamic>{
        _addressKey: address,
        _isFavoriteKey: isFavorite,
        _latitudeKey: latitude,
        _longitudeKey: longitude,
        _nameKey: name,
        _tagsKey: tags.toList(),
      };

  /// The **order of comparison** of the properties of this class is:
  ///
  /// 1. [latitude] and [longitude]
  /// 1. [address]
  /// 1. [name]
  /// 1. [isFavorite] (favorite places come first)
  /// 1. [tags] (places that have the most tags come first. If, on the other
  /// hand, the two places have the same number of associated [tags], the place
  /// that has the tag that is present only that place and that alphabetically
  /// comes before all the others, including those of the [other] place, will
  /// come first)
  ///
  /// ### Examples:
  ///
  /// The following examples start from this data:
  ///
  /// ```dart
  /// final Place place = Place(
  ///   address: 'Address',
  ///   isFavorite: true,
  ///   latitude: 1.5,
  ///   longitude: 1.5,
  ///   name: 'Name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// ```
  ///
  /// #### With only one different property
  ///
  /// ```dart
  /// final Place placeDifferentAddress =
  ///     place.copyWith(address: 'New address');
  /// placeDifferentAddress.compareTo(place); // isPositive
  ///
  /// final Place placeDifferentIsFavorite = place.copyWith(isFavorite: false);
  /// placeDifferentIsFavorite.compareTo(place); // isPositive
  ///
  /// final Place placeDifferentLatitude = place.copyWith(latitude: 0);
  /// placeDifferentLatitude.compareTo(place); // isNegative
  ///
  /// final Place placeDifferentLongitude = place.copyWith(longitude: 0);
  /// placeDifferentLongitude.compareTo(place); // isNegative
  ///
  /// final Place placeDifferentName = place.copyWith(name: 'New name');
  /// placeDifferentName.compareTo(place); // isPositive
  ///
  /// final Place placeDifferentTags = place.copyWith(
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3', 'tag4', 'tag5']),
  /// );
  /// placeDifferentTags.compareTo(place); // isNegative
  ///
  /// final Place placeDifferentTagsSameNumber = place.copyWith(
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag4']),
  /// );
  /// placeDifferentTagsSameNumber.compareTo(place); // isPositive
  /// ```
  ///
  /// #### With more different properties
  ///
  /// ```dart
  /// final Place placeX = Place(
  ///   address: 'address',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 3.752,
  ///   name: 'name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// final Place placeY = Place(
  ///   address: 'address2',
  ///   isFavorite: true,
  ///   latitude: 3.7521,
  ///   longitude: 0,
  ///   name: 'name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// placeX.compareTo(placeY); // isNegative
  ///
  /// final Place placeAddress1 = Place(
  ///   address: 'address1',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// final Place placeAddress2 = Place(
  ///   address: 'address2',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name2',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// placeAddress1.compareTo(placeAddress2); // isNegative
  ///
  /// final Place placeName1 = Place(
  ///   address: 'address1',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name1',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// final Place placeName2 = Place(
  ///   address: 'address1',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name2',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// placeName1.compareTo(placeName2); // isNegative
  ///
  /// final Place placeIsFavorite1 = Place(
  ///   address: 'address1',
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name1',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// final Place placeIsFavorite2 = Place(
  ///   address: 'address1',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name1',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// placeIsFavorite1.compareTo(placeIsFavorite2); // isPositive
  ///
  /// final Place placeTags1 = Place(
  ///   address: 'address1',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name1',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// final Place placeTags2 = Place(
  ///   address: 'address1',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name1',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3', 'tag4']),
  /// );
  /// placeTags1.compareTo(placeTags2); // isPositive
  ///
  /// final Place placeTags3 = Place(
  ///   address: 'address1',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name1',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// final Place placeTags4 = Place(
  ///   address: 'address1',
  ///   isFavorite: true,
  ///   latitude: 0,
  ///   longitude: 0,
  ///   name: 'name1',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag4']),
  /// );
  /// placeTags3.compareTo(placeTags4); // isNegative
  /// ```
  ///
  @override
  int compareTo(covariant final Place other) {
    final num quadraticDistanceFromOrigin =
        pow(latitude, 2) + pow(longitude, 2);
    final num otherQuadraticDistanceFromOrigin =
        pow(other.latitude, 2) + pow(other.longitude, 2);

    // 1º comparison
    final int comparison1 =
        quadraticDistanceFromOrigin.compareTo(otherQuadraticDistanceFromOrigin);
    if (comparison1 != 0) return comparison1;
    // 2º comparison
    final int comparison2 = address.compareTo(other.address);
    if (comparison2 != 0) return comparison2;
    // 3º comparison
    final int comparison3 = name.compareTo(other.name);
    if (comparison3 != 0) return comparison3;
    // 4º comparison
    final int comparison4 =
        -isFavorite.toString().compareTo(other.isFavorite.toString());
    if (comparison4 != 0) return comparison4;
    // Last comparison
    final int comparison5 = -tags.length.compareTo(other.tags.length);
    if (comparison5 != 0) return comparison5;
    for (int i = 0; i < tags.length; i++) {
      final int comparison6 =
          tags.elementAt(i).compareTo(other.tags.elementAt(i));
      if (comparison6 != 0) return comparison6;
    }
    return 0;
  }

  /// The **hash code** of this [Place] instance.
  ///
  /// ### Examples:
  ///
  /// ```dart
  /// final Place place = Place(
  ///   address: 'This is the address',
  ///   isFavorite: true,
  ///   latitude: 3.57,
  ///   longitude: 1.175,
  ///   name: 'This is the name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  ///
  /// final Place equalToPlace = Place(
  ///   address: 'This is the address',
  ///   isFavorite: true,
  ///   latitude: 3.57,
  ///   longitude: 1.175,
  ///   name: 'This is the name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag3']),
  /// );
  /// place.hashCode == equalToPlace.hashCode; // isTrue
  ///
  /// final Place slightlyDifferentFromPlace = Place(
  ///   address: 'This is the address',
  ///   isFavorite: true,
  ///   latitude: 3.57,
  ///   longitude: 1.175,
  ///   name: 'This is the name',
  ///   tags: SplayTreeSet.from(['tag1', 'tag2', 'tag4']),
  /// );
  /// place.hashCode != slightlyDifferentFromPlace.hashCode; // isTrue
  /// ```
  ///
  @override
  int get hashCode => Object.hash(
        address,
        isFavorite,
        latitude,
        longitude,
        name,
        Object.hashAll(tags),
      );

  /// Returns if this instance is **smaller than** the [other].
  ///
  bool operator <(covariant final Place other) => compareTo(other) < 0;

  /// Returns if this instance is **smaller than or equal to** the [other].
  ///
  bool operator <=(covariant final Place other) => compareTo(other) <= 0;

  /// Returns if this instance is **the same as** the [other].
  ///
  @override
  bool operator ==(covariant final Place other) => compareTo(other) == 0;

  /// Returns if this instance is **greater than or equal to** the [other].
  ///
  bool operator >=(covariant final Place other) => compareTo(other) >= 0;

  /// Returns if this instance is **greater than** the [other].
  ///
  bool operator >(covariant final Place other) => compareTo(other) > 0;
}
