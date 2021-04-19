import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mappy/blocs/geocoding.bloc.dart';
import 'package:mappy/ui/app.dart';
import 'package:mappy/ui/comps/ticketContext.dart';
import 'package:mappy/ui/comps/transitcontext.dart';
import 'package:mappy/ui/comps/usercontext.dart';
import 'package:mappy/utils/appconfig.dart';
import 'package:page_transition/page_transition.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 1,
        navigateAfterSeconds: new AfterSplash(),
        pageRoute: PageTransition(
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: AfterSplash(),
            type: PageTransitionType.fade),
        title: new Text(
          'Welcome to new.M',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image(
          image: CachedNetworkImageProvider(
            'https://images.unsplash.com/photo-1605797654030-3a167bdf0c67?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80',
          ),
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.red);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GeocodingBloc(),
      child: WithAppConfig(
          WithUserContext(WithTransitContext(WithTicketCtx(App())))),
    );
  }
}
