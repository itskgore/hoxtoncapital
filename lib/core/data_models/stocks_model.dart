import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/stocks_entity.dart';

class StocksBondsModel extends StocksAndBondsEntity {
  StocksBondsModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.symbol,
    required this.createdAt,
    required this.value,
  }) : super(
            id: id,
            name: name,
            createdAt: createdAt,
            quantity: quantity,
            value: value,
            symbol: symbol);
  late String id;
  late String name;
  late String createdAt;
  late String symbol;
  late num quantity;
  final ValueModel value;

  factory StocksBondsModel.fromJson(Map<String, dynamic> json) {
    return StocksBondsModel(
      id: json['id'],
      symbol: json['symbol'] ?? "",
      name: json['name'] ?? "",
      createdAt: json['createdAt'] ?? "",
      quantity:
          json['quantity'] != null ? num.parse(json['quantity'].toString()) : 0,
      value: ValueModel.fromJson(json['value'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['symbol'] = symbol;
    _data['name'] = name;
    _data['createdAt'] = createdAt;
    _data['quantity'] = quantity;
    _data['value'] = value.toJson();
    return _data;
  }
}
