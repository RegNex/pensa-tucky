/// TODO: Complete the [CoinCapAsset] class - DONE
/// and also implement methods for converting to and from JSON.
///
/// You are free to use any helper package
// To parse this JSON data, do
//
//     final coinCapAsset = coinCapAssetFromJson(jsonString);

import 'dart:convert';


CoinCapAsset coinCapAssetFromJson(String str) => CoinCapAsset.fromJson(json.decode(str));

String coinCapAssetToJson(CoinCapAsset data) => json.encode(data.toJson());

class CoinCapAsset {
    CoinCapAsset({
        this.data,
        this.timestamp,
    });

    List<Map<String, String>> data;
    int timestamp;

    factory CoinCapAsset.fromJson(Map<String, dynamic> json) => CoinCapAsset(
        data: List<Map<String, String>>.from(json["data"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v == null ? null : v)))),
        timestamp: json["timestamp"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v == null ? null : v)))),
        "timestamp": timestamp,
    };
}