@Timeout(Duration(seconds: 120))
import 'package:achieve_takehome_test/core/network/network_client_impl.dart';
import 'package:achieve_takehome_test/providers/AssetsProvider.dart';
import 'package:achieve_takehome_test/providers/BaseProvider.dart';
import 'package:achieve_takehome_test/services/ApiService.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AssetsProvider assetProvider;

  setUp(() async {
    /// TODO: Initialize `assetProvider`; - DONE

    final NetworkClientImpl httpClient = NetworkClientImpl();
    assetProvider = AssetsProvider(apiService: ApiService.create(httpClient));
    await assetProvider.fetchAssets(offset: 0);
  });

  tearDown(() {
    assetProvider = null;
  });

  group("#Test AssetsProvider", () {
    test(':fetchAssets should work', () async {
      /// TODO: In Addition, test that events are emitted - DONE
      /// in the expected order
      /// eg:
      /// -> AssetsProviderEvent(state: ProviderState.LOADING)
      /// -> AssetsProviderEvent(state: ProviderState.SUCCESS)

      assetProvider.stream.listen((event) {
        expect(event.state,
            emitsInOrder([ProviderState.LOADING, ProviderState.SUCCESS]));
      });
    });

    test(':fetchAssets should fail', () async {
       assetProvider.stream.listen((event) {
        expect(event.state,
            emitsInOrder([ProviderState.LOADING, ProviderState.ERROR]));
      });
    });
  });
}
