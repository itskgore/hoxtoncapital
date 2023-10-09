import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';

import 'aggregator_model.dart';

class Mortgages extends MortgagesEntity {
  Mortgages({
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
  }) : super(
            createdAt: createdAt,
            id: id,
            hasLoan: hasLoan,
            interestRate: interestRate,
            monthlyPayment: monthlyPayment,
            outstandingAmount: outstandingAmount,
            provider: provider,
            startDate: startDate,
            termRemaining: termRemaining,
            aggregator: aggregator,
            country: country,
            updatedAt: updatedAt,
            maturityDate: maturityDate,
            accountType: accountType,
            aggregatorAccountNumber: aggregatorAccountNumber,
            aggregatorId: aggregatorId,
            aggregatorLogo: aggregatorLogo,
            aggregatorProviderAccountId: aggregatorProviderAccountId,
            aggregatorProviderId: aggregatorProviderId,
            displayedName: displayedName,
            frequency: frequency,
            interestRateType: interestRateType,
            isDeleted: isDeleted,
            lastUpdated: lastUpdated,
            name: name,
            principalBalance: principalBalance,
            providerName: providerName,
            source: source);
  late final String id;
  late final String country;
  late final String provider;
  late final String startDate;
  late final ValueModel outstandingAmount;
  late final num interestRate;
  late final dynamic termRemaining;
  late final ValueModel monthlyPayment;
  late final String createdAt;
  late final bool hasLoan;
  late final String updatedAt;
  late final dynamic aggregatorId;
  late final num aggregatorProviderAccountId;
  late final String name;
  late final String aggregatorAccountNumber;
  late final String aggregatorProviderId;
  late final String accountType;
  late final bool isDeleted;
  late final String displayedName;
  late final String providerName;
  late final String lastUpdated;
  late final String interestRateType;
  late final ValueModel principalBalance;
  late final String frequency;
  late final String aggregatorLogo;
  late final String source;
  late final String maturityDate;
  final AggregatorModel? aggregator;

  factory Mortgages.fromJson(Map<String, dynamic> json) {
    return Mortgages(
      createdAt: json['createdAt'] ?? "",
      country: json['country'] ?? "",
      maturityDate: json['maturityDate'] ?? "",
      aggregator: json['aggregator'] != null
          ? AggregatorModel.fromJson(json['aggregator'])
          : null,
      id: json['id'] ?? "",
      interestRate: json['interestRate'] ?? 0,
      // interestRate: 0,
      monthlyPayment: ValueModel.fromJson(json['monthlyPayment'] ?? {}),
      outstandingAmount: ValueModel.fromJson(json['outstandingAmount'] ?? {}),
      provider: json['provider'] ?? "",
      hasLoan: json['hasLoan'] ?? false,
      startDate: json['startDate'] ?? "",
      termRemaining: json['termRemaining'] ?? 0,
      // termRemaining: 0,
      updatedAt: json['updatedAt'] ?? "",
      accountType: json['accountType'] ?? "",
      aggregatorId: json['aggregatorId'] ?? 0,
      aggregatorProviderAccountId: json['aggregatorProviderAccountId'] ?? 0,
      providerName: json['providerName'] ?? "",
      aggregatorAccountNumber: json['aggregatorAccountNumber'] ?? "",
      aggregatorProviderId: json['aggregatorProviderId'] ?? "",
      displayedName: json['displayedName'] ?? "",
      isDeleted: json['isDeleted'] ?? false,
      aggregatorLogo: json['aggregatorLogo'] ?? "",
      source: json['source'] ?? "",
      frequency: json['frequency'] ?? "",
      interestRateType: json['interestRateType'] ?? "",
      lastUpdated: json['lastUpdated'] ?? "",
      name: json['name'] ?? "",
      principalBalance: ValueModel.fromJson(json['principalBalance'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aggregatorId'] = aggregatorId;
    data['aggregatorProviderAccountId'] = aggregatorProviderAccountId;
    data['name'] = name;
    data['aggregator'] = aggregator?.toJson();

    data['aggregatorAccountNumber'] = aggregatorAccountNumber;
    data['aggregatorProviderId'] = aggregatorProviderId;
    data['accountType'] = accountType;
    data['isDeleted'] = isDeleted;
    data['outstandingAmount'] = outstandingAmount.toJson();
    data['interestRate'] = interestRate;
    data['monthlyPayment'] = monthlyPayment.toJson();
    data['termRemaining'] = termRemaining;
    data['displayedName'] = displayedName;
    data['providerName'] = providerName;
    data['lastUpdated'] = lastUpdated;
    data['interestRateType'] = interestRateType;
    data['principalBalance'] = principalBalance.toJson();
    data['frequency'] = frequency;
    data['country'] = country;
    data['maturityDate'] = maturityDate;
    data['aggregatorLogo'] = aggregatorLogo;
    data['source'] = source;
    data['provider'] = provider;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
