import 'package:wedge/core/entities/value_entity.dart';

import 'aggregator_entity.dart';

class CreditCardsEntity {
  CreditCardsEntity({
    required this.id,
    required this.name,
    required this.country,
    required this.outstandingAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.aggregatorId,
    this.creditLimit,
    required this.aggregatorAccountNumber,
    required this.providerName,
    required this.accountType,
    required this.aggregatorProviderAccountId,
    required this.aggregatorProviderId,
    required this.amountDue,
    required this.currentAmount,
    required this.displayedName,
    required this.isDeleted,
    required this.lastPaymentAmount,
    required this.minimumAmountDue,
    required this.runningBalance,
    required this.totalCashLimit,
    required this.totalCreditLine,
    required this.source,
    required this.aggregatorLogo,
    required this.aggregator,
  });
  final String id;
  final String name;
  final String country;
  final ValueEntity outstandingAmount;
  final String createdAt;
  final String updatedAt;
  final dynamic aggregatorId;

  final num aggregatorProviderAccountId;
  final String providerName;
  final String aggregatorAccountNumber;
  final String aggregatorProviderId;
  final String accountType;
  final String displayedName;
  final bool isDeleted;
  final ValueEntity currentAmount;
  final ValueEntity minimumAmountDue;
  final ValueEntity amountDue;
  final ValueEntity totalCashLimit;
  final ValueEntity runningBalance;
  final ValueEntity lastPaymentAmount;
  final ValueEntity totalCreditLine;
  final ValueEntity? creditLimit;
  final String aggregatorLogo;
  final String source;
  AggregatorEntity? aggregator;
}
