import 'package:wedge/core/entities/aggregator_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';

class PersonalLoanEntity {
  PersonalLoanEntity({
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
    required this.maturityDate,
    required this.aggregator,
    required this.source,
  });

  late final String id;
  late final String provider;
  late final String providerName;
  late final String source;
  late final String country;
  late final ValueEntity outstandingAmount;
  late final num interestRate;
  late final num termRemaining;
  late final ValueEntity monthlyPayment;
  late final String createdAt;
  late final String updatedAt;
  final AggregatorEntity? aggregator;
  late final String maturityDate;
}
