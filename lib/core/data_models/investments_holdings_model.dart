import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/investments_holdings_entity.dart';

import 'aggregator_model.dart';

class InvestmentHoldingsModel extends InvestmentHoldingsEntity {
  final String sId;
  final dynamic aggregatorId;
  final String pseudonym;
  final dynamic aggregatorAccountId;
  final num aggregatorProviderAccountId;
  final ValueModel costBasis;
  final String createdAt;
  final String cusipNumber;
  final String description;
  final ValueModel employerContribution;
  final String enrichedDescription;
  final String holdingType;
  final String id;
  final bool isDeleted;
  final String isin;
  final String matchStatus;
  final String optionType;
  final ValueModel price;
  final num quantity;
  final String securityStyle;
  final String securityType;
  final String sedol;
  final String source;
  final String symbol;
  final String updatedAt;
  final dynamic percentageGrowth;
  final ValueModel secondaryMarketValue;
  final ValueModel value;
  final AggregatorModel? aggregator;

  InvestmentHoldingsModel(
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
      required this.aggregator,
      required this.updatedAt,
      required this.value})
      : super(
            aggregatorAccountId: aggregatorAccountId,
            aggregatorId: aggregatorId,
            aggregatorProviderAccountId: aggregatorProviderAccountId,
            costBasis: costBasis,
            createdAt: createdAt,
            cusipNumber: cusipNumber,
            description: description,
            employerContribution: employerContribution,
            enrichedDescription: enrichedDescription,
            holdingType: holdingType,
            aggregator: aggregator,
            id: id,
            isDeleted: isDeleted,
            isin: isin,
            matchStatus: matchStatus,
            optionType: optionType,
            price: price,
            secondaryMarketValue: secondaryMarketValue,
            percentageGrowth: percentageGrowth,
            pseudonym: pseudonym,
            quantity: quantity,
            sId: sId,
            securityStyle: securityStyle,
            securityType: securityType,
            sedol: sedol,
            source: source,
            symbol: symbol,
            updatedAt: updatedAt,
            value: value);

  factory InvestmentHoldingsModel.fromJson(Map<String, dynamic> json) {
    return InvestmentHoldingsModel(
      sId: json['_id'] ?? "",
      percentageGrowth: json['percentageGrowth'] ?? "",
      aggregator: json['aggregator'] != null
          ? AggregatorModel.fromJson(json['aggregator'])
          : null,
      secondaryMarketValue:
          ValueModel.fromJson(json['secondaryMarketValue'] ?? {}),
      aggregatorId: json['aggregatorId'] ?? 0,
      pseudonym: json['pseudonym'] ?? "",
      aggregatorAccountId: json['aggregatorAccountId'] ?? 0,
      aggregatorProviderAccountId: json['aggregatorProviderAccountId'] ?? 0,
      costBasis: ValueModel.fromJson(json['costBasis'] ?? {}),
      createdAt: json['createdAt'] ?? "",
      cusipNumber: json['cusipNumber'] ?? "",
      description: json['description'] ?? "",
      employerContribution:
          ValueModel.fromJson(json['employerContribution'] ?? {}),
      enrichedDescription: json['enrichedDescription'] ?? "",
      holdingType: json['holdingType'] ?? "",
      id: json['id'] ?? "",
      isDeleted: json['isDeleted'] ?? false,
      isin: json['isin'] ?? "",
      matchStatus: json['matchStatus'] ?? "",
      optionType: json['optionType'] ?? "",
      price: ValueModel.fromJson(json['price'] ?? {}),
      quantity: json['quantity'] ?? 0,
      securityStyle: json['securityStyle'] ?? "",
      securityType: json['securityType'] ?? "",
      sedol: json['sedol'] ?? "",
      source: json['source'] ?? "",
      symbol: json['symbol'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      value: ValueModel.fromJson(json['value'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['percentageGrowth'] = percentageGrowth;
    data['secondaryMarketValue'] = secondaryMarketValue.toJson();
    data['aggregatorId'] = aggregatorId;
    data['pseudonym'] = pseudonym;
    data['aggregatorAccountId'] = aggregatorAccountId;
    data['aggregatorProviderAccountId'] = aggregatorProviderAccountId;
    data['costBasis'] = costBasis.toJson();
    data['createdAt'] = createdAt;
    data['cusipNumber'] = cusipNumber;
    data['description'] = description;
    data['employerContribution'] = employerContribution.toJson();
    data['enrichedDescription'] = enrichedDescription;
    data['holdingType'] = holdingType;
    data['id'] = id;
    data['isDeleted'] = isDeleted;
    data['isin'] = isin;
    data['matchStatus'] = matchStatus;
    data['optionType'] = optionType;
    data['price'] = price.toJson();
    data['quantity'] = quantity;
    data['securityStyle'] = securityStyle;
    data['securityType'] = securityType;
    data['sedol'] = sedol;
    data['source'] = source;
    data['symbol'] = symbol;
    data['updatedAt'] = updatedAt;
    data['value'] = value.toJson();
    return data;
  }
}
