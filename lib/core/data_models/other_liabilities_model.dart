import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';

import 'aggregator_model.dart';

class OtherLiabilities extends OtherLiabilitiesEntity {
  OtherLiabilities({
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
    required this.outstandingAmount,
    required this.interestRate,
    required this.termRemaining,
    required this.aggregator,
  }) : super(
            country: country,
            createdAt: createdAt,
            aggregator: aggregator,
            debtValue: debtValue,
            id: id,
            monthlyPayment: monthlyPayment,
            name: name,
            interestRate: interestRate,
            updatedAt: updatedAt,
            outstandingAmount: outstandingAmount,
            termRemaining: termRemaining,
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
            principalBalance: principalBalance,
            providerName: providerName,
            source: source);
  late final String id;
  late final String name;
  late final String country;
  final ValueModel debtValue;
  final ValueModel monthlyPayment;
  late final String createdAt;
  late final String updatedAt;
  late final dynamic aggregatorId;
  late final num aggregatorProviderAccountId;
  late final String aggregatorAccountNumber;
  late final num termRemaining;
  late final String aggregatorProviderId;
  late final String accountType;
  late final bool isDeleted;
  late final String displayedName;
  late final String providerName;
  late final String lastUpdated;
  late final String interestRateType;
  late final ValueModel principalBalance;
  late final ValueModel outstandingAmount;
  late final String frequency;
  late final String aggregatorLogo;
  late final num interestRate;
  late final String source;
  final AggregatorModel? aggregator;

  factory OtherLiabilities.fromJson(Map<String, dynamic> json) {
    return OtherLiabilities(
      createdAt: json['createdAt'] ?? "",
      termRemaining: json['termRemaining'] ?? 0,
      id: json['id'] ?? "",
      aggregator: json['aggregator'] != null
          ? AggregatorModel.fromJson(json['aggregator'])
          : null,
      country: json['country'] ?? "",
      monthlyPayment: ValueModel.fromJson(json['monthlyPayment'] ?? {}),
      outstandingAmount: ValueModel.fromJson(json['outstandingAmount'] ?? {}),
      debtValue: ValueModel.fromJson(json['debtValue'] ?? {}),
      name: json['name'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      accountType: json['accountType'] ?? "",
      aggregatorId: json['aggregatorId'] ?? 0,
      aggregatorProviderAccountId: json['aggregatorProviderAccountId'] ?? 0,
      providerName: json['providerName'] ?? "",
      aggregatorAccountNumber: json['aggregatorAccountNumber'] ?? "",
      aggregatorProviderId: json['aggregatorProviderId'] ?? "",
      displayedName: json['displayedName'] ?? "",
      interestRate: json['interestRate'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      aggregatorLogo: json['aggregatorLogo'] ?? "",
      source: json['source'] ?? "",
      frequency: json['frequency'] ?? "",
      interestRateType: json['interestRateType'] ?? "",
      lastUpdated: json['lastUpdated'] ?? "",
      principalBalance: ValueModel.fromJson(json['principalBalance'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aggregatorId'] = aggregatorId;
    data['aggregatorProviderAccountId'] = aggregatorProviderAccountId;
    data['name'] = name;
    data['debtValue'] = debtValue;
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
    data['aggregator'] = aggregator?.toJson();
    data['frequency'] = frequency;
    data['country'] = country;
    data['aggregatorLogo'] = aggregatorLogo;
    data['source'] = source;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
