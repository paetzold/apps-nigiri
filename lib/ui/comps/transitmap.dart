import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mappy/api/geo.api.dart';
import 'package:mappy/blocs/geocoding.bloc.dart';
import 'package:mappy/blocs/geocoding.event.dart';

class TransitMap extends StatefulWidget {
  final String api_key;
  final String style;
  var route;
  var bounds;

  final Function onSelectStop;

  GlobalKey _mapKey = GlobalKey();

  TransitMap(
      {Key key,
      this.api_key,
      this.style,
      this.bounds,
      this.route,
      this.onSelectStop})
      : super(key: key) {}

  @override
  TransitMapState createState() => TransitMapState();
}

class TransitMapState extends State<TransitMap> {
  MapboxMapController _mapController;
  var _selectedSymbol;

  void animateTo(LatLng position, double zoom) {
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(position, zoom));
  }

  @override
  Widget build(BuildContext context) {
    if (_mapController != null) {
      if (widget.bounds != null) {
        _mapController
            .animateCamera(CameraUpdate.newLatLngBounds(widget.bounds));
      }
      if (widget.route != null) {
        addPolyline(widget.route);
      } else {
        _mapController.clearLines();
      }
    }

    return Container(
      child: MapboxMap(
          myLocationEnabled: true,
          accessToken: widget.api_key,
          styleString: widget.style,
          minMaxZoomPreference: const MinMaxZoomPreference(6.0, 19.0),
          initialCameraPosition: CameraPosition(
            zoom: 13.0,
            target: LatLng(53.6, 9.89),
          ),
          onMapCreated: (MapboxMapController controller) async {
            _mapController = controller;
            _mapController.onSymbolTapped.add((symbol) {
              _onSymbolTapped(symbol);
            });

            final result = LatLng(53.6, 9.89); // wait acquireCurrentLocation();
            await controller
                .animateCamera(CameraUpdate.newLatLngZoom(result, 13.0));
            await controller.addCircle(
              CircleOptions(
                circleRadius: 8.0,
                circleColor: '#006992',
                circleOpacity: 0.5,
                geometry: result,
                draggable: false,
              ),
            );
/*                             await controller.addLine(LineOptions.defaultOptions,
                                transitContext.polyline); */
          },
          onMapClick: (Point<double> point, LatLng coordinates) {
            BlocProvider.of<GeocodingBloc>(context).add(
              RequestGeocodingEvent(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
              ),
            );
            //_setupBottomModalSheet(cntx);
          },
          onCameraIdle: () async {
            var bounds = await _mapController.getVisibleRegion();
            var l = await GeoApiRepository.instance.searchWithin(bounds);

            List<SymbolOptions> symbols = l.locations
                .map((s) {
                  return SymbolOptions(
                      iconSize: (_selectedSymbol == null)
                          ? 1
                          : (s.id == _selectedSymbol?.data["id"])
                              ? 2
                              : 1,
                      textOffset: Offset(0, 0.8),
                      textAnchor: 'top',
                      textColor: '#FF0000',
                      geometry: LatLng(
                          s.latlon.latitude,
                          s.latlon
                              .longitude), // location is 0.0 on purpose for this example
                      iconOpacity: 1,
                      iconImage: _locationTypeToIconName(s.type));
                })
                .cast<SymbolOptions>()
                .toList();

            List<Map> data = l.locations
                .map((s) {
                  return {
                    'id': s.id,
                    'name': s.name,
                    'latLon': LatLng(s.latlon.latitude, s.latlon.longitude)
                  };
                })
                .cast<Map>()
                .toList();

            //await _mapController.clearSymbols();
            await _mapController.addSymbols(symbols, data);
          }

          // onMapLongClick: (Point<double> point, LatLng coordinates) async {
          //   final ByteData imageBytes =
          //       await rootBundle.load('assets/place_24px.png');
          //   final Uint8List bytesList = imageBytes.buffer.asUint8List();
          //   await _mapController.addImage('place_icon', bytesList);
          //   await _mapController.addSymbol(
          //     SymbolOptions(
          //       iconImage: 'place_icon',
          //       iconSize: 2.5,
          //       geometry: coordinates,
          //     ),
          //   );
          // },
          ),
    );
  }

  String _locationTypeToIconName(var locationtype) {
    switch (locationtype) {
      case 'BIKE_DOCK':
        return 'bicycle-15';
      case 'STATION':
        return 'milan-metro';
      default:
        return 'e-scooter';
    }
  }

  void addPolyline(route) {
    _mapController.clearLines();
    var t = route
        .map((p) {
          return LatLng(p[0], p[1]);
        })
        .toList()
        .cast<LatLng>();
    _mapController.addLine(
      LineOptions(
          geometry: t,
          lineColor: "#ff0000",
          lineWidth: 4.0,
          lineOpacity: 0.5,
          draggable: true),
    );
  }

  void _onSymbolTapped(Symbol symbol) {
    //print(symbol.data);
    //setState(() {
    _selectedSymbol = symbol;
    //});
    _mapController.animateCamera(CameraUpdate.newLatLng(symbol.data['latLon']));
    if (widget.onSelectStop != null) {
      widget.onSelectStop(symbol.data);
    }
  }
}

/** 
 * 
 * 
 *  SymbolOptions(
            geometry: geometry,
            iconImage: 'airport-15',
            fontNames: ['DIN Offc Pro Bold', 'Arial Unicode MS Regular'],
            textField: 'Airport',
            textSize: 12.5,
            textOffset: Offset(0, 0.8),
            textAnchor: 'top',
            textColor: '#000000',
            textHaloBlur: 1,
            textHaloColor: '#ffffff',
            textHaloWidth: 0.8,
 * 
 * 
*/


/** 
 * 


  Future<void> addImageFromAsset() async {
    final ByteData bytes = await rootBundle.load("assets/marker.png");
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage("marker", list);
  }

 * 
 * 
 * 
*/