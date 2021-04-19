import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mappy/api/geo.api.dart';
import 'package:mappy/ui/comps/searchtextfield.dart';
import 'package:mappy/ui/comps/ticketContext.dart';
import 'package:mappy/ui/comps/ui-collection.dart';
import 'package:mappy/ui/screens/tickets/prodcat.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../appScreen.dart';

class TicketHomeScreen extends StatefulWidget {
  TicketHomeScreen({Key key}) : super(key: key);

  @override
  _TicketHomeScreenState createState() => _TicketHomeScreenState();
}

class _TicketHomeScreenState extends State<TicketHomeScreen> {
  var _page = 0;
  final purchasePage = GlobalKey();
  final ticketsPage = GlobalKey();

  ProdCat prodCat = ProdCat();
  ProdCatState prodState = ProdCatState();

  var _list;

  @override
  void initState() {
    load();
  }

  load() async {
    await prodCat.init();
    setState(() {
      prodState = prodCat.getCurrentProjection(prodState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return UseTicketCtx((context, ticketCtx, child) {
      return AppScreen(
          child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CupertinoSlidingSegmentedControl(
                groupValue: _page,
                backgroundColor: Colors.blue.shade200,
                children: const <int, Widget>{
                  0: Text('Purchase Tickets'),
                  1: Text('My Tickets')
                },
                onValueChanged: (value) {
                  setState(() {
                    _page = value;
                  });
                }),
            SizedBox(height: 16),
            AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final inAnimation = Tween<Offset>(
                          begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                      .animate(animation);
                  final outAnimation = Tween<Offset>(
                          begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                      .animate(animation);

                  if (_page == 0) {
                    return ClipRect(
                      child:
                          SlideTransition(position: outAnimation, child: child),
                    );
                  } else if (_page == 1) {
                    return ClipRect(
                      child:
                          SlideTransition(position: inAnimation, child: child),
                    );
                  } else {
                    return child;
                  }
                },
                child: (_page == 0)
                    ? getPurchase(context, ticketCtx)
                    : getYourTickets(context, ticketCtx))
          ],
        ),
      ));
    });
  }

  getPurchase(BuildContext context, TicketCtx ticketCtx) {
    if (prodState.selections.length == 0) {
      return Container();
    }
    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: ListView(
            children: ListTile.divideTiles(
                    context: context,
                    tiles: prodState.selections
                        .map((p) => ListTile(
                            title: Text(p.title),
                            subtitle: Text(p.shortDescription),
                            onTap: () => {
                                  if (p.choices == null)
                                    {_showSearchSheet(context, p)}
                                  else
                                    {_showSelectSheet(context, p)}
                                }))
                        .toList())
                .toList()
                  ..add(TicketOffer(prodState.getCurrentProduct()))));
  }

  Future _showSelectSheet(BuildContext context, ProdCatLevel p) {
    return showMaterialModalBottomSheet(
      context: context,
      bounce: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            children: p.choices
                .map((c) => ListTile(
                    title: Text(c,
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    subtitle: Text(""),
                    onTap: () {
                      setState(() {
                        prodState = prodCat.changeState(
                            prodState, p.level, p.choices.indexOf(c));
                      });
                      Navigator.of(context).pop();
                    }))
                .toList(),
          ),
        ),
      ),
    );
  }

  Future _showSearchSheet(BuildContext context, ProdCatLevel p) {
    return showMaterialModalBottomSheet(
      context: context,
      bounce: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: SearchFragment(
                searchAfterChars: 0,
                onSearch: (data) async {
                  return await GeoApiRepository.instance
                      .searchByName(data, false);
                },
                onSelect: (index, value) {
                  setState(() {
                    prodState = prodCat.changeState(
                        prodState, p.level, int.parse(value.id));
                  });
                })),
      ),
    );
  }

  getYourTickets(BuildContext context, TicketCtx ticketCtx) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: ListView.builder(
          itemCount: ticketCtx.getTickets().length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${ticketCtx.getTickets()[index]}'),
              subtitle: Text('1.3.2021, ab Gelsenkirchen Hbf.,'),
              trailing: Hero(
                  tag: 'barcode',
                  child: Image(
                      image: AssetImage('assets/barcode.png'), width: 22)),
              onTap: () {
                Navigator.of(context).pushNamed('/ticket/detail');
              },
            );
          },
        ));
  }
}

class DebugTicketOffer extends StatelessWidget {
  final product;
  const DebugTicketOffer({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(title: Text(JsonEncoder().convert(product))));
  }
}

class TicketOffer extends StatelessWidget {
  final product;

  const TicketOffer(this.product, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(product['name'], style: Theme.of(context).textTheme.headline5),
        Text("", style: Theme.of(context).textTheme.headline5),
        StyledButton(
          "Purchase now " +
              (product['price'][0]).toStringAsFixed(2).replaceAll('.', ',') +
              " €",
          onPressed: () {
            TicketCtx.of(context).mockAdd(product['name']);
          },
        ),
        Text("", style: Theme.of(context).textTheme.headline5),
        Text(product['description'])
      ],
    ));
  }
}

/***
 * 
 * 
 * [
    {'ET/ER', 'Einzelticket', 'Erwachsener','PS1'}
    {'ET/KI', 'Einzelticket', 'Kind','PS1'}
    {'ET/KI', 'Einzelticket', 'Kind','PS1'}
    {'24/1/PS1', '24 St 1P', 'PS1'}
    {'24/5/PS1', '24 St 5P', 'PS1'}
    {'VRS/Netz', '24 St 5P', 'PS1'}
]


Group by key 1 and get first as selcted
Filter on group 1 and group by key 2 and
Filter on group 1,2 and group by key 3 and


Haltestellen, Haltestellen gruppen
Listen  (mit und ohne filter)
Relationen

  var newMap = groupBy(data, (obj) => obj['release_date']);
  print(newMap);


  prodcat.getProjection(state),
  prodcat.changeState(state, level, new),
  prodcat.getChoices(state, level)
  prodcat.getCurrentProduct(state)

 * 
 * 
 */