import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mappy/ui/screens/home.screen.dart';

import 'package:mappy/ui/screens/ticketScreen.dart';

//import '../Home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _appTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/ticket': (context) => TicketScreen(),
      },
    );
  }

  ThemeData _appTheme() {
    const Color COLOR_PRIMARY = const Color(0xFFFFFFFF);
    const Color COLOR_SECONDARY = const Color(0xFFF4F4F8);
    const Color COLOR_ACCENT = const Color(0xFF006992);

    var t = ThemeData(
      primaryColor: COLOR_PRIMARY,
      accentColor: COLOR_ACCENT,
      scaffoldBackgroundColor: COLOR_PRIMARY,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: COLOR_PRIMARY,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.w700, color: Colors.black),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    );

    return t;
  }
}
