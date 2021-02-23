import 'package:mappy/api/providers/api.provider.dart';

import 'models/location.dart';

class GeoApiRepository {
  static final GeoApiRepository instance = GeoApiRepository._();
  final ApiProvider _provider = ApiProvider(baseURL: 'marudor.de');
  GeoApiRepository._();

  Future<LocationList> searchByName(
    String name,
  ) async {
    //final accessToken = (await loadConfigFile())['mapbox_api_token'];
    final result = await _provider.makeGetListRequest(
      '/api/station/v1/search/${name}',
      queryParams: {'type': 'default'},
    );
    return result != null ? LocationList.fromJson(result) : LocationList();
  }
}
