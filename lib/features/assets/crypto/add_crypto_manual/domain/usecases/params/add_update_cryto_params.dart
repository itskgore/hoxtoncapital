import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/value_entity.dart';

class AddUpdateCryptoParams extends Equatable {
  AddUpdateCryptoParams(
      {required this.name,
      required this.quantity,
      required this.symbol,
      required this.value,
      this.id});

  final String name;
  final String symbol;
  String? id;
  final double quantity;
  final ValueEntity value;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "symbol": symbol,
      "id": id ?? "",
      "quantity": quantity,
      "value": {"amount": value.amount, "currency": value.currency}
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, quantity, value, symbol];
}
