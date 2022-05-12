## 2.0.0

Release date: 2022-05-12.

### Added

* **Breaking change.** [`Place` class] The `factory Place.fromJson(final String json)` constructor has been added.
* **Breaking change.** [`Place` class] Two properties have been added (`double latitude` and `double longitude`) for defining the geographic location of the place.
* **Breaking change.** [`Place` class] The `toJson()` method was added.

### Changed

* **Breaking change.** Minimum Dart SDK was updated to `2.17.0`.
* This package no longer depends on Flutter.
* **Breaking change.** [`Country` enum] The `name` property is now the one introduced by Dart 2.17. In its place is now the `englishName` property.
* **Breaking change.** [`Place` class] The `tags` property is no longer a `List<String>`, but an `SplayTreeSet<String>`.

### Removed

* **Breaking change.** [`Country` enum] The `toCountry()` extension method on the `String` class has been removed. To create an instance of the `Country` enum, use the `Country.parse(final String formattedString)` constructor.
* **Breaking change.** [`Country` enum] The `string()` extension method has been removed.
* **Breaking change.** [`Place` class] The `LatLng position` property has been removed (the `LatLng` class is defined in the [`google_maps_flutter`](https://pub.dev/packages/google_maps_flutter) package). The reason is that I preferred this package to have as few dependencies as possible.

## 1.3.2

Release date: 2021-08-05.

### Added

* [`Country` enum] Added `compareTo()` extension method.

## 1.3.1

Release date: 2021-06-19.

### Added

* [`Country` enum] Added `string()` method.
* [`Country` enum] Added an extension method on `String` class in order to try to convert it to a `Country` value.

## 1.3.0

Release date: 2021-06-19.

### Added

* [`Country` enum] Added `Country` enumeration.

### Changed

* Minimum Dart SDK was updated to `2.13.3` version and Flutter to `2.2.2` version.

## 1.2.0

Release date: 2021-05-20.

### Changed

* This now uses the newer [`lints`](https://pub.dev/packages/lints) developer dependency.
* Minimum Dart SDK was updated to `2.13.0` version and Flutter to `2.0.0` version.

### Removed

* Removed [`pedantic`](https://pub.dev/packages/pedantic) developer dependency.

## 1.1.2

Release date: 2021-05-06.

### Fixed

* Fixed a minor issue.

## 1.1.1

Release date: 2021-05-06.

### Changed

* [`Place` class] In the `Place.fromMap(Map<String, dynamic> map)` constructor, the `List<dynamic> map['tags']` list is now casted `as List<String>`.

## 1.1.0

Release date: 2021-02-23.

### Changed

* **Breaking change.** [`Place` class] Removed `latitude` and `longitude` fields of `Place` class. Now the position is stored in the `LatLng position` field (`LatLng` is a class from [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) package).

## 1.0.0

Release date: 2021-02-17.

### Changed

* Stable null safety release.

## 0.1.0-nullsafety.3

Release date: 2021-01-26.

### Removed

* [`Place` class] Removed `@immutable` annotation for the `Place` class.

## 0.1.0-nullsafety.2

Release date: 2021-01-26.

### Added

* Added repository reference.

## 0.1.0-nullsafety.1

Release date: 2021-01-25.

* First pre-release.

### Added

* Added `Place` class.
