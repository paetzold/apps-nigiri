import 'package:flutter/material.dart';
import 'package:mappy/utils/appconfig.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'appScreen.dart';

class MoreScreen extends StatefulWidget {
  MoreScreen({Key key}) : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  var _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'More',
      child: CustomScrollView(controller: _scrollController, slivers: <Widget>[
        SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildBuilderDelegate(
            // The builder function returns a ListTile with a title that
            // displays the index of the current item.
            (context, index) => UseAppConfig((context, appConfig, child) {
              return InkWell(
                  onTap: () =>
                      launch(appConfig.links[index].url, forceWebView: true),
                  child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(appConfig.links[index].title),
                      subtitle: appConfig.links[index].subTitle != null
                          ? Text(appConfig.links[index].subTitle)
                          : Text(appConfig.links[index].url)));
            }),
            // Builds 1000 ListTiles
            childCount: Provider.of<AppConfig>(context).links.length,
          ),
        ),
      ]),
    );
  }
}
