import 'package:wedge/core/entities/aggregator_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';

class ManualBankAccountsEntity {
  ManualBankAccountsEntity({
    required this.id,
    required this.name,
    required this.country,
    required this.currency,
    required this.currentAmount,
    this.accountType,
    this.aggregatorAccountNumber,
    this.aggregatorLogo,
    this.aggregatorId,
    this.aggregatorProviderAccountId,
    this.aggregatorProviderId,
    this.availableBalance,
    this.createdAt,
    this.currentBalance,
    this.isDeleted,
    this.lastUpdated,
    this.providerName,
    this.source,
    this.updatedAt,
    this.aggregator,
  });
  late final String id;
  late final String name;
  late final String country;
  late final String currency;
  late final ValueEntity currentAmount;
  late dynamic aggregatorId;
  late dynamic aggregatorProviderAccountId;
  late String? providerName;
  late String? aggregatorAccountNumber;
  late String? aggregatorProviderId;
  late String? accountType;
  late bool? isDeleted;
  late ValueEntity? availableBalance;
  late ValueEntity? currentBalance;
  late String? lastUpdated;
  late String? aggregatorLogo;
  late String? source;
  late String? createdAt;
  late String? updatedAt;
  AggregatorEntity? aggregator;
  List<Object> get props => [
        id,
        name,
        country,
        currency,
        currentAmount,
      ];
}
