import 'package:flutter/material.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mappy/api/models/location.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class TransitContext extends ChangeNotifier {
  Location origin, destination;

  List<Location> recently = List<Location>();

  var bounds;
  var routes;
  List<List<num>> polyline;

  static TransitContext of(BuildContext context) =>
      Provider.of<TransitContext>(context);

  from(Location orgin) {
    this.origin = origin;
    _addToRecently(orgin);
    print("Set destination to ${this.origin.name}");
  }

  to(Location destination) {
    this.destination = destination;
    _addToRecently(destination);
    print("Set destination to ${this.destination.name}");
  }

  void _addToRecently(Location location) {
    if (!recently.contains(location)) {
      recently.add(location);
    } else {}
  }

  List<Location> recentUsedLocations() {
    return recently;
  }

  void swap() {
    var temp = origin;
    origin = destination;
    destination = temp;
    notifyListeners();
  }

  search() {
    DirectionsService.init('AIzaSyAOpSWL1HBJ5jrMpQUUq_jM8gxB_ZQ3KA0');
    final directionsService = DirectionsService();
    final request = DirectionsRequest(
        origin: 'Hamburg, Grotenkamp, Germany',
        destination:
            "${this.destination.latlon.latitude},${this.destination.latlon.longitude}",
        travelMode: TravelMode.driving,
        unitSystem: UnitSystem.metric);
    directionsService.route(request,
        (DirectionsResult response, DirectionsStatus status) {
      if (status == DirectionsStatus.ok) {
        // do something with successful response
        print(response.routes);
        routes = response.routes;
        polyline = decodePolyline(response.routes[0].overviewPolyline.points);

        var sw = polyline.reduce((value, element) =>
            [min(value[0], element[0]), min(value[1], element[1])]);

        var ne = polyline.reduce((value, element) =>
            [max(value[0], element[0]), max(value[1], element[1])]);

        var dx = ne[0] - sw[0];
        var dy = ne[1] - sw[1];

        bounds = LatLngBounds(
            southwest: LatLng(sw[0] - dx / 2, sw[1] - dy / 2),
            northeast: LatLng(ne[0] + dx / 2, ne[1] + dy / 2));
      } else {
        // do something with error response
        print(status);
      }
      notifyListeners();
    });
  }

  clearRoutes() {
    routes = null;
    polyline = null;
    notifyListeners();
  }
}

Function WithTransitContext = (wrapped) => ChangeNotifierProvider(
    create: (context) => TransitContext(), child: wrapped);

Function UseTransitContext = (builder) => Consumer<TransitContext>(
      builder: builder,
    );
