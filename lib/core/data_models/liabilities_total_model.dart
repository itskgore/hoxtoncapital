import 'package:wedge/core/entities/liabilities_total_summary_entity.dart';

class LiabilitiesTotalModel extends LiabilitiesTotalEntity {
  LiabilitiesTotalModel(
      {required this.currency,
      required this.amount,
      required this.count,
      required this.countryCount,
      required this.disconnectedAccountCount})
      : super(
            currency: currency,
            amount: amount,
            count: count,
            disconnectedAccountCount: disconnectedAccountCount,
            countryCount: countryCount);
  late final String currency;
  late double amount; //late
  late final int count;
  late final num countryCount;
  late final int disconnectedAccountCount;

  factory LiabilitiesTotalModel.fromJson(Map<String, dynamic> json) {
    return LiabilitiesTotalModel(
      currency: json['currency'],
      countryCount: json['countryCount'] ?? 0,
      amount: json['amount'] != null
          ? double.parse(json['amount'].toString())
          : 0.0,
      count: json['count'] ?? 0,
      disconnectedAccountCount: json['disconnectedAccountCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['currency'] = currency;
    _data['countryCount'] = countryCount;
    _data['amount'] = amount;
    _data['count'] = count;
    _data['disconnectedAccountCount'] = disconnectedAccountCount;
    return _data;
  }
}
