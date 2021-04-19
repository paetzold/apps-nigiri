import 'package:flutter/material.dart';
import 'package:mappy/XDTextStyles.dart';
import 'package:mappy/ui/comps/ui-collection.dart';
import 'package:mappy/ui/comps/usercontext.dart';

import '../appScreen.dart';
import 'accountEditScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _user = User();

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Log In',
      child: UseUserContext((context, userContext, child) => Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                focusedBorder: UnderlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (val) => setState(() => _user.email = val),
            ),
            PasswordFormField(
              labelText: 'Password',
              onSaved: (val) => setState(() => _user.lastName = val),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            LinkText(
                text: 'Forgot password ?', target: '/account/forgottenPasswd'),
            StyledButton('Ok', color: Colors.black, onPressed: () {
              if (!_formKey.currentState.validate()) {
                return;
              }
              _formKey.currentState.save();
              var snack = Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Submitting form ' + _user.toString()),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 1)));
              userContext.login(_user.email, "");

              Navigator.of(context).pushReplacementNamed("/account");
            })
          ]))),
    );
  }
}
