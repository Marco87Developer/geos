// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:geos/src/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  test('toMap()', () {
    final Place place = Place(
      address: 'Address1',
      coordinates: LatLng(50, 120.537),
      name: 'Name1',
      tags: ['tag1', 'tag2', 'tag3'],
    );

    expect(
      place.toMap(),
      {
        'address': 'Address1',
        'latitude': '50.0000000',
        'longitude': '120.5370000',
        'name': 'Name1',
        'tags': ['tag1', 'tag2', 'tag3'],
      },
    );
  });

  test('Place.fromMap()', () {
    final Map<String, dynamic> mapOK = {
      'address': 'Address',
      'latitude': 50,
      'longitude': 120.537,
      'name': 'Name',
      'tags': ['tag1', 'tag2', 'tag3'],
    };

    expect(
        Place.fromMap(mapOK),
        Place(
          address: 'Address',
          coordinates: LatLng(50, 120.537),
          name: 'Name',
          tags: ['tag1', 'tag2', 'tag3'],
        ));
  });

  test('Tags', () {
    final Place place1 = Place(
      address: 'Address1',
      coordinates: LatLng(50, 120.537),
      name: 'Name1',
      tags: ['tag3', 'tag1', 'tag2', 'tag1'],
    );
    final Place place2 = Place(
      address: 'Address1',
      coordinates: LatLng(50, 120.537),
      name: 'Name1',
      tags: [],
    );

    expect(place1.tags, ['tag1', 'tag2', 'tag3']);

    place1..addTag('tag0')..addTag('tag0');

    expect(place1.tags, ['tag0', 'tag1', 'tag2', 'tag3']);

    expect(place2.tags, []);

    place2..addTag('tag2')..addTag('tag1');

    expect(place2.tags, ['tag1', 'tag2']);
  });

  test('copyWith()', () {
    final Place place1 = Place(
      address: 'Address1',
      coordinates: LatLng(50, 120.537),
      name: 'Name1',
      tags: ['tag3', 'tag1', 'tag2', 'tag1'],
    );
    final Place place2 = Place(
      address: 'Address1',
      coordinates: LatLng(50, 120.537),
      name: 'Name1',
      tags: [],
    );

    expect(place2.copyWith(tags: ['tag3', 'tag1', 'tag2', 'tag1']), place1);
  });

  test('distanceWGS84()', () {
    final Place place1 = Place(
      address: 'Address1',
      coordinates: LatLng(50, 120.537),
      name: 'Name1',
      tags: ['tag3', 'tag1', 'tag2', 'tag1'],
    );
    final Place place2 = Place(
      address: 'Address1',
      coordinates: LatLng(-35, 1.5),
      name: 'Name1',
      tags: ['tag3', 'tag1', 'tag2', 'tag1'],
    );
    final Place place3 = Place(
      address: 'Address1',
      coordinates: LatLng(35, -1.5),
      name: 'Name1',
      tags: ['tag3', 'tag1', 'tag2', 'tag1'],
    );

    expect(place1.distanceWGS84(place2).toStringAsFixed(3), '14893927.432');
    expect(place2.distanceWGS84(place1).toStringAsFixed(3), '14893927.432');
    expect(place1.distanceWGS84(place3).toStringAsFixed(3), '9005181.491');
  });
}
