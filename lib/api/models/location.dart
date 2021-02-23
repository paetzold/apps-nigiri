import 'package:mapbox_gl/mapbox_gl.dart';

class LocationList {
  List<Location> locations = List<Location>();

  LocationList() {}

  LocationList.fromJson(List<dynamic> json) {
    json.forEach((l) => {this.locations.add(Location.fromJson(l))});
  }
}

class Location {
  String id, name;
  LatLng latlon;

  Location({this.name = '', this.latlon});

  Location.fromJson(Map<String, dynamic> json) {
    this.name = json['title'];
    this.latlon = LatLng(
      json['location']['latitude'],
      json['location']['longitude'],
    );
  }
}
