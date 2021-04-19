import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class LocationList {
  List<Location> locations = List<Location>();

  LocationList();

  LocationList.fromJson(Map<String, dynamic> json) {
    json['list'].forEach((l) => {this.locations.add(Location.fromJson(l))});
  }
}

class Location extends Equatable {
  final String id, name;
  final LatLng latlon;
  final String type;

  Location({
    this.id,
    this.name = '',
    this.type = 'STOP',
    this.latlon,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        latlon: json.containsKey('location')
            ? LatLng(
                json['location']['lat'],
                json['location']['lon'],
              )
            : LatLng(
                json['lat'],
                json['lon'],
              ));
  }

  @override
  List<Object> get props => [name];
}
