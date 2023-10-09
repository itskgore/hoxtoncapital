import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/data_models/vehicle_model.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';

import 'aggregator_model.dart';

class VehicleLoans extends VehicleLoansEntity {
  VehicleLoans({
    required this.id,
    required this.outstandingAmount,
    required this.interestRate,
    required this.termRemaining,
    required this.monthlyPayment,
    required this.createdAt,
    required this.updatedAt,
    required this.country,
    required this.maturityDate,
    required this.provider,
    required this.hasLoan,
    required this.vehicles,
    required this.aggregatorId,
    required this.aggregatorAccountNumber,
    required this.providerName,
    required this.accountType,
    required this.aggregator,
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
  }) : super(
            createdAt: createdAt,
            id: id,
            aggregator: aggregator,
            interestRate: interestRate,
            monthlyPayment: monthlyPayment,
            outstandingAmount: outstandingAmount,
            termRemaining: termRemaining,
            country: country,
            provider: provider,
            hasLoan: hasLoan,
            maturityDate: maturityDate,
            vehicles: vehicles,
            updatedAt: updatedAt,
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
  late final ValueModel outstandingAmount;
  late final num interestRate;
  late final num termRemaining;
  late final ValueModel monthlyPayment;
  late final String createdAt;
  late final String updatedAt;
  late final String country;
  late final String provider;
  late final String maturityDate;
  late final bool hasLoan;
  final List<VehicleModel> vehicles;
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
  final AggregatorModel? aggregator;

  factory VehicleLoans.fromJson(Map<String, dynamic> json) {
    return VehicleLoans(
      createdAt: json['createdAt'] ?? "",
      id: json['id'],
      aggregator: json['aggregator'] != null
          ? AggregatorModel.fromJson(json['aggregator'])
          : null,
      interestRate: json['interestRate'] ?? 0,
      monthlyPayment: ValueModel.fromJson(json['monthlyPayment'] ?? {}),
      outstandingAmount: ValueModel.fromJson(json['outstandingAmount'] ?? {}),
      termRemaining: json['termRemaining'] ?? 0,
      updatedAt: json['updatedAt'] ?? "",
      country: json['country'] ?? "",
      provider: json['provider'] ?? "",
      maturityDate: json['maturityDate'] ?? "",
      hasLoan: json['hasLoan'] ?? false,
      vehicles: List.from(json['vehicles'] ?? {})
          .map((e) => VehicleModel.fromJson(e))
          .toList(),
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
    data['maturityDate'] = maturityDate;
    data['provider'] = provider;
    data['lastUpdated'] = lastUpdated;
    data['interestRateType'] = interestRateType;
    data['principalBalance'] = principalBalance.toJson();
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
