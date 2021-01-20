![](https://img.shields.io/badge/pub-0.1.0--dev.1-orange)

**This package satisfies null safety almost completely. The only reason it doesn’t satisfy it 100% is because it depends on the [Google Maps for Flutter](https://pub.dev/packages/google_maps_flutter) package.**

# Geos

A set of classes useful in geographical context.

## `Place` class

This class represents a place. The properties it has are:

* `String address`. The address expressed in one `String`.
* `LatLng coordinates`. The coordinates, expressed using degrees. (`LatLng` is a class of the [Google Maps for Flutter](https://pub.dev/packages/google_maps_flutter) package.).
* `String name`. A personalized name that you can give to this place.
* `List<String> tags`. A list of tags that can be used, for example, in order to categorizing your places.

One notable method is `distanceWGS84()`, that gets the distance (m) between this place and another one on the *WGS-84 ellipsoidal earth* to within a few millimeters of accuracy using [Vincenty’s algorithm](https://en.wikipedia.org/wiki/Vincenty%27s_formulae).
