import 'package:flutter/material.dart';
import 'package:mappy/ui/comps/ui-collection.dart';
import 'package:mappy/ui/comps/usercontext.dart';

import '../appScreen.dart';
import 'accountEditScreen.dart';

class AccountDashBoard extends StatefulWidget {
  AccountDashBoard({Key key}) : super(key: key);

  @override
  _AccountDashBoardState createState() => _AccountDashBoardState();
}

class _AccountDashBoardState extends State<AccountDashBoard> {
  final _formKey = GlobalKey<FormState>();

  var _user = User();

  @override
  Widget build(BuildContext context) {
    return AppScreen(
        title: 'Hello ${UserContext.of(context).getIdentifier()}',
        child: UseUserContext((context, userContext, child) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(children: <Widget>[
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Container(
                              height: 200,
                              width: 60,
                              color: Colors.greenAccent)),
                      Expanded(
                          child: Container(
                              height: 200, width: 60, color: Colors.grey))
                    ]),
                ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://i.stack.imgur.com/YN0m7.png'),
                    ),
                    title: Text('Your Personal Data'),
                    subtitle: Text('Bla bla blabla'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.of(context).pushNamed('/account/edit');
                    }),
                ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://i.stack.imgur.com/YN0m7.png'),
                    ),
                    title: Text('Your Payment Instruments'),
                    subtitle: Text('Bla bla blabla'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.of(context).pushNamed('/account/edit');
                    }),
                ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://i.stack.imgur.com/YN0m7.png'),
                    ),
                    title: Text('Change Your Password'),
                    subtitle: Text('Bla bla blabla'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.of(context).pushNamed('/account/changePasswd');
                    }),
                ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://i.stack.imgur.com/YN0m7.png'),
                    ),
                    title: Text('Notification Settings'),
                    subtitle: Text('Bla bla blabla'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.of(context).pushNamed('/account/notifications');
                    }),
                SizedBox(height: 16.0),
                StyledButton('Logout', color: Colors.black, onPressed: () {
                  showAppDialog(context, "Do you really want logout ?",
                      () => {userContext.logout()});
                })
              ]),
            )));
  }
}
