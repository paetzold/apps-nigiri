import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mappy/ui/comps/transitcontext.dart';
import 'package:mappy/ui/comps/transitmap.dart';

import 'package:mappy/utils/helpers/config.helper.dart';
import 'package:mappy/utils/helpers/location.helper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:flutter_icons/flutter_icons.dart';

import '../../blocs/geocoding.bloc.dart';
import '../../blocs/geocoding.state.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<TransitMapState> _mapKey = GlobalKey();

  final PanelController _pc = PanelController();

  var _selectedStop;

  final BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            UseTransitContext((context, transitContext, child) => FutureBuilder(
                  future: loadConfigFile(),
                  builder: (
                    BuildContext cntx,
                    AsyncSnapshot<Map<String, dynamic>> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      final String token =
                          snapshot.data['mapbox_api_token'] as String;
                      final String style =
                          snapshot.data['mapbox_style_url'] as String;

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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0))),
                                  ),
                                ],
                              ),
                            ),
                            panelBuilder: (ScrollController _sc) => ListView(
                              controller: _sc,
                              children: [
                                SizedBox(
                                  height: 4.0,
                                ),
                                Center(
                                    child: Text(
                                        (_selectedStop != null)
                                            ? _selectedStop['name'] +
                                                " (" +
                                                _selectedStop['id'] +
                                                ")"
                                            : "Please Select a Stop",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline5)),
                                FlatButton(
                                  onPressed: () {
                                    _pc.close();
                                  },
                                  child: Text("Close it again "),
                                ),
                                SizedBox(
                                  height: 800.0,
                                  child: InAppWebView(
                                      initialData: InAppWebViewInitialData(
                                          // initialUrl: 'https://github.com/flutter'
                                          )),
                                )
                              ],
                            ),
                            body: TransitMap(
                                key: _mapKey,
                                api_key: token,
                                style: style,
                                onSelectStop: (s) {
                                  /**_selectedStop = s */

                                  setState(() {
                                    _selectedStop = s;
                                  });
                                  _pc.open();
                                  print(s);
                                },
                                route: transitContext.polyline,
                                bounds: transitContext.bounds),
                            borderRadius: radius,
                          ),
                          MoreWidget(alignment: Alignment(1.0, -0.9)),
                          Container(
                            margin: EdgeInsets.all(20),
                            alignment: Alignment(1.0, -0.7),
                            child: FloatingActionButton(
                              heroTag: "btn4",
                              backgroundColor: Colors.black,
                              child: Icon(Icons.directions),
                              onPressed: () async {
                                Navigator.of(context).pushNamed('/search');
                              },
                            ),
                          ),
                          OnMapButton(
                              alignment: Alignment(1.0, -0.5),
                              onPressed: () async {
                                final result = await acquireCurrentLocation();
                                _mapKey.currentState.animateTo(result, 16.0);
                              }),
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
                            Text(
                                'Error has occurred: ${snapshot.error.toString()}')
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )));
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

class OnMapButton extends StatefulWidget {
  const OnMapButton({
    Key key,
    this.alignment,
    @required Future<Null> Function() onPressed,
  })  : _onPressed = onPressed,
        super(key: key);

  final Alignment alignment;

  final Future<Null> Function() _onPressed;

  @override
  _OnMapButtonState createState() => _OnMapButtonState();
}

class _OnMapButtonState extends State<OnMapButton> {
  var processing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      alignment: widget.alignment,
      child: FloatingActionButton(
        heroTag: "btn5",
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: processing
            ? CircularProgressIndicator(backgroundColor: Colors.white)
            : Icon(Icons.location_searching_rounded),
        onPressed: () async {
          setState(() {
            processing = true;
          });
          await widget._onPressed();
          await Future.delayed(Duration(milliseconds: 300));
          setState(() {
            processing = false;
          });
        },
      ),
    );
  }
}

class MoreWidget extends StatefulWidget {
  final Alignment alignment;

  _MoreWidgetState _state;

  MoreWidget({
    Key key,
    Alignment this.alignment,
  }) : super(key: key);

  @override
  _MoreWidgetState createState() {
    _state = _MoreWidgetState();
    return _state;
  }
}

class _MoreWidgetState extends State<MoreWidget> {
  bool isOpen = false;

  var padding = 0.0;
  var opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      alignment: this.widget.alignment,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          width: padding,
          child: FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: Colors.black,
            child: Icon(Icons.more_vert),
            onPressed: () {
              setState(() {
                isOpen = false;
                padding = 0.0;
              });
              Navigator.of(context).pushNamed('/more');
            },
          ),
        ),
        SizedBox(width: padding / 3),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          width: padding,
          child: FloatingActionButton(
            heroTag: "btn0",
            backgroundColor: Colors.black,
            child: Icon(Foundation.ticket),
            onPressed: () {
              setState(() {
                isOpen = false;
                padding = 0.0;
              });
              Navigator.of(context).pushNamed('/ticket');
            },
          ),
        ),
        SizedBox(width: padding / 3),
        AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: padding,
            child: FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: Colors.black,
              child: Icon(Icons.account_circle_sharp),
              onPressed: () async {
                setState(() {
                  isOpen = false;
                  padding = 0.0;
                });
                Navigator.of(context).pushNamed('/account');
              },
            )),
        SizedBox(width: padding / 3),
        FloatingActionButton(
          heroTag: "btn3",
          backgroundColor: Colors.black,
          child: Icon(isOpen ? Icons.close_sharp : Icons.more_horiz),
          onPressed: () async {
            setState(() {
              isOpen = !isOpen;
              padding = isOpen ? 60 : 0.0;
            });
          },
        )
      ]),
    );
  }
}
