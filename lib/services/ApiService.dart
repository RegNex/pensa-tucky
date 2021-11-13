import 'package:achieve_takehome_test/core/network/network_client.dart';
import 'package:achieve_takehome_test/utils/encode_map.dart';
import 'package:achieve_takehome_test/utils/network_error.dart';
import 'package:http/http.dart';

class ApiService {
  NetworkClient<Response> _netClient;
  String _baseUrl;

  ApiService._(
    this._netClient,
    this._baseUrl,
  );

  factory ApiService.create(
    NetworkClient client, {
    String baseUrl = 'https://api.coincap.io/v2/assets',
  }) {
    return ApiService._(client, baseUrl);
  }

  Future<Response> getCoinCapAssets({
    int page = 1,
    String search,
  }) async {
    final _options = {
      if (page != null) "page": page,
      if (search != null) "search": search,
    };

    final _result = await _netClient.get('$_baseUrl?${encodeMap(_options)}',
        headers: String.fromEnvironment('API_KEY') != null
            ? {
                'Accept-Encoding': 'gzip',
                'Authorization': 'Bearer ${String.fromEnvironment('API_KEY')}'
              }
            : {});

    final _requestBody = _netClient.getResponseBody(_result);

    if (!_netClient.requestIsSuccessFul(_result)) {
      throw NetworkError(_requestBody);
    }

    /// TODO: Return the results
    return _result;
  }
}
