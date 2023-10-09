import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/cryptp_currency_entity.dart';

class CryptoCurrenciesModel extends CryptoCurrenciesEntity {
  final String id;
  final String name;
  final num quantity;
  final ValueModel value;
  final String createdAt;
  final String updatedAt;
  final String symbol;

  CryptoCurrenciesModel(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.symbol,
      required this.value,
      required this.createdAt,
      required this.updatedAt})
      : super(
            createdAt: createdAt,
            id: id,
            name: name,
            quantity: quantity,
            symbol: symbol,
            updatedAt: updatedAt,
            value: value);

  factory CryptoCurrenciesModel.fromJson(Map<String, dynamic> json) {
    return CryptoCurrenciesModel(
        createdAt: json['createdAt'] ?? "",
        symbol: json['symbol'] ?? "",
        id: json['id'],
        name: json['name'] ?? "",
        quantity: json['quantity'] ?? "",
        updatedAt: json['updatedAt'] ?? "",
        value: ValueModel.fromJson(json['value']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['symbol'] = symbol;
    data['name'] = name;
    data['quantity'] = quantity;
    if (value != null) {
      data['value'] = value.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
