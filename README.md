![](https://img.shields.io/badge/pub-v1.0.0-blue)

# Geos

A set of classes useful in geographical context.

## `Place` class

This class represents a place. The properties it has are:

* `String address`. The address expressed in one `String`.
* `double latitude`. The latitude coordinate, expressed using degrees.
* `double longitude`. The longitude coordinate, expressed using degrees.
* `String name`. A personalized name that you can give to this place.
* `List<String> tags`. A list of tags that can be used, for example, in order to categorizing your places.

One notable method is `distanceWGS84()`, that gets the distance (m) between a place and another one on the *WGS-84 ellipsoidal earth* to within a few millimeters of accuracy using [Vincenty’s algorithm](https://en.wikipedia.org/wiki/Vincenty%27s_formulae).
