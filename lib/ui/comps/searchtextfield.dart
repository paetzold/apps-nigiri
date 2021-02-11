import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  Function onSearch;

  SearchTextField({Key key, Function this.onSearch}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SearchTextFieldState();
  }
}

class SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.search,
          color: _textController.text.length > 0
              ? Colors.lightBlueAccent
              : Colors.grey,
        ),
        new SizedBox(
          width: 10.0,
        ),
        new Expanded(
          child: new Stack(
              alignment: const Alignment(1.0, 1.0),
              children: <Widget>[
                new TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    focusedBorder: UnderlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      //widget.onSearch(text);
                    });
                  },
                  onSubmitted: (text) {
                    setState(() {
                      widget.onSearch(text);
                    });
                  },
                  controller: _textController,
                ),
                _textController.text.length > 0
                    ? new IconButton(
                        icon: new Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _textController.clear();
                          });
                        })
                    : new Container(
                        height: 0.0,
                      )
              ]),
        ),
      ],
    );
  }
}
