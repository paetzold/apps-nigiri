import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Link {
  final title;
  final subTitle;
  final url;
  Link(this.title, this.url, {this.subTitle});
}

class AppConfig extends ChangeNotifier {
  List<Link> get links => [
        Link("About", "https://paetzold.github.io/newmobility/#/about",
            subTitle: "Some wise words ..."),
        Link("Download", "https://paetzold.github.io/newmobility/#/download",
            subTitle: "An easy way to download the Android version."),
        Link("Impressions", "https://paetzold.github.io/newmobility/#/images",
            subTitle: "Nice images from unsplash."),
        Link("Contact Us", "mailto:kay.paetzold@gmail.com?subject=HeyHey",
            subTitle: "Mmmh this doesn't work yet."),
        Link("DVG Ticketshop",
            "https://dvg.mobilesticket.de/ticketportal/#/login",
            subTitle: "A link to old times"),
        Link("Hansecom", "http://www.hansecom.de",
            subTitle: "Lin into the new times."),
        Link("Flutter", "https://www.youtube.com/watch?v=5VbAwhBBHsg",
            subTitle: "Does flutter rock?"),
      ];
}

Function WithAppConfig = (wrapped) =>
    ChangeNotifierProvider(create: (context) => AppConfig(), child: wrapped);

Function UseAppConfig = (builder) => Consumer<AppConfig>(
      builder: builder,
    );
