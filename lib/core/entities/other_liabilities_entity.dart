import 'package:wedge/core/entities/value_entity.dart';

import 'aggregator_entity.dart';

class OtherLiabilitiesEntity {
  OtherLiabilitiesEntity({
    required this.id,
    required this.name,
    required this.country,
    required this.debtValue,
    required this.monthlyPayment,
    required this.createdAt,
    required this.updatedAt,
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
    required this.frequency,
    required this.interestRateType,
    required this.lastUpdated,
    required this.principalBalance,
    required this.interestRate,
    required this.outstandingAmount,
    required this.termRemaining,
    required this.aggregator,
  }) : super();
  late final String id;
  late final String name;
  late final String country;
  late final ValueEntity debtValue;
  late final ValueEntity monthlyPayment;
  late final String createdAt;
  late final String updatedAt;
  final dynamic aggregatorId;
  final num termRemaining;
  final num interestRate;
  final num aggregatorProviderAccountId;
  final String aggregatorAccountNumber;
  final String aggregatorProviderId;
  final String accountType;
  final bool isDeleted;
  final String displayedName;
  final String providerName;
  final String lastUpdated;
  final String interestRateType;
  final ValueEntity principalBalance;
  final ValueEntity outstandingAmount;
  final String frequency;
  final String aggregatorLogo;
  final String source;
  AggregatorEntity? aggregator;
}
