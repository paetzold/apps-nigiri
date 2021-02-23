import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final Function onSearch;
  final searchAfterChars;
  final backgroundColor;

  SearchTextField(
      {Key key,
      this.searchAfterChars = 2,
      this.backgroundColor = Colors.black12,
      this.onSearch})
      : super(key: key);

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
    return Container(
      decoration: new BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.all(const Radius.circular(16.0))),
      child: new Row(
        children: <Widget>[
          new Icon(
            Icons.search,
            color: _textController.text.length > 0
                ? Colors.lightBlueAccent
                : Colors.grey,
          ),
          new SizedBox(
            width: 4.0,
          ),
          new Expanded(
            child: new Stack(
                alignment: const Alignment(1.0, 1.0),
                children: <Widget>[
                  new TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      // focusedBorder: UnderlineInputBorder(),
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      if (text.length < widget.searchAfterChars) {
                        return;
                      }
                      setState(() {
                        widget.onSearch(text);
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
      ),
    );
  }
}
