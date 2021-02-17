import 'package:flutter/material.dart';
import 'package:mappy/utils/appconfig.dart';

class AppScreen extends StatelessWidget {
  final Widget child;
  final String title;

  const AppScreen({Key key, Widget this.child, String this.title})
      : super(key: key);

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
              Text(this.title, style: Theme.of(context).textTheme.headline1),
              SizedBox(height: 16.0),
              UseAppConfig((context, appConfig, child) {
                return Expanded(child: this.child);
              })
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
