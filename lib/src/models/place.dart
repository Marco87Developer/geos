import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

const String _addressKey = 'address';
const String _latitudeKey = 'latitude';
const String _longitudeKey = 'longitude';
const String _nameKey = 'name';
const String _tagsKey = 'tags';

/// This class models a representation of a place.
///
class Place implements Comparable {
  /// Representation of a place.
  ///
  /// It **requires** these fields: `String` [address], `double` [latitude] and
  /// `double` [longitude].
  ///
  const Place({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.name = '',
    required List<String> tags,
  }) : _tags = tags;

  /// Creates an `Place` instance starting from a `Map<String, dynamic> map`.
  ///
  /// This can be useful for retrieving the instance from a database.
  ///
  Place.fromMap(Map<String, dynamic> map)
      : address = map[_addressKey],
        latitude = double.parse('${map[_latitudeKey]}'),
        longitude = double.parse('${map[_longitudeKey]}'),
        name = map[_nameKey],
        _tags = map[_tagsKey];

  /// This address expressed in the string format.
  final String address;

  /// The latitude coordinate, stored as degrees, of this place.
  final double latitude;

  /// The longitude coordinate, stored as degrees, of this place.
  final double longitude;

  /// This is the name for the place.
  final String name;

  /// The tags associated with this place.
  final List<String> _tags;

  /// Returns the sorted list of [tags], each of which with only 1 occurrence.
  List<String> get tags =>
      List.unmodifiable(SplayTreeSet<String>.from(_tags).toList());

  /// Add a [tag] to the list of the tags for this place.
  void addTag(String tag) {
    if (!_tags.contains(tag)) _tags.add(tag);
    _tags.sort();
  }

  /// Returns a copy of this instance with fields updated according with the
  /// specified parameter values.
  ///
  Place copyWith({
    String? address,
    double? latitude,
    double? longitude,
    String? name,
    List<String>? tags,
  }) =>
      Place(
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        name: name ?? this.name,
        tags: tags ?? this.tags,
      );

  /// Calculates the distance (m) between this place and [other] place on the
  /// *WGS-84 ellipsoidal earth* to within a few millimeters of accuracy using
  /// [Vincenty’s algorithm](https://en.wikipedia.org/wiki/Vincenty%27s_formulae).
  ///
  double distanceWGS84(Place other) {
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

      final double sinSigma = sqrt(pow(cos(u2) * sin(lambda), 2) +
          pow(cos(u1) * sin(u2) - sin(u1) * cos(u2) * cos(lambda), 2));
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

  /// Creates a `Map<String, dynamic> map` representation of this instance.
  ///
  /// This can be useful for saving the instance in a database.
  ///
  Map<String, dynamic> toMap() => {
        _addressKey: address,
        _latitudeKey: latitude.toStringAsFixed(12),
        _longitudeKey: longitude.toStringAsFixed(12),
        _nameKey: name,
        _tagsKey: tags,
      };

  /// The order of the comparisons is:
  ///
  /// 1. Quadratic distance from the origin ([latitude].latitude² +
  /// [latitude].longitude²)
  /// 2. [address]
  /// 3. [name]
  ///
  @override
  int compareTo(covariant Place other) {
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

    // Last comparison
    final int comparison3 = name.compareTo(other.name);
    return comparison3;
  }

  @override
  int get hashCode => hashValues(address, latitude, longitude, name);

  /// Returns if this instance is less than the [other].
  ///
  bool operator <(covariant Place other) => compareTo(other) < 0;

  /// Return if this instance is less than or equal to the [other].
  ///
  bool operator <=(covariant Place other) => compareTo(other) <= 0;

  @override
  bool operator ==(covariant Place other) => compareTo(other) == 0;

  /// Return if this instance is greater than or equal to the [other].
  ///
  bool operator >=(covariant Place other) => compareTo(other) >= 0;

  /// Return if this instance is greater than the [other].
  ///
  bool operator >(covariant Place other) => compareTo(other) > 0;
}
