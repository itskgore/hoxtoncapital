import 'package:wedge/core/entities/value_entity.dart';

class ValueModel extends ValueEntity {
  ValueModel({
    required this.amount,
    required this.currency,
  }) : super(amount: amount, currency: currency);
  late num amount;
  late String currency;

  factory ValueModel.fromJson(Map<String, dynamic> json) {
    return ValueModel(
        amount: json['amount'] != null
            ? double.parse(json['amount'].toString())
            : 0.0,
        currency: json['currency'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}
