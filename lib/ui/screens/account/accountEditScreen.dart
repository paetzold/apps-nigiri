import 'package:flutter/material.dart';
import 'package:mappy/XDTextStyles.dart';
import 'package:mappy/ui/comps/ui-collection.dart';
import 'package:url_launcher/url_launcher.dart';

import '../appScreen.dart';

class User {
  static const String PassionCooking = 'cooking';
  static const String PassionHiking = 'hiking';
  static const String PassionTraveling = 'traveling';
  String firstName = '';
  String lastName = '';
  Map passions = {
    PassionCooking: false,
    PassionHiking: false,
    PassionTraveling: false
  };
  bool newsletter = false;
  save() {
    print('saving user using a web service');
  }

  @override
  String toString() {
    return firstName + ' ' + lastName;
  }
}

class AccountEditScreen extends StatefulWidget {
  AccountEditScreen({Key key}) : super(key: key);

  @override
  _AccountEditScreenState createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  var _user = User();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("appscrreen:" + AppScreen.of(context).toString());
      print("Has focus: ${_focusNode.hasFocus}");
      //AppScreen.of(context).stickyFocus(true);
/*       AppScreen.of(context).scrollController.animateTo(
          MediaQuery.of(context).viewInsets.bottom,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linearToEaseOut); */
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Your Account',
      child: Builder(
          builder: (context) => Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => _user.firstName = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => _user.firstName = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => _user.firstName = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Street',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => _user.firstName = val),
                    ),
                    Row(children: [
                      Flexible(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ZIP',
                              focusedBorder: UnderlineInputBorder(),
                            ),
                            onSaved: (val) =>
                                setState(() => _user.firstName = val),
                          )),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'City',
                            focusedBorder: UnderlineInputBorder(),
                          ),
                          onSaved: (val) =>
                              setState(() => _user.firstName = val),
                        ),
                      ),
                    ]),
                    TextFormField(
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        labelText: 'State',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => _user.firstName = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Country',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => _user.firstName = val),
                    ),
                    SizedBox(height: 32),
                    StyledButton('Ok',
                        color: Colors.black,
                        onPressed: () => {Navigator.of(context).pop()}),
                  ]))),
    );
  }
}
