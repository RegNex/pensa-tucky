/// TODO: Complete the [CoinCapAsset] class - DONE
/// and also implement methods for converting to and from JSON.
///
/// You are free to use any helper package

import 'coin.dart';


class CoinCapAsset {
  List<Coin> data;
  int timestamp;

  CoinCapAsset({this.data, this.timestamp});

  CoinCapAsset.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Coin>[];
      json['data'].forEach((v) {
        data.add(new Coin.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }

  
}
