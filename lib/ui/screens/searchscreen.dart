import 'package:flutter/material.dart';
import 'package:mappy/api/geo.api.dart';
import 'package:mappy/api/models/location.dart';
import 'package:mappy/ui/comps/searchtextfield.dart';
import 'package:mappy/ui/comps/transitcontext.dart';

import 'appScreen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _searchTxt = "";

  var _isLoading = false;
  var _list = List<Location>();

  @override
  Widget build(BuildContext context) {
    return UseTransitContext((context, transitContext, child) {
      return AppScreen(
        title: 'Search',
        child: SingleChildScrollView(
          child: Column(children: [
            SearchTextField(
                searchAfterChars: 3,
                onSearch: (data) async {
                  setState(() {
                    _isLoading = true;
                  });
                  var results =
                      await GeoApiRepository.instance.searchByName(data);
                  setState(() {
                    _searchTxt = data;
                    _isLoading = false;
                    _list = []..addAll(results.locations);
                  });
                }),
            _list == null
                ? Center(
                    child:
                        _isLoading ? CircularProgressIndicator() : Container(),
                  )
                : SizedBox(
                    height: 800,
                    child: ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: 0),
                            leading: Icon(Icons.insert_emoticon),
                            title: new Text(_list[index].name),
                            onTap: () {
                              transitContext.to(_list[index]);
                              transitContext.search();
                              Navigator.of(context).pop();
                            },
                          );
                        }),
                  )
          ]),
        ),
      );
    });
  }
}

/*

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultItem {
  final String title;
  final String thumbnailUrl;

  ResultItem._({this.title, this.thumbnailUrl});

  factory ResultItem.fromJson(var field, Map<String, dynamic> json) {
    return ResultItem._(
      title: json[field],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}

class SearchListController {
  SearchList searchList;

  void search(search) {
    searchList.m._fetchData(search);
  }
}

class SearchList extends StatefulWidget {


  SearchListController controller = SearchListController();
  var url, field;

  SearchList({SearchListController controller, String url, String field}) {
    controller.searchList = this;
    this.url = url;
    this.field = field;
  }

  final _MainFetchDataState m = _MainFetchDataState();

  @override
  _MainFetchDataState createState() {
    return m;
  }
}

class _MainFetchDataState extends State<SearchList> {
  List<ResultItem> list = List();
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  _fetchData(var search) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(widget.url.replaceAll("(search)", search));
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new ResultItem.fromJson(widget.field, data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      //throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () => {Navigator.of(context).pop()},
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                title: new Text(list[index].title),
              );
            });
  }
}

*/
