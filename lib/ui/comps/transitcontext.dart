import 'package:flutter/material.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mappy/api/models/location.dart';
import 'package:provider/provider.dart';

class TransitContext extends ChangeNotifier {
  Location origin, destination;

  var polyline;

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
    print("Set destination to ${this.origin.name}");
  }

  to(Location destination) {
    this.destination = destination;
    print("Set destination to ${this.destination.name}");
  }

  swap() {
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
      } else {
        // do something with error response
        print(status);
      }
      notifyListeners();
    });
  }
}

/**
   *   last, searach,
   */

Function WithTransitContext = (wrapped) => ChangeNotifierProvider(
    create: (context) => TransitContext(), child: wrapped);

Function UseTransitContext = (builder) => Consumer<TransitContext>(
      builder: builder,
    );
