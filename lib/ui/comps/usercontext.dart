import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserContext extends ChangeNotifier {
  static UserContext of(BuildContext context) =>
      Provider.of<UserContext>(context);

  var _username, _accessToken;

  UserContext() {
    _init();
  }

  _init() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    _accessToken = prefs.getString('accessToken') ?? null;
  }

  _persist() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _username);
    prefs.setString('accessToken', _accessToken);
  }

  bool login(username, password) {
    _username = username;
    _accessToken = password;
    _persist();
    notifyListeners();
    return true;
  }

  void logout() {
    _accessToken = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return _accessToken != null;
  }

  String getIdentifier() {
    return _username;
  }

  //getUser()

  //update

  //refresh

  // change password

  // forgotten

}

Function WithUserContext = (wrapped) =>
    ChangeNotifierProvider(create: (context) => UserContext(), child: wrapped);

Function UseUserContext = (builder) => Consumer<UserContext>(
      builder: builder,
    );
