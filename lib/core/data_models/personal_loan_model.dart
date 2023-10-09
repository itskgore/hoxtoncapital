import 'package:wedge/core/data_models/aggregator_model.dart';
import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';

class PersonalLoanModel extends PersonalLoanEntity {
  PersonalLoanModel({
    required this.id,
    required this.provider,
    required this.providerName,
    required this.country,
    required this.outstandingAmount,
    required this.interestRate,
    required this.termRemaining,
    required this.monthlyPayment,
    required this.createdAt,
    required this.updatedAt,
    required this.aggregator,
    required this.maturityDate,
    required this.source,
  }) : super(
            country: country,
            aggregator: aggregator,
            createdAt: createdAt,
            source: source,
            id: id,
            interestRate: interestRate,
            monthlyPayment: monthlyPayment,
            outstandingAmount: outstandingAmount,
            provider: provider,
            termRemaining: termRemaining,
            maturityDate: maturityDate,
            updatedAt: updatedAt,
            providerName: providerName);
  late final String id;
  late final String provider;
  late final String providerName;
  late final String country;
  final ValueModel outstandingAmount;
  late final num interestRate;
  late final num termRemaining;
  final ValueModel monthlyPayment;
  late final String createdAt;
  late final String updatedAt;
  late final String maturityDate;
  late final String source;
  final AggregatorModel? aggregator;

  factory PersonalLoanModel.fromJson(Map<String, dynamic> json) =>
      PersonalLoanModel(
        country: json['country'] ?? "",
        source: json['source'] ?? "",
        createdAt: json['createdAt'] ?? "",
        aggregator: json['aggregator'] != null
            ? AggregatorModel.fromJson(json['aggregator'])
            : null,
        maturityDate: json['maturityDate'] ?? "",
        id: json['id'],
        interestRate: json['interestRate'] ?? 0.0,
        monthlyPayment: ValueModel.fromJson(json['monthlyPayment'] ?? {}),
        outstandingAmount: ValueModel.fromJson(json['outstandingAmount'] ?? {}),
        provider: json['provider'] ?? "",
        termRemaining: json['termRemaining'] ?? 0,
        updatedAt: json['updatedAt'] ?? "",
        providerName: json['providerName'] ?? "",
      );

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['provider'] = provider;
    _data['providerName'] = providerName;
    _data['source'] = source;
    _data['country'] = country;
    _data['outstandingAmount'] = outstandingAmount.toJson();
    _data['aggregator'] = aggregator?.toJson();
    _data['interestRate'] = interestRate;
    _data['termRemaining'] = termRemaining;
    _data['monthlyPayment'] = monthlyPayment.toJson();
    _data['createdAt'] = createdAt;
    _data['maturityDate'] = this.maturityDate;

    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
