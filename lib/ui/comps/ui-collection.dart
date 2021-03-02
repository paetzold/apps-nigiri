import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../XDTextStyles.dart';

class StyledButton extends StatelessWidget {
  const StyledButton(var this.text, {Key key, this.color, this.onPressed})
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
      onPressed: onPressed != null ? onPressed : () => {},
      color: color,
      highlightColor: brighten(color),
      child: Text(text, style: XDTextStyles.strong),
      padding: const EdgeInsets.all(16.0),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
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
