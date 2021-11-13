# Achieve Take-Home Test Specification

### Run App
- To run the app using coincap API KEY, ```flutter run --dart-define=API_KEY=<YOUR-API-KEY-HERE>```
- To run without coincap API KEY, ```flutter run```

### Goal

In this repository, you'll find a flutter application that allows a user to view assets eg: bitcoin, ethereum, cardano etc. and also search for a text string using the [CoinCap REST API](https://docs.coincap.io/#ee30bea9-bb6b-469d-958a-d3e35d442d7a). In it's current state, however, the app is just a rough prototype

You are to complete the missing code pieces by following the **TODOs** in the code.

### Requirements

- The `AssetsPage` should display list of assets from CoinCap

  - state data should be cleared on pull to refresh
  - more data should be loaded as user scrolls down the list

- For each CoinCap Asset, using a `ListTile` widget, display it's `name`, `priceUsd` and `marketCapUsd`.

- CoinCap API should be queried when user types into the search
  field and **search results** displayed.

- The list should revert back to **original results** when user taps the close button on in the search field.

- Complete the tests for `AssetsProvider` in the `assets_provider_test.dart` file.

### Hints

- For Serializing/Deserializing You can consider using [json_serializable](https://pub.dev/packages/json_serializable) or [built_value](https://pub.dev/packages/built_value) or any package of your choice.

- We use [get_it](https://pub.dev/packages/get_it) as our service locator in this project

- Feel free to use any package/solution that gets the work done.

- You are encouraged to refactor the existing code where necessary before adding your own, as you would do if this was a real task in real life. We strongly recommend that you write tests to help you during this process.

Please commit as frequently as possible to make the review easier.
