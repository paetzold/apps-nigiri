import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String baseURL;
  final bool insecure;

  ApiProvider({this.baseURL, this.insecure});

  Future<Map<String, dynamic>> makeGetRequest(
    String endpoint, {
    Map<String, String> queryParams,
    Map<String, String> headers,
  }) async {
    final http.Response response = await http.get(
      _buildUri(endpoint, queryParams),
      headers: headers,
    );

    if (response.statusCode != 200) {
      return null;
    }

    return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  Future<List<dynamic>> makeGetListRequest(
    String endpoint, {
    Map<String, String> queryParams,
    Map<String, String> headers,
  }) async {
    final http.Response response = await http.get(
      _buildUri(endpoint, queryParams),
      headers: headers,
    );

    if (response.statusCode != 200) {
      return null;
    }

    return json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
  }

  Uri _buildUri(String endpoint, Map<String, String> queryParams) {
    return this.insecure
        ? Uri.http(baseURL, endpoint, queryParams)
        : Uri.https(baseURL, endpoint, queryParams);
  }
}
