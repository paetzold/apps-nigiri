import 'package:flutter/material.dart';
import 'package:mappy/XDTextStyles.dart';

import 'appScreen.dart';

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

  var _user = User();

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).viewInsets.bottom);
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
                    LinkText(text: ''),
                    FlatButton(
                      onPressed: () {
                        _formKey.currentState.save();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Submitting form ' + _user.toString()),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 1)));
                      },
                      color: Colors.black,
                      highlightColor: Colors.grey,
                      child: Text('Ok', style: XDTextStyles.strong),
                      padding: const EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ]))),
    );
  }
}

class PasswordFormField extends StatelessWidget {
  final String labelText;
  final void Function(String val) onSaved;

  final TextEditingController _controller = new TextEditingController();

  PasswordFormField({
    Key key,
    this.labelText = '',
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: UnderlineInputBorder(),
        suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              _controller.clear();
            }),
      ),
      onSaved: this.onSaved,
      obscureText: true,
    );
  }
}

class LinkText extends StatelessWidget {
  const LinkText({
    Key key,
    this.text,
    this.target = '',
  }) : super(key: key);

  final text, target;

  @override
  Widget build(
    BuildContext context,
  ) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed(target);
      },
      child: Text(text,
          style: (TextStyle(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ))),
    );
  }
}
