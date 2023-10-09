import 'package:wedge/core/entities/asset_total_entity.dart';

class AssetTotalModel extends AssetTotalEntity {
  AssetTotalModel({
    required this.currency,
    required this.amount,
    required this.count,
    required this.countryCount,
    required this.disconnectedAccountCount,
  }) : super(
            currency: currency,
            amount: amount,
            count: count,
            countryCount: countryCount,
            disconnectedAccountCount: disconnectedAccountCount);
  late final String currency;
  late double amount; //late
  late int count;
  late num countryCount;
  late int disconnectedAccountCount;

  factory AssetTotalModel.fromJson(Map<String, dynamic> json) {
    return AssetTotalModel(
      currency: json['currency'] ?? "",
      amount: json['amount'] != null
          ? double.parse(json['amount'].toString())
          : 0.0,
      count: json['count'] ?? 0,
      countryCount: json['countryCount'] ?? 0,
      disconnectedAccountCount: json['disconnectedAccountCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['currency'] = currency;
    _data['amount'] = amount;
    _data['count'] = count;
    _data['countryCount'] = countryCount;
    _data['disconnectedAccountCount'] = disconnectedAccountCount;
    return _data;
  }
}
