import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:mappy/utils/appconfig.dart';

class AppScreen extends StatefulWidget {
  final Widget child;
  final String title;

  final ScrollController scrollController = ScrollController();

  AppScreen({Key key, Widget this.child, String this.title}) : super(key: key);

  @override
  AppScreenState createState() => AppScreenState();

  static AppScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<AppScreenState>();
}

class AppScreenState extends State<AppScreen> {
  bool reversed = false;

  void stickyFocus(bool onOff) {
    reversed = onOff;
  }

  @override
  Widget build(BuildContext context) {
    Widget left = Navigator.of(context).canPop()
        ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        : Container();

    return Scaffold(
        appBar: AppBar(leading: left),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.headline1),
              SizedBox(height: 16.0),
              Expanded(
                child: KeyboardAvoider(
                  child: widget.child,
                  focusPadding: 20,
                  autoScroll: true,
                ),
              )
            ],
          ),
        ));
  }
}

/**
 * 
 * 
 * 
 * 
 */
