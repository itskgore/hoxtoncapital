class ValueEntity {
  ValueEntity({
    required this.amount,
    required this.currency,
  });

  ValueEntity.fromJson(Map<String, dynamic> json) {
    if (json['amount'] is int) {
      amount = (json['amount'] as int).toDouble();
    } else {
      amount = json['amount'];
    }
    currency = json['currency'];
  }

  late final num amount;
  late final String currency;

  List<Object> get props => [amount, currency];

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['amount'] = amount;
    _data['currency'] = currency;
    return _data;
  }
}
