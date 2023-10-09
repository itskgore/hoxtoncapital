import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/investment_entity.dart';

import 'aggregator_model.dart';

class InvestmentsModel extends InvestmentEntity {
  InvestmentsModel({
    required this.aggregatorId,
    required this.aggregatorProviderAccountId,
    required this.providerName,
    required this.totalUnvestedBalance,
    required this.totalVestedBalance,
    required this.marginBalance,
    required this.balance,
    required this.moneyMarketBalance,
    required this.shortBalance,
    required this.aggregatorAccountNumber,
    required this.aggregatorProviderId,
    required this.accountType,
    required this.isDeleted,
    required this.cash,
    required this.aggregatorLogo,
    required this.source,
    required this.createdAt,
    required this.withdrawalValue,
    required this.percentageGrowth,
    required this.generalTransactionValue,
    required this.updatedAt,
    required this.id,
    required this.name,
    this.notes,
    required this.policyNumber,
    required this.country,
    required this.initialValue,
    required this.currentValue,
    required this.aggregator,
  }) : super(
            id: id,
            name: name,
            notes: notes,
            policyNumber: policyNumber,
            country: country,
            initialValue: initialValue,
            currentValue: currentValue,
            withdrawalValue: withdrawalValue,
            generalTransactionValue: generalTransactionValue,
            percentageGrowth: percentageGrowth,
            accountType: accountType,
            source: source,
            aggregatorAccountNumber: aggregatorAccountNumber,
            aggregatorId: aggregatorId,
            aggregator: aggregator,
            aggregatorLogo: aggregatorLogo,
            aggregatorProviderAccountId: aggregatorProviderAccountId,
            aggregatorProviderId: aggregatorProviderId,
            balance: balance,
            cash: cash,
            createdAt: createdAt,
            isDeleted: isDeleted,
            marginBalance: marginBalance,
            moneyMarketBalance: moneyMarketBalance,
            providerName: providerName,
            shortBalance: shortBalance,
            totalUnvestedBalance: totalUnvestedBalance,
            totalVestedBalance: totalUnvestedBalance,
            updatedAt: updatedAt);

  final String id;
  final String name;
  final String? notes;
  final String policyNumber;
  final String country;
  final ValueModel initialValue;
  final ValueModel currentValue;
  final dynamic aggregatorId;
  final num aggregatorProviderAccountId;
  final String providerName;
  final ValueModel totalUnvestedBalance;
  final ValueModel totalVestedBalance;
  final ValueModel marginBalance;
  final ValueModel balance;
  final ValueModel moneyMarketBalance;
  final ValueModel shortBalance;
  final String aggregatorAccountNumber;
  final String aggregatorProviderId;
  final String accountType;
  final bool isDeleted;
  final ValueModel cash;
  final String aggregatorLogo;
  final String source;
  final ValueModel withdrawalValue;
  final dynamic percentageGrowth;
  final ValueModel generalTransactionValue;
  final String createdAt;
  final String updatedAt;
  final AggregatorModel? aggregator;

  factory InvestmentsModel.fromJson(Map<String, dynamic> json) {
    return InvestmentsModel(
      id: json['id'] ?? "",
      notes: json['notes'] ?? "",
      name: json['name'] ?? "",
      aggregator: json['aggregator'] != null
          ? AggregatorModel.fromJson(json['aggregator'])
          : null,
      policyNumber: json['policyNumber'] ?? "",
      country: json['country'] ?? "",
      initialValue: ValueModel.fromJson(json['initialValue'] ?? {}),
      currentValue: ValueModel.fromJson(json['currentValue'] ?? {}),
      aggregatorId: json['aggregatorId'] ?? 0,
      aggregatorProviderAccountId: json['aggregatorProviderAccountId'] ?? 0,
      providerName: json['providerName'] ?? "",
      percentageGrowth: json['percentageGrowth'] ?? "",
      withdrawalValue: json['withdrawalValue'] != null
          ? ValueModel.fromJson(json['withdrawalValue'])
          : ValueModel(amount: 0, currency: ""),
      generalTransactionValue: json['generalTransactionValue'] != null
          ? ValueModel.fromJson(json['generalTransactionValue'])
          : ValueModel(amount: 0, currency: ""),
      totalUnvestedBalance:
          ValueModel.fromJson(json['totalUnvestedBalance'] ?? {}),
      totalVestedBalance: ValueModel.fromJson(json['totalVestedBalance'] ?? {}),
      marginBalance: ValueModel.fromJson(json['marginBalance'] ?? {}),
      balance: ValueModel.fromJson(json['balance'] ?? {}),
      moneyMarketBalance: ValueModel.fromJson(json['moneyMarketBalance'] ?? {}),
      shortBalance: ValueModel.fromJson(json['shortBalance'] ?? {}),
      aggregatorAccountNumber: json['aggregatorAccountNumber'] ?? "",
      aggregatorProviderId: json['aggregatorProviderId'] ?? "",
      accountType: json['accountType'] ?? "",
      isDeleted: json['isDeleted'] ?? false,
      cash: ValueModel.fromJson(json['cash'] ?? {}),
      aggregatorLogo: json['aggregatorLogo'] ?? "",
      source: json['source'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['aggregatorId'] = aggregatorId;
    data['aggregator'] = aggregator?.toJson();
    data['aggregatorProviderAccountId'] = aggregatorProviderAccountId;
    data['name'] = name;
    data['notes'] = notes;
    data['withdrawalValue'] = withdrawalValue.toJson();
    data['generalTransactionValue'] = generalTransactionValue.toJson();
    data['percentageGrowth'] = percentageGrowth;
    data['policyNumber'] = policyNumber;
    data['providerName'] = providerName;
    data['totalUnvestedBalance'] = totalUnvestedBalance.toJson();
    data['totalVestedBalance'] = totalVestedBalance.toJson();
    data['marginBalance'] = marginBalance.toJson();
    data['balance'] = balance.toJson();
    data['moneyMarketBalance'] = moneyMarketBalance.toJson();
    data['shortBalance'] = shortBalance.toJson();
    data['aggregatorAccountNumber'] = aggregatorAccountNumber;
    data['aggregatorProviderId'] = aggregatorProviderId;
    data['accountType'] = accountType;
    data['isDeleted'] = isDeleted;
    data['currentValue'] = currentValue.toJson();
    data['initialValue'] = initialValue.toJson();
    data['cash'] = cash.toJson();
    data['country'] = country;
    data['aggregatorLogo'] = aggregatorLogo;
    data['source'] = source;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }
}

class InvestmentInsightsModel extends InvestmentsInsightsEntity {
  final int id;
  final String name;
  final String? notes;
  final String country;
  final String currency;
  final double balance;
  InvestmentInsightsModel(
      {required this.name,
      this.notes,
      required this.id,
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

  factory InvestmentInsightsModel.fromJson(Map<String, dynamic> json) {
    return InvestmentInsightsModel(
      id: json['id'] ?? "",
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
    final data = <String, dynamic>{};
    data['id'] = id;

    data['currency'] = currency;
    data['name'] = name;
    data['notes'] = notes;
    data['balance'] = balance;
    data['country'] = country;
    return data;
  }
}

class InvestmentInsightsParentModel extends InvestmentInsightParentEntity {
  final List<InvestmentInsightsModel> investments;
  final num totalValue;
  InvestmentInsightsParentModel({
    required this.investments,
    required this.totalValue,
  }) : super(totalValue: totalValue, details: investments);

  factory InvestmentInsightsParentModel.fromJson(Map<String, dynamic> json) {
    int index = 0;
    return InvestmentInsightsParentModel(
        totalValue: json['totalValue'] ?? 0.0,
        investments: List.from(json['details'] ?? {}).map((e) {
          e['id'] = index++;
          return InvestmentInsightsModel.fromJson(e);
        }).toList());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['totalValue'] = totalValue;
    data['details'] = investments;

    return data;
  }
}
