import 'package:flutter/material.dart';

import '../appScreen.dart';

class EmptyScreen extends StatefulWidget {
  EmptyScreen({Key key}) : super(key: key);

  @override
  _EmptyScreenState createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Empty',
      child: Builder(
          builder: (context) => Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: []))),
    );
  }
}
