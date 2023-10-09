import 'package:wedge/core/entities/aggregator_entity.dart';
import 'package:wedge/core/entities/assest_liabiltiy_onboarding_entity.dart';

class DisconnectedAccountsEntity {
  final String fiCategory;
  final String fiType;
  final String id;
  final String source;
  final String providerName;
  final String name;
  final dynamic aggregatorAccountNumber;
  final String aggregatorId;
  final AggregatorEntity aggregator;
  final String aggregatorLogo;
  final AmountEntity amount;

  DisconnectedAccountsEntity({
    required this.fiCategory,
    required this.fiType,
    required this.id,
    required this.source,
    required this.providerName,
    required this.name,
    required this.aggregatorAccountNumber,
    required this.aggregatorId,
    required this.aggregator,
    required this.aggregatorLogo,
    required this.amount,
  });
}
