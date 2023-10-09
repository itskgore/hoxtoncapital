import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/value_entity.dart';

class AddPersonalLoanParams extends Equatable {
  AddPersonalLoanParams({
    required this.provider,
    required this.country,
    this.id,
    required this.interestRate,
    required this.termRemaining,
    required this.outstandingAmount,
    required this.monthlyPayment,
  });

  final String provider;
  final String country;
  String? id;
  final double interestRate;
  final String termRemaining;
  final ValueEntity outstandingAmount;
  final ValueEntity monthlyPayment;

  @override
  List<Object> get props => [
        provider,
        id ?? "",
        country,
        interestRate,
        termRemaining,
        outstandingAmount,
        monthlyPayment
      ];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['provider'] = provider;
    data['id'] = id ?? "";
    data['country'] = country;
    data['interestRate'] = interestRate;
    data['maturityDate'] = termRemaining;
    data['outstandingAmount'] = outstandingAmount.toJson();
    data['monthlyPayment'] = monthlyPayment.toJson();
    return data;
  }
}
