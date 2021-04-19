import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketCtx extends ChangeNotifier {
  static TicketCtx of(BuildContext context) =>
      Provider.of<TicketCtx>(context, listen: false);

  List<dynamic> _tickets;

  TicketCtx() {
    _init();
  }

  _init() async {
    final prefs = await SharedPreferences.getInstance();
    var s = prefs.getString("tickets");
    if (s != null) {
      _tickets = jsonDecode(s);
    } else {
      _tickets = jsonDecode("[]");
    }
  }

  _persist() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tickets', jsonEncode(_tickets));
  }

  List<dynamic> getTickets() {
    return _tickets;
  }

  void mockAdd(var toAdd) {
    _tickets.add(toAdd);
    _persist();
  }
}

Function WithTicketCtx = (wrapped) =>
    ChangeNotifierProvider(create: (ctx) => TicketCtx(), child: wrapped);

Function UseTicketCtx = (builder) => Consumer<TicketCtx>(
      builder: builder,
    );
