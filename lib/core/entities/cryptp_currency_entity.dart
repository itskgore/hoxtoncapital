import 'package:wedge/core/entities/value_entity.dart';

class CryptoCurrenciesEntity {
  final String id;
  final String name;
  final String symbol;
  final num quantity;
  final ValueEntity value;
  final String createdAt;
  final String updatedAt;

  CryptoCurrenciesEntity(
      {required this.id,
      required this.name,
      required this.symbol,
      required this.quantity,
      required this.value,
      required this.createdAt,
      required this.updatedAt});
}
