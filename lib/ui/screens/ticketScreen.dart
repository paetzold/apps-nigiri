import 'package:flutter/material.dart';
import 'package:mappy/XDTextStyles.dart';
import 'package:mappy/ui/comps/searchtextfield.dart';

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

class TicketScreen extends StatefulWidget {
  TicketScreen({Key key}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _formKey = GlobalKey<FormState>();

  var _user = User();

  var _searchTxt = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
              builder: (context) => Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Log In",
                            style: Theme.of(context).textTheme.headline1),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            focusedBorder: UnderlineInputBorder(),
                          ),
                          onSaved: (val) =>
                              setState(() => _user.firstName = val),
                        ),
                        PasswordFormField(
                          labelText: 'Password',
                          onSaved: (val) =>
                              setState(() => _user.lastName = val),
                        ),
                        LinkText(text: 'Forgot password ?'),
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
        ));
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

//https://medium.com/flutter-community/i18n-extension-flutter-b966f4c65df9

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
