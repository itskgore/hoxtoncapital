import 'package:wedge/core/entities/value_entity.dart';

import 'aggregator_entity.dart';

class InvestmentEntity {
  InvestmentEntity(
      {required this.id,
      required this.name,
      required this.country,
      required this.policyNumber,
      required this.initialValue,
      required this.currentValue,
      this.notes,
      this.aggregatorId,
      this.aggregatorProviderAccountId,
      this.providerName,
      this.totalUnvestedBalance,
      this.totalVestedBalance,
      this.marginBalance,
      this.balance,
      this.moneyMarketBalance,
      this.shortBalance,
      this.aggregatorAccountNumber,
      this.aggregatorProviderId,
      this.aggregator,
      this.accountType,
      this.isDeleted,
      this.cash,
      this.aggregatorLogo,
      this.source,
      this.createdAt,
      this.updatedAt,
      this.generalTransactionValue,
      this.withdrawalValue,
      this.percentageGrowth});

  late final String id;

  late final String name;
  String? notes;
  late final String country;
  late final String policyNumber;
  late final ValueEntity initialValue;
  late final ValueEntity currentValue;
  late final dynamic? aggregatorId;
  late final num? aggregatorProviderAccountId;
  late final String? providerName;
  late final ValueEntity? totalUnvestedBalance;
  late final ValueEntity? totalVestedBalance;
  late final ValueEntity? marginBalance;
  late final ValueEntity? balance;
  late final ValueEntity? moneyMarketBalance;
  late final ValueEntity? shortBalance;
  late final String? aggregatorAccountNumber;
  late final String? aggregatorProviderId;
  late final String? accountType;
  late final bool? isDeleted;
  late final ValueEntity? cash;
  late final String? aggregatorLogo;
  late final String? source;
  late final String? createdAt;
  late final String? updatedAt;
  late final dynamic? percentageGrowth;
  late final ValueEntity? withdrawalValue;
  late final ValueEntity? generalTransactionValue;
  AggregatorEntity? aggregator;
}

class InvestmentsInsightsEntity {
  int id;
  String name;
  String? notes;
  String country;
  String currency;
  double balance;

  InvestmentsInsightsEntity(
      {required this.id,
      required this.name,
      this.notes,
      required this.balance,
      required this.country,
      required this.currency});
}

class InvestmentInsightParentEntity {
  num totalValue;
  List<InvestmentsInsightsEntity> details;

  InvestmentInsightParentEntity({
    required this.totalValue,
    required this.details,
  });
}
