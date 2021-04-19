import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mappy/api/providers/api.provider.dart';

import 'models/location.dart';

abstract class GeoApiRepository {
  static final GeoApiRepository instance = _GeoNetApiRepository._();

  Future<LocationList> searchByName(String name, bool showAll) {}
  Future<LocationList> searchWithin(LatLngBounds bounds) {}
}

// class _MaturoGeoApiRepository implements GeoApiRepository {
//   final ApiProvider _provider = ApiProvider(baseURL: 'marudor.de');

//   _MaturoGeoApiRepository._();

//   Future<LocationList> searchByName(String name, bool showAll) async {
//     //final accessToken = (await loadConfigFile())['mapbox_api_token'];
//     final result = await _provider.makeGetRequest(
//       '/api/station/v1/search/${name}',
//       queryParams: {'type': 'default'},
//     );
//     return result != null ? LocationList.fromJson(result) : LocationList();
//   }
// }

class _GeoNetApiRepository implements GeoApiRepository {
  final ApiProvider _provider =
      ApiProvider(baseURL: 'intern.kpaetzold.de', insecure: true);

  _GeoNetApiRepository._();

  Future<LocationList> searchByName(String name, bool showAll) async {
    final result = await _provider.makeGetRequest(
      '/location/byname',
      queryParams: {'q': name, 'all': showAll.toString()},
    );
    return result != null ? LocationList.fromJson(result) : LocationList();
  }

  Future<LocationList> searchWithin(LatLngBounds bounds) async {
    var bbox =
        '${bounds.southwest.latitude},${bounds.southwest.longitude},${bounds.northeast.latitude},${bounds.northeast.longitude}';
    final result = await _provider
        .makeGetRequest('/location/within', queryParams: {'bbox': bbox});
    print(bbox);
    return result != null ? LocationList.fromJson(result) : LocationList();
  }
}
