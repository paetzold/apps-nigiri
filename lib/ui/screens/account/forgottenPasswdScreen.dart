import 'package:flutter/material.dart';
import 'package:mappy/ui/comps/ui-collection.dart';

import '../appScreen.dart';

class ForgottenPasswdScreen extends StatefulWidget {
  ForgottenPasswdScreen({Key key}) : super(key: key);

  @override
  _ForgottenPasswdScreenState createState() => _ForgottenPasswdScreenState();
}

class _ForgottenPasswdScreenState extends State<ForgottenPasswdScreen> {
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
      title: 'Request Password',
      child: Builder(
          builder: (context) => Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Email',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      onSaved: (val) => setState(() => val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    StyledButton('Ok',
                        color: Colors.black,
                        onPressed: () => {
                              if (_formKey.currentState.validate())
                                {Navigator.of(context).pop()}
                            }),
                  ]))),
    );
  }
}
