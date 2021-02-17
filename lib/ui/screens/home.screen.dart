import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mappy/ui/screens/ticketScreen.dart';
import 'package:mappy/utils/helpers/config.helper.dart';
import 'package:mappy/utils/helpers/location.helper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../blocs/geocoding.bloc.dart';
import '../../blocs/geocoding.event.dart';
import '../../blocs/geocoding.state.dart';
import 'moreScreen.dart';

class HomeScreen extends StatelessWidget {
  final BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  final PanelController _pc = PanelController();

  static MapboxMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: loadConfigFile(),
      builder: (
        BuildContext cntx,
        AsyncSnapshot<Map<String, dynamic>> snapshot,
      ) {
        if (snapshot.hasData) {
          final String token = snapshot.data['mapbox_api_token'] as String;
          final String style = snapshot.data['mapbox_style_url'] as String;
          return Stack(
            children: [
              SlidingUpPanel(
                controller: _pc,
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                header: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                      ),
                    ],
                  ),
                ),
                panelBuilder: (ScrollController _sc) => ListView(
                  controller: _sc,
                  children: [
                    SizedBox(
                      height: 18.0,
                    ),
                    Center(
                      child: Text("This is the sliding Widget"),
                    ),
                    FlatButton(
                      onPressed: () {
                        _pc.close();
                      },
                      child: Text("Close it again "),
                    ),
                    SizedBox(
                        height: 800.0,
                        child: InAppWebView(
                            initialUrl: 'https://github.com/flutter')),
                  ],
                ),
                body: MapboxMap(
                  accessToken: token,
                  styleString: style,
                  minMaxZoomPreference: const MinMaxZoomPreference(6.0, null),
                  initialCameraPosition: CameraPosition(
                    zoom: 1.0,
                    target: LatLng(53.8, 9),
                  ),
                  onMapCreated: (MapboxMapController controller) async {
                    HomeScreen._mapController = controller;
                    final result = await acquireCurrentLocation();
                    await controller.animateCamera(
                      CameraUpdate.newLatLng(result),
                    );
                    await controller.addCircle(
                      CircleOptions(
                        circleRadius: 8.0,
                        circleColor: '#006992',
                        circleOpacity: 0.5,
                        geometry: result,
                        draggable: false,
                      ),
                    );
                  },
                  onMapClick: (Point<double> point, LatLng coordinates) {
                    BlocProvider.of<GeocodingBloc>(context).add(
                      RequestGeocodingEvent(
                        latitude: coordinates.latitude,
                        longitude: coordinates.longitude,
                      ),
                    );
                    _setupBottomModalSheet(cntx);
                  },
                  onMapLongClick:
                      (Point<double> point, LatLng coordinates) async {
                    final ByteData imageBytes =
                        await rootBundle.load('assets/place_24px.png');
                    final Uint8List bytesList = imageBytes.buffer.asUint8List();
                    await _mapController.addImage('place_icon', bytesList);
                    await _mapController.addSymbol(
                      SymbolOptions(
                        iconImage: 'place_icon',
                        iconSize: 2.5,
                        geometry: coordinates,
                      ),
                    );
                  },
                ),
                borderRadius: radius,
              ),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment(1.0, -0.9),
                child: FloatingActionButton(
                  heroTag: "btn1",
                  backgroundColor: Colors.black,
                  child: Icon(Icons.account_circle_sharp),
                  onPressed: () async {
                    //Navigator.pushNamed(context, '/ticket');
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => TicketScreen()));
                  },
                ),
              ),
              MoreWidget(),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment(1.0, -0.5),
                child: FloatingActionButton(
                  heroTag: "btn3",
                  backgroundColor: Colors.black,
                  child: Icon(Icons.place_sharp),
                  onPressed: () async {
                    final result = await acquireCurrentLocation();
                    _mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(result, 16.0));
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 16.0,
                ),
                Text('Error has occurred: ${snapshot.error.toString()}')
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }

  void _setupBottomModalSheet(BuildContext buildContext) {
    showModalBottomSheet(
      context: buildContext,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocBuilder<GeocodingBloc, GeocodingState>(
          builder: (BuildContext cntx, GeocodingState state) {
            if (state is LoadingGeocodingState) {
              return Container(
                height: 158.0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text('Loading results')
                    ],
                  ),
                ),
              );
            } else if (state is SuccessfulGeocodingState) {
              final latitudeString =
                  state.result.coordinates.latitude.toStringAsPrecision(5);
              final longitudeString =
                  state.result.coordinates.longitude.toStringAsPrecision(5);
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  children: [
                    ListTile(
                      title: Text('Coordinates (latitude/longitude)'),
                      subtitle: Text(
                        '$latitudeString/$longitudeString',
                      ),
                    ),
                    ListTile(
                      title: Text('Place name'),
                      subtitle: Text(state.result.placeName),
                    ),
                  ],
                ),
              );
            } else if (state is FailedGeocodingState) {
              return ListTile(
                title: Text('Error'),
                subtitle: Text(state.error),
              );
            } else {
              return ListTile(
                title: Text('Error'),
                subtitle: Text('Unknown error'),
              );
            }
          },
        );
      },
    );
  }
}

class MoreWidget extends StatefulWidget {
  const MoreWidget({
    Key key,
  }) : super(key: key);

  @override
  _MoreWidgetState createState() => _MoreWidgetState();
}

class _MoreWidgetState extends State<MoreWidget> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      margin: EdgeInsets.all(20),
      alignment: Alignment(1.0, -0.7),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        this.isOpen
            ? FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: Colors.black,
                child: Icon(Icons.more_horiz),
                onPressed: () async {
                  //Navigator.pushNamed(context, '/ticket');
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => MoreScreen()));
                },
              )
            : SizedBox(),
        SizedBox(width: 20),
        FloatingActionButton(
          heroTag: "btn6",
          backgroundColor: Colors.black,
          child: Icon(isOpen ? Icons.close_sharp : Icons.more_horiz),
          onPressed: () async {
            setState(() {
              isOpen = !isOpen;
            });
          },
        )
      ]),
    );
  }
}