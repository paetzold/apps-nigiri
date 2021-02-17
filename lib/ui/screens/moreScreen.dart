import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'More',
      child: CustomScrollView(slivers: <Widget>[
        SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildBuilderDelegate(
            // The builder function returns a ListTile with a title that
            // displays the index of the current item.
            (context, index) => UseAppConfig((context, appConfig, child) {
              return InkWell(
                  onTap: () => launch(appConfig.links[index]),
                  child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(appConfig.links[index])));
            }),
            // Builds 1000 ListTiles
            childCount: Provider.of<AppConfig>(context).links.length,
          ),
        ),
      ]),
    );
  }
}
