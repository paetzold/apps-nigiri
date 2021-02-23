import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mappy/blocs/geocoding.bloc.dart';
import 'package:mappy/ui/app.dart';
import 'package:mappy/ui/comps/transitcontext.dart';
import 'package:mappy/utils/appconfig.dart';

void main() {
  runApp(
    BlocProvider(
      create: (BuildContext context) => GeocodingBloc(),
      child: WithAppConfig(WithTransitContext(App())),
    ),
  );
}
