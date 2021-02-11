import 'package:flutter/material.dart';
import 'package:mappy/XDTextStyles.dart';

class TicketScreen extends StatefulWidget {
  TicketScreen({Key key}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            child: ListTile(
                              title: Text('Two-line ListTile',
                                  style: XDTextStyles.value),
                              subtitle: Text('Here is a second line'),
                            ),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'First name'),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'First name'),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Ok'),
                          )
                        ])))
          ]),
        ));
  }
}

// https://medium.com/flutter-community/realistic-forms-in-flutter-part-1-327929dfd6fd

/*
          Container(
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () {
              // Navigate back to the first screen by popping the current route
              // off the stack.
              Navigator.pop(context);
            },
            child: Text('Go back!'),
          ),
        ]),
      ),
      */
