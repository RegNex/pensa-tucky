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
      /// TODO: Fetch assets from Coinbase

      _apiService
          .getCoinCapAssets(page: offset, search: search)
          .then((response) {
        if (response.statusCode == 200) {
          CoinCapAsset _coinCapAsset = coinCapAssetFromJson(response.body);
          addEvent(AssetsProviderEvent<CoinCapAsset>(
              state: ProviderState.SUCCESS, data: _coinCapAsset));
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
