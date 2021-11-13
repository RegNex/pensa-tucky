import 'package:achieve_takehome_test/core/data/coinbase_asset.dart';
import 'package:achieve_takehome_test/providers/BaseProvider.dart';
import 'package:achieve_takehome_test/services/ApiService.dart';
import 'package:achieve_takehome_test/utils/network_error.dart';
import 'package:meta/meta.dart';

class AssetsProviderEvent<T> {
  final ProviderState state;
  final T data;

  const AssetsProviderEvent({
    this.data,
    @required this.state,
  });
}

class AssetsProvider extends BaseProvider<AssetsProviderEvent> {
  final ApiService _apiService;

  AssetsProvider({
    @required ApiService apiService,
  }) : _apiService = apiService;

  Future<void> fetchAssets({
    bool refresh = false,
    String search,
    int limit = 30,
    int offset,
  }) async {
    addEvent(AssetsProviderEvent(state: ProviderState.LOADING));

    try {
      /// TODO: Fetch assets from Coinbase - DONE

      await _apiService
          .getCoinCapAssets(
        page: offset,
        search: search,
      )
          .then((response) {
        if (response.statusCode == 200) {
          CoinCapAsset _coinCapAsset = coinCapAssetFromJson(response.body);
          print(_coinCapAsset.data.length);

          int _limit = limit + 1;

          if (_limit <= _coinCapAsset.data.length) {
            print('here');
            addEvent(AssetsProviderEvent<List<Map<String, String>>>(
                state: ProviderState.SUCCESS,
                data: _coinCapAsset.data.getRange(0, _limit).toList()));
          } else {
            print('there');

            addEvent(AssetsProviderEvent<List<Map<String, String>>>(
                state: ProviderState.SUCCESS, data: _coinCapAsset.data));
          }
        } else {
          addEvent(AssetsProviderEvent(
              state: ProviderState.ERROR, data: response.body));
        }
      });
    } on NetworkError catch (e) {
      addEvent(AssetsProviderEvent<NetworkError>(
        state: ProviderState.ERROR,
        data: e,
      ));
    }
  }
}
