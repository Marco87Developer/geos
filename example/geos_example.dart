import 'dart:collection';

import 'package:geos/geos.dart';

void main() {
  const Country italy = Country.italy;
  print(italy.alpha2Code); // 'IT'
  print(italy.alpha3Code); // 'ITA'
  print(italy.englishName); // 'Italy'
  print(italy.flagEmoji); // '🇮🇹'
  print(italy.numericCode); // '380'

  final Place myPlace = Place(
    address: 'This is the address 1',
    latitude: 10.1234567,
    longitude: 15.1234567,
    name: 'The name of this place 1',
    tags: SplayTreeSet.from([
      'tag1',
      'tag2',
      'tag3',
    ]),
  );
  final Place myFavoritePlace = Place(
    address: 'This is the address 2',
    isFavorite: true,
    latitude: 0.1,
    longitude: 0.5,
    name: 'The name of this place 2',
    tags: SplayTreeSet.from([
      'tag1',
      'tag2',
      'tag3',
    ]),
  );
  final double distance = myPlace.distanceWGS84(myFavoritePlace);
}
