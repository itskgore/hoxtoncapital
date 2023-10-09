import 'package:wedge/core/entities/value_entity.dart';

import 'aggregator_entity.dart';

class InvestmentHoldingsEntity {
  final String sId;
  final dynamic aggregatorId;
  final String pseudonym;
  final dynamic aggregatorAccountId;
  final num aggregatorProviderAccountId;
  final ValueEntity costBasis;
  final String createdAt;
  final String cusipNumber;
  final String description;
  final ValueEntity employerContribution;
  final String enrichedDescription;
  final String holdingType;
  final String id;
  final bool isDeleted;
  final String isin;
  final String matchStatus;
  final String optionType;
  final ValueEntity price;
  final num quantity;
  final String securityStyle;
  final String securityType;
  final String sedol;
  final String source;
  final String symbol;
  final String updatedAt;
  final ValueEntity value;
  final dynamic percentageGrowth;
  final ValueEntity secondaryMarketValue;
  AggregatorEntity? aggregator;

  InvestmentHoldingsEntity(
      {required this.sId,
      required this.aggregatorId,
      required this.secondaryMarketValue,
      required this.percentageGrowth,
      required this.pseudonym,
      required this.aggregatorAccountId,
      required this.aggregatorProviderAccountId,
      required this.costBasis,
      required this.createdAt,
      required this.cusipNumber,
      required this.description,
      required this.employerContribution,
      required this.enrichedDescription,
      required this.holdingType,
      required this.id,
      required this.isDeleted,
      required this.isin,
      required this.matchStatus,
      required this.optionType,
      required this.price,
      required this.quantity,
      required this.securityStyle,
      required this.securityType,
      required this.sedol,
      required this.source,
      required this.symbol,
      required this.updatedAt,
      required this.aggregator,
      required this.value});
}
