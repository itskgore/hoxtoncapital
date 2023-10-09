import 'package:wedge/core/entities/value_entity.dart';

class AddUpdateCreditCardsParams {
  AddUpdateCreditCardsParams(
      {this.id,
      required this.name,
      required this.country,
      required this.outstandingAmount});

  final String? id;
  final String name;
  final String country;
  final ValueEntity outstandingAmount;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['country'] = country;
    _data['outstandingAmount'] = outstandingAmount.toJson();
    return _data;
  }
}
