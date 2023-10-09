import 'package:wedge/core/entities/value_entity.dart';

class StocksAndBondsEntity {
  StocksAndBondsEntity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.symbol,
    required this.value,
    this.createdAt,
  });

  late final String id;
  late final String name;
  late final String symbol;
  final String? createdAt;
  late final num quantity;
  late final ValueEntity value;
}
