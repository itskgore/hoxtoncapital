import 'package:wedge/core/entities/value_entity.dart';

import 'aggregator_entity.dart';

class MortgagesEntity {
  MortgagesEntity({
    required this.id,
    required this.provider,
    required this.startDate,
    required this.outstandingAmount,
    required this.interestRate,
    required this.termRemaining,
    required this.monthlyPayment,
    required this.createdAt,
    required this.updatedAt,
    required this.country,
    required this.hasLoan,
    required this.aggregatorId,
    required this.aggregatorAccountNumber,
    required this.providerName,
    required this.accountType,
    required this.aggregatorProviderAccountId,
    required this.aggregatorProviderId,
    required this.displayedName,
    required this.isDeleted,
    required this.source,
    required this.aggregatorLogo,
    required this.name,
    required this.frequency,
    required this.interestRateType,
    required this.lastUpdated,
    required this.principalBalance,
    required this.maturityDate,
    required this.aggregator,
  });
  final String id;
  final String provider;
  final String country;

  final String startDate;
  final ValueEntity outstandingAmount;
  final num interestRate;
  final bool hasLoan;
  final dynamic termRemaining;
  final ValueEntity monthlyPayment;
  final String createdAt;
  final String updatedAt;
  final dynamic aggregatorId;
  final num aggregatorProviderAccountId;
  final String name;
  final String aggregatorAccountNumber;
  final String aggregatorProviderId;
  AggregatorEntity? aggregator;

  final String accountType;
  final bool isDeleted;
  final String displayedName;
  final String providerName;
  final String lastUpdated;
  final String interestRateType;
  final String maturityDate;
  final ValueEntity principalBalance;
  final String frequency;
  final String aggregatorLogo;
  final String source;
}
