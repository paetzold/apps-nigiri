import 'package:flutter/material.dart';
import 'package:mappy/XDTextStyles.dart';
import 'package:mappy/ui/comps/ui-collection.dart';

import '../appScreen.dart';
import 'accountEditScreen.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _formKey = GlobalKey<FormState>();

  var _user = User();

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Hello James Dustin',
      child: Builder(
          builder: (context) => Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinkText(text: 'Forgot password ?'),
                    StyledButton('Ok', color: Colors.black, onPressed: () {
                      _formKey.currentState.save();
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Submitting form ' + _user.toString()),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 1)));
                      Navigator.of(context).pushNamed("/account/edit");
                    })
                  ]))),
    );
  }
}
