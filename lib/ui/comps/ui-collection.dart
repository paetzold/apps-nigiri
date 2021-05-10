import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../XDTextStyles.dart';

class PasswordFormField extends StatefulWidget {
  final String labelText;
  final InputDecoration decoration;
  final String Function(String) validator;
  final void Function(String val) onSaved;

  PasswordFormField(
      {Key key,
      this.labelText = '',
      this.onSaved,
      this.validator,
      this.decoration})
      : super(key: key);

  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  final TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode;
  bool _obscureText = true;

  var t = ThemeData.dark().copyWith(
    primaryColor: Colors.red,
    accentColor: Colors.white,
    hintColor: Colors.pink,
  );

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      onTap: _requestFocus,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: (widget.decoration != null)
            ? widget.decoration.labelText
            : widget.labelText,
        focusedBorder: (widget.decoration != null)
            ? widget.decoration.focusedBorder
            : UnderlineInputBorder(),
        suffix: _obscureText
            ? IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                })
            : IconButton(
                icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                  //_controllerdfgdfgd.clear();
                }),
      ),
      onSaved: widget.onSaved,
      obscureText: _obscureText,
    );
  }
}

class StyledButton extends StatelessWidget {
  const StyledButton(var this.text,
      {Key key, this.color = Colors.black, this.onPressed})
      : super(key: key);

  final text;
  final Color color;
  final Function() onPressed;

  Color brighten(Color c, [int percent = 33]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: this._onPressed,
      color: color,
      highlightColor: brighten(color),
      child: Text(text, style: XDTextStyles.strong),
      padding: const EdgeInsets.all(16.0),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    );
  }

  void _onPressed() async {
    if (onPressed != null) {
      await onPressed();
    }
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

// blurry https://stackoverflow.com/questions/53844052/how-to-make-an-alertdialog-in-flutter

showAppDialog(BuildContext context, String text, [Function onOk]) {
  showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (_) => new AlertDialog(
            content: new Text(text),
            actions: <Widget>[
              StyledButton(
                "Ok",
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  if (onOk != null) {
                    onOk();
                  }
                },
              ),
              StyledButton(
                "Cancel",
                color: Colors.grey,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ));
}

class SegmentedControl extends StatefulWidget {
  @override
  _SegmentedControlState createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  int segmentedControlValue = 0;

  Widget segmentedControl() {
    return Container(
      child: CupertinoSlidingSegmentedControl(
          groupValue: segmentedControlValue,
          backgroundColor: Colors.blue.shade200,
          children: const <int, Widget>{
            0: Text('Purchase'),
            1: Text('Your Tickets')
          },
          onValueChanged: (value) {
            setState(() {
              segmentedControlValue = value;
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return segmentedControl();
  }
}
