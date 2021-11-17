import 'dart:async';

import 'package:achieve_takehome_test/core/data/coin.dart';
import 'package:achieve_takehome_test/providers/AssetsProvider.dart';
import 'package:achieve_takehome_test/providers/BaseProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AssetsPage extends StatefulWidget {
  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  final _searchTextEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer _searchDebounce;
  AssetsProvider _assetsProvider;
  int offset = 0;
  int totalLength = 0;

  void onSearchQueryChanged(String search) {
    if (search != null) {
      _searchDebounce?.cancel();
      setState(() {
        _searchDebounce = Timer(Duration(seconds: 1), () {
          if (search.length > 2) {
            _assetsProvider.fetchAssets(search: search, offset: 0);
          }
        });
      });
    } else {
      _assetsProvider.fetchAssets(offset: 0);
    }
  }

  void didBuild(BuildContext context) {
    _assetsProvider.fetchAssets(offset: 0);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      didBuild(context);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {
    print('at bottom');
    setState(() {
      offset = totalLength;
    });
    _assetsProvider.fetchAssets(offset: offset);
  }

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    final _isLight = _themeData.brightness == Brightness.light;
    _assetsProvider = Provider.of<AssetsProvider>(context, listen: false);

    return StreamBuilder<AssetsProviderEvent>(
      stream: _assetsProvider.stream,
      builder: (context, snapshot) {
        final _isLoading = snapshot.data?.state == ProviderState.LOADING &&
            snapshot.data?.data == null;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: ValueListenableBuilder(
                valueListenable: _searchTextEditingController,
                builder: (context, textVal, _) {
                  final String _text = textVal.text;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchTextEditingController,
                          onChanged: onSearchQueryChanged,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Searching for a asset?',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            fillColor: _isLight ? Colors.grey[200] : null,
                            prefixIcon:
                                _text.isEmpty ? Icon(Icons.search) : null,
                            suffixIcon: _text.isNotEmpty
                                ? GestureDetector(
                                    child: Icon(Icons.close),
                                    onTap: () {
                                      onSearchQueryChanged(null);
                                      _searchTextEditingController.clear();
                                    },
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),
            title: SizedBox(
              height: 50,
              width: 50,
              child: Image.asset('assets/img/coin-cap.png'),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () {
                return _assetsProvider.fetchAssets(
                    refresh: true, offset: offset);
              },
              child: Builder(
                builder: (context) {
                  /// TODO: Rework this to show fetched Assets

                  if (_isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data?.state == ProviderState.ERROR &&
                      snapshot.data?.data != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 40,
                          ),
                          Text(
                            '${snapshot.data.data.message}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  if (!_isLoading &&
                      snapshot.data?.state == ProviderState.SUCCESS &&
                      snapshot.data?.data != null) {
                    totalLength = totalLength + snapshot.data.data.length;
                    return ListView.separated(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          Coin coin = snapshot.data.data[index];
                          return ListTile(
                            leading: Text('${coin.rank}'),
                            title: Text('${coin.name}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Market Cap.:'),
                                Text('${coin.marketCapUsd ?? 'Not available'}'),
                              ],
                            ),
                            trailing: Text(
                                '${NumberFormat.currency(name: 'US\$', decimalDigits: 2).format(double.parse(coin.priceUsd ?? '0'))}'),
                          );
                        },
                        separatorBuilder: (__, _) => Divider(),
                        itemCount: snapshot.data == null
                            ? 0
                            : snapshot.data.data.length);
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.red,
                          size: 40,
                        ),
                        Text(
                          'There\'s no data available at the moment',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    _searchDebounce?.cancel();
    _assetsProvider?.dispose();
    super.dispose();
  }
}
