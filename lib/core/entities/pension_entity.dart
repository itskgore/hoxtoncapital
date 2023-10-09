import 'package:wedge/features/assets/bank_account/userdata_summery/domain/entities/hoxton_summery_entity.dart';

import 'aggregator_entity.dart';

class PensionsEntity {
  String id;
  dynamic aggregatorId;
  String name;
  String pensionType;
  String aggregatorLogo;
  String country;
  String source;
  String notes;
  String policyNumber;
  TotalWithCurrencyEntity annualIncomeAfterRetirement;
  TotalWithCurrencyEntity currentValue;
  int retirementAge;
  String createdAt;
  String updatedAt;
  TotalWithCurrencyEntity monthlyContributionAmount;
  TotalWithCurrencyEntity contributionTotalAmount;
  dynamic percentageGrowth;
  TotalWithCurrencyEntity withdrawalValue;
  TotalWithCurrencyEntity generalTransactionValue;
  num averageAnnualGrowthRate;
  AggregatorEntity? aggregator;

  PensionsEntity(
      {required this.id,
      required this.name,
      required this.notes,
      required this.percentageGrowth,
      required this.withdrawalValue,
      required this.generalTransactionValue,
      required this.aggregatorId,
      required this.pensionType,
      required this.aggregatorLogo,
      required this.country,
      required this.source,
      required this.policyNumber,
      required this.annualIncomeAfterRetirement,
      required this.currentValue,
      required this.retirementAge,
      required this.createdAt,
      required this.updatedAt,
      required this.monthlyContributionAmount,
      required this.contributionTotalAmount,
      required this.aggregator,
      required this.averageAnnualGrowthRate});
}

class PensionsInsightsEntity {
  int id;
  String name;
  String notes;
  String country;
  String currency;
  double balance;

  PensionsInsightsEntity(
      {required this.id,
      required this.name,
      required this.notes,
      required this.balance,
      required this.country,
      required this.currency});
}

class PensionsInsightParentEntity {
  num totalValue;
  List<PensionsInsightsEntity> details;

  PensionsInsightParentEntity({
    required this.totalValue,
    required this.details,
  });
}
