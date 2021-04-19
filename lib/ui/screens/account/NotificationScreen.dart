import 'package:flutter/material.dart';

import '../appScreen.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class NoticationItem {
  NoticationItem(this.title, this.value, this.icon);
  String title;
  bool value;
  Icon icon;
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _formKey = GlobalKey<FormState>();

  List<NoticationItem> _notifications;

  _NotificationScreenState() {
    _notifications = [];
    _notifications.add(NoticationItem('Anything related to Your Account', true,
        Icon(Icons.supervisor_account)));
    _notifications
        .add(NoticationItem('Traffic Information', true, Icon(Icons.traffic)));
    _notifications.add(NoticationItem(
        'Marketing Related News', true, Icon(Icons.star_purple500_sharp)));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
        title: 'Notification Settings',
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(height: 32),
          Container(
            height: 800,
            child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return SwitchListTile(
                    title: Text(_notifications[index].title),
                    value: _notifications[index].value,
                    onChanged: (bool value) {
                      setState(() {
                        _notifications[index].value = value;
                      });
                    },
                    secondary: _notifications[index].icon,
                  );
                }),
          )
        ]));
  }
}
