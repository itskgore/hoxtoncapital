import 'package:wedge/core/entities/value_entity.dart';

class AddUpdateOtherLiabilitiesParams {
  AddUpdateOtherLiabilitiesParams(
      {this.id,
      required this.name,
      required this.country,
      required this.debtValue,
      required this.monthlyPayment});

  String? id;
  final String name;
  final String country;
  final ValueEntity debtValue;
  final ValueEntity monthlyPayment;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['country'] = country;
    _data['monthlyPayment'] = monthlyPayment.toJson();
    _data['outstandingAmount'] = debtValue.toJson();
    return _data;
  }
}
