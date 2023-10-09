import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';

import 'aggregator_entity.dart';

class VehicleLoansEntity {
  VehicleLoansEntity({
    required this.id,
    required this.outstandingAmount,
    required this.interestRate,
    required this.termRemaining,
    required this.monthlyPayment,
    required this.createdAt,
    required this.updatedAt,
    required this.country,
    required this.vehicles,
    required this.maturityDate,
    required this.hasLoan,
    required this.provider,
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
    required this.aggregator,
  }) : super();
  String id;
  final ValueEntity outstandingAmount;
  final bool hasLoan;
  final num interestRate;
  final num termRemaining;
  AggregatorEntity? aggregator;

  final ValueEntity monthlyPayment;
  final String createdAt;
  final String updatedAt;
  final String country;
  final String maturityDate;
  List<VehicleEntity> vehicles;
  String provider;
  final dynamic aggregatorId;
  final num aggregatorProviderAccountId;
  final String name;
  final String aggregatorAccountNumber;
  final String aggregatorProviderId;
  final String accountType;
  final bool isDeleted;
  final String displayedName;
  final String providerName;
  final String lastUpdated;
  final String interestRateType;
  final ValueEntity principalBalance;
  final String frequency;
  final String aggregatorLogo;
  final String source;
}
