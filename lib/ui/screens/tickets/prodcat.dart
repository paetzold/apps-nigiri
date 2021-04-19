import 'dart:convert';
import 'package:flutter/services.dart';

class ProdCatLevel {
  String title;
  String shortDescription;
  int level;
  List<String> choices;
  ProdCatLevel(this.title, this.shortDescription, this.level, this.choices);
}

class ProdCatState {
  List<int> _path = List.empty(growable: true);
  List<ProdCatLevel> selections = List.empty(growable: true);

  Map _selectedProduct = new Map();

  getPathValue(int level) {
    while (_path.length <= level) {
      _path.add(0);
    }
    return _path[level];
  }

  setPathValue(int level, value) {
    cutOffPath(level);
    if (_path.length < level) {
      _path.add(value);
    } else {
      _path[level] = value;
    }
  }

  cutOffPath(int level) {
    _path = _path.sublist(0, level + 1);
    return _path;
  }

  Map getCurrentProduct() {
    return _selectedProduct;
  }
}

class ProdCat {
  List<dynamic> _products;

  void init() async {
    const String _PC_NAME = 'assets/pc.json';
    var data = await rootBundle.loadString(_PC_NAME);
    var p = jsonDecode(data) as Map<String, dynamic>;
    _products = p["products"];
  }

  List<String> getChoices(ProdCatState state, int level) {
    return state.selections[level].choices;
  }

  ProdCatState changeState(ProdCatState state, int level, var selection) {
    state.cutOffPath(level);
    state.setPathValue(level, selection);
    return getCurrentProjection(state);
  }

  /**
   *  takes the path and initilazes selections and variants
   *  
   */
  ProdCatState getCurrentProjection(ProdCatState state) {
    state.selections = List.empty(growable: true);

    var level = 0;
    var s = _products;
    do {
      var v = s[state.getPathValue(level)];
      // Correct some obstracles in the data - better correct them in data
      String name = v["name"]
          .replaceAll("EinzelTicket ", "")
          .replaceAll("24-StundenTicket ", "");

      List c = s.map((i) => i["name"].toString()).toList();
      state.selections.add(ProdCatLevel(
          name,
          (v['shortDescription'] != null) ? "${v['shortDescription']}" : "",
          level,
          c));

      var dataToAggregate = Map();
      dataToAggregate['name'] = v['name'];
      dataToAggregate['description'] = v['description'];
      dataToAggregate['shortDescription'] = v['shortDescription'];
      dataToAggregate['options'] = v['options'];
      dataToAggregate['price'] = v['price'];
      dataToAggregate['needActivation'] = v['needActivation'];
      state._selectedProduct.addAll(dataToAggregate);

      if (v["variants"] != null) {
        s = v["variants"];
      } else {
        if (v["options"]["params"] != null) {
          var params = v["options"]["params"][0];
          var type = params["type"];
          type = type
              .replaceAll("station", "Departure Stop")
              .replaceAll("originTA", "Departure Zone");
          int currentValue = state.getPathValue(level + 1);
          state.selections.add(
              ProdCatLevel(type, currentValue.toString(), level + 1, null));
        }
        s = null;
      }
      level++;
    } while (s != null);

    return state;
  }
}

/** 
const data = [
    {'ET/ER', 'Einzelticket', 'Erwachsener','PS1'}
    {'ET/KI', 'Einzelticket', 'Kind','PS1'}
    {'ET/KI', 'Einzelticket', 'Kind','PS1'}
    {'24/1/PS1', '24 St 1P', 'PS1'}
    {'24/5/PS1', '24 St 5P', 'PS1'}
    {'VRS/Netz', '24 St 5P', 'PS1'}
]
*/
