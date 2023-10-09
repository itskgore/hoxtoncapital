import 'package:wedge/core/entities/value_entity.dart';

class AddVehicleLoansParams {
  AddVehicleLoansParams({
    this.id,
    required this.outstandingAmount,
    required this.interestRate,
    required this.termRemaining,
    required this.hasLoan,
    this.vehicles,
    required this.country,
    required this.provider,
    required this.monthlyPayment,
  });

  final String? id;
  final String country;
  final ValueEntity outstandingAmount;
  final String interestRate;
  final String termRemaining;
  final ValueEntity monthlyPayment;
  final bool hasLoan;
  final String provider;
  List<Map<String, dynamic>>? vehicles;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['outstandingAmount'] = outstandingAmount.toJson();
    _data['interestRate'] = interestRate;
    _data['maturityDate'] = termRemaining;
    _data['monthlyPayment'] = monthlyPayment.toJson();
    _data['hasLoan'] = hasLoan;
    _data['country'] = country;
    _data['provider'] = provider;
    if (vehicles != null) {
      _data['vehicles'] = vehicles;
    }
    return _data;
  }
}

// {
//         "provider": "VEHICLE LOAN 1",
//         "country": "UAE",
//         "outstandingAmount": {
//             "amount": 22.00,
//             "currency": "AED"
//         },
//         "interestRate":23,
//         "termRemaining": 234,
//         "monthlyPayment": {
//             "amount": 22.00,
//             "currency": "AED"
//         },
//         "vehicles": [
//             {
//                "id":"259648c6-0a50-4a27-bc1a-da323824b74d"
//             }

//         ]
// }
