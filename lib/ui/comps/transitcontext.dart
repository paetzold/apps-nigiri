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

  List<List<num>> polyline;
  var bounds;

  static TransitContext of(BuildContext context) =>
      Provider.of<TransitContext>(context);

  /// Internal, private state of the cart.
  //final List<Item> _items = [];

  /// An unmodifiable view of the items in the cart.
  //UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// The current total price of all items (assuming all items cost $42).
  //int get totalPrice => _items.length * 42;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  //void add(Item item) {
  //  _items.add(item);
  // This call tells the widgets that are listening to this model to rebuild.
  //  notifyListeners();
  //}

  /// Removes all items from the cart.
  //void removeAll() {
  //  _items.clear();
  // This call tells the widgets that are listening to this model to rebuild.
  //  notifyListeners();
  //}

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
}

Function WithTransitContext = (wrapped) => ChangeNotifierProvider(
    create: (context) => TransitContext(), child: wrapped);

Function UseTransitContext = (builder) => Consumer<TransitContext>(
      builder: builder,
    );
