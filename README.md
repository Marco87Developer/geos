<!--
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).
-->

![Pub Version (including pre-releases)](https://img.shields.io/pub/v/geos?include_prereleases)
![Dart GitHub Actions](https://github.com/Marco87Developer/geos/actions/workflows/dart.yml/badge.svg)
![GitHub Top Language](https://img.shields.io/github/languages/top/Marco87Developer/geos)

A set of classes useful in geographical context.

## Features

Easily create a country of the world and easily access information about it with the `Country` enum.

```dart
const Country italy = Country.italy;
print(italy.alpha2Code); // 'IT'
print(italy.alpha3Code); // 'ITA'
print(italy.englishName); // 'Italy'
print(italy.flagEmoji); // '🇮🇹'
print(italy.numericCode); // '380'
```

Easily create a place, give it a name, indicate the address and location, if it is a favorite place or not, and associate tags with it, with the `Place` class.

```dart
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
```
