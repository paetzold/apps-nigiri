import 'package:equatable/equatable.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class LocationList {
  List<Location> locations = List<Location>();

  LocationList();

  LocationList.fromJson(List<dynamic> json) {
    json.forEach((l) => {this.locations.add(Location.fromJson(l))});
  }
}

class Location extends Equatable {
  final String id, name;
  final LatLng latlon;

  Location({this.id, this.name = '', this.latlon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'],
        name: json['title'],
        latlon: LatLng(
          json['location']['latitude'],
          json['location']['longitude'],
        ));
  }

  @override
  List<Object> get props => [name];
}
