import 'package:barcode_generator/barcode_generator.dart';
import 'package:flutter/widgets.dart';
import 'package:mappy/ui/comps/ticketContext.dart';

import '../appScreen.dart';

class TicketScreen extends StatefulWidget {
  TicketScreen({Key key}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  Widget build(BuildContext context) {
    return UseTicketCtx((context, ticketCtx, child) => AppScreen(
          child: SingleChildScrollView(
            child: Hero(
              tag: 'barcode',
              child: BarcodeGenerator(
                  witdth: 200,
                  height: 400,
                  fromString:
                      "xxxxghipjwri0üpl+p qlldqwllöqewlfwelküpgüptpükrthpükhkpühkpühzmöqjbjbwaefkweü+fpokwqergfjkwtexxxx",
                  codeType: BarCodeType.kBarcodeFormatAztec),
            ),
          ),
        ));
  }
}
