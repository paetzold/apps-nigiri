import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mappy/ui/comps/usercontext.dart';
import 'package:mappy/ui/screens/account/NotificationScreen.dart';
import 'package:mappy/ui/screens/account/account.dart';
import 'package:mappy/ui/screens/account/changePasswdScreen.dart';
import 'package:mappy/ui/screens/account/forgottenPasswd.dart';
import 'package:mappy/ui/screens/home.screen.dart';
import 'package:mappy/ui/screens/moreScreen.dart';
import 'package:mappy/ui/screens/searchscreen.dart';
import 'package:mappy/ui/screens/tickets/ticketHome.dart';
import 'package:mappy/ui/screens/tickets/ticketScreen.dart';

import 'package:page_transition/page_transition.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print('state = $state');
    if (state == AppLifecycleState.resumed) {
      RemoteConfig remoteConfig = await RemoteConfig.instance;
      // unly debuf phase
      await remoteConfig.fetch(expiration: Duration(minutes: 1));
      remoteConfig.activateFetched();
      print(remoteConfig.getString("popup"));
      //FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      //bool updated = await remoteConfig.fetchAndActivate();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return UseUserContext((context, userContext, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _appTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/account': (context) =>
              userContext.isLoggedIn() ? AccountDashBoard() : LoginScreen(),
          '/account/edit': (context) => AccountEditScreen(),
          '/account/changePasswd': (context) => ChangePasswdScreen(),
          '/account/forgottenPasswd': (context) => ForgottenPasswdScreen(),
          '/account/notifications': (context) => NotificationScreen(),
          '/ticket': (context) => TicketHomeScreen(),
          //     '/ticket/detail': (context) => TicketScreen(),
          '/more': (context) => MoreScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/search":
              return PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  child: SearchScreen());
              break;
            case "/ticket/detail":
              return PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 400),
                  child: TicketScreen());
              break;
            default:
              return null;
          }
        },
        navigatorObservers: <NavigatorObserver>[observer],
      );
    });
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
