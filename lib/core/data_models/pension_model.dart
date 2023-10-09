import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/data/models/hoxton_summery_model.dart';

import 'aggregator_model.dart';

class PensionsModel extends PensionsEntity {
  PensionsModel({
    required this.id,
    required this.aggregatorId,
    required this.name,
    required this.notes,
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
    required this.averageAnnualGrowthRate,
    required this.withdrawalValue,
    required this.percentageGrowth,
    required this.generalTransactionValue,
    required this.aggregator,
  }) : super(
            id: id,
            name: name,
            notes: notes,
            aggregatorId: aggregatorId,
            pensionType: pensionType,
            aggregatorLogo: aggregatorLogo,
            country: country,
            source: source,
            withdrawalValue: withdrawalValue,
            generalTransactionValue: generalTransactionValue,
            percentageGrowth: percentageGrowth,
            policyNumber: policyNumber,
            annualIncomeAfterRetirement: annualIncomeAfterRetirement,
            currentValue: currentValue,
            aggregator: aggregator,
            retirementAge: retirementAge,
            createdAt: createdAt,
            updatedAt: updatedAt,
            monthlyContributionAmount: monthlyContributionAmount,
            contributionTotalAmount: contributionTotalAmount,
            averageAnnualGrowthRate: averageAnnualGrowthRate);
  final String id;
  final String name;
  final String notes;
  final String pensionType;
  final String aggregatorLogo;
  final String country;
  final String source;
  final String policyNumber;
  final Total annualIncomeAfterRetirement;
  final Total currentValue;
  final int retirementAge;
  final String createdAt;
  final String updatedAt;
  final Total monthlyContributionAmount;
  final Total withdrawalValue;
  final dynamic percentageGrowth;
  final Total generalTransactionValue;
  final Total contributionTotalAmount;
  final num averageAnnualGrowthRate;
  final dynamic aggregatorId;
  final AggregatorModel? aggregator;

  factory PensionsModel.fromJson(Map<String, dynamic> json) {
    return PensionsModel(
        id: json['id'] ?? "",
        aggregatorId: json['aggregatorId'] ?? "",
        name: json['name'] ?? "",
        notes: json['notes'] ?? "",
        pensionType: json['pensionType'] ?? "",
        aggregatorLogo: json['aggregatorLogo'] ?? "",
        country: json['country'] ?? "",
        source: json['source'] ?? "",
        policyNumber: json['policyNumber'] ?? "",
        aggregator: json['aggregator'] != null
            ? AggregatorModel.fromJson(json['aggregator'])
            : null,
        annualIncomeAfterRetirement: json['annualIncomeAfterRetirement'] != null
            ? Total.fromJson(json['annualIncomeAfterRetirement'])
            : Total(amount: 0, currency: ""),
        percentageGrowth: json['percentageGrowth'] ?? "",
        withdrawalValue: json['withdrawalValue'] != null
            ? Total.fromJson(json['withdrawalValue'])
            : Total(amount: 0, currency: ""),
        generalTransactionValue: json['generalTransactionValue'] != null
            ? Total.fromJson(json['generalTransactionValue'])
            : Total(amount: 0, currency: ""),
        currentValue: json['currentValue'] != null
            ? Total.fromJson(json['currentValue'])
            : Total(amount: 0, currency: ""),
        retirementAge: json['retirementAge'] ?? 0,
        createdAt: json['createdAt'] ?? "",
        updatedAt: json['updatedAt'] ?? "",
        monthlyContributionAmount: json['monthlyContributionAmount'] != null
            ? Total.fromJson(json['monthlyContributionAmount'])
            : Total(amount: 0, currency: ""),
        contributionTotalAmount: json['contributionTotalAmount'] != null
            ? Total.fromJson(json['contributionTotalAmount'])
            : Total(amount: 0, currency: ""),
        averageAnnualGrowthRate: json['averageAnnualGrowthRate'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['notes'] = notes;
    _data['withdrawalValue'] = withdrawalValue.toJson();
    _data['generalTransactionValue'] = generalTransactionValue.toJson();
    _data['percentageGrowth'] = percentageGrowth;
    _data['aggregatorId'] = aggregatorId;
    _data['pensionType'] = pensionType;
    _data['aggregatorLogo'] = aggregatorLogo;
    _data['country'] = country;
    _data['source'] = source;
    _data['policyNumber'] = policyNumber;
    _data['annualIncomeAfterRetirement'] = annualIncomeAfterRetirement.toJson();
    _data['currentValue'] = currentValue.toJson();
    _data['retirementAge'] = retirementAge;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['monthlyContributionAmount'] = monthlyContributionAmount.toJson();
    _data['contributionTotalAmount'] = contributionTotalAmount.toJson();
    _data['currentValue'] = currentValue;
    _data['averageAnnualGrowthRate'] = averageAnnualGrowthRate;
    return _data;
  }
}

class PensionsInsightsModel extends PensionsInsightsEntity {
  final int id;
  final String name;
  final String notes;
  final String country;
  final String currency;
  final double balance;
  PensionsInsightsModel(
      {required this.id,
      required this.name,
      required this.notes,
      required this.balance,
      required this.country,
      required this.currency})
      : super(
            name: name,
            notes: notes,
            country: country,
            balance: balance,
            currency: currency,
            id: id);

  factory PensionsInsightsModel.fromJson(Map<String, dynamic> json) {
    return PensionsInsightsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      notes: json['notes'] ?? "",
      country: json['country'] ?? "",
      balance: json['balance'] != null
          ? double.parse(json['balance'].toString())
          : 0.0,
      currency: json['currency'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;

    _data['currency'] = currency;
    _data['name'] = name;
    _data['notes'] = notes;
    _data['balance'] = balance;
    _data['country'] = country;
    return _data;
  }
}

class PensionsInsightsParentModel extends PensionsInsightParentEntity {
  final List<PensionsInsightsModel> pensions;
  final num totalValue;
  PensionsInsightsParentModel({
    required this.pensions,
    required this.totalValue,
  }) : super(totalValue: totalValue, details: pensions);

  factory PensionsInsightsParentModel.fromJson(Map<String, dynamic> json) {
    int index = 0;

    return PensionsInsightsParentModel(
        totalValue: json['totalValue'] ?? 0.0,
        pensions: List.from(json['details'] ?? {}).map((e) {
          e['id'] = index++;
          return PensionsInsightsModel.fromJson(e);
        }).toList());
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['totalValue'] = totalValue;
    _data['details'] = pensions;

    return _data;
  }
}
