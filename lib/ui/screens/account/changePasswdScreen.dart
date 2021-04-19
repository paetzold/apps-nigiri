import 'package:flutter/material.dart';
import 'package:mappy/ui/comps/ui-collection.dart';

import '../appScreen.dart';

class ChangePasswdScreen extends StatefulWidget {
  ChangePasswdScreen({Key key}) : super(key: key);

  @override
  _ChangePasswdScreenState createState() => _ChangePasswdScreenState();
}

class _ChangePasswdScreenState extends State<ChangePasswdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Change Your Password',
      child: Builder(
          builder: (context) => Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PasswordFormField(
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'New Password (Repeat)',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => val),
                    ),
                    SizedBox(height: 32),
                    StyledButton('Ok',
                        color: Colors.black,
                        onPressed: () => {Navigator.of(context).pop()}),
                  ]))),
    );
  }
}
