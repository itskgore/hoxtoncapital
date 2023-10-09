import 'dart:convert';

import 'package:wedge/core/data_models/aggregator_model.dart';
import 'package:wedge/core/data_models/asset_liability_onboarding_model.dart';

import 'disconnected_account_entity.dart';

class DisconnectedAccountsModel extends DisconnectedAccountsEntity {
  final String fiCategory;
  final String fiType;
  final String id;
  final String source;
  final String providerName;
  final String name;
  final dynamic aggregatorAccountNumber;
  final String aggregatorId;
  final AggregatorModel aggregator;
  final String aggregatorLogo;
  final AmountModel amount;

  DisconnectedAccountsModel({
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
  }) : super(
          fiCategory: fiCategory,
          fiType: fiType,
          id: id,
          source: source,
          providerName: providerName,
          name: name,
          aggregatorAccountNumber: aggregatorAccountNumber,
          aggregatorId: aggregatorId,
          aggregator: aggregator,
          aggregatorLogo: aggregatorLogo,
          amount: amount,
        );

  factory DisconnectedAccountsModel.fromRawJson(String str) =>
      DisconnectedAccountsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DisconnectedAccountsModel.fromJson(Map<String, dynamic> json) =>
      DisconnectedAccountsModel(
        fiCategory: json["fiCategory"] ?? "",
        fiType: json["fiType"] ?? "",
        id: json["id"] ?? "",
        source: json["source"] ?? "",
        providerName: json["providerName"] ?? "",
        name: json["name"] ?? "",
        aggregatorAccountNumber: json["aggregatorAccountNumber"],
        aggregatorId: json["aggregatorId"].toString() ?? "",
        aggregator: AggregatorModel.fromJson(json["aggregator"]),
        aggregatorLogo: json["aggregatorLogo"] ?? "",
        amount: AmountModel.fromJson(json["amount"]),
      );

  Map<String, dynamic> toJson() => {
        "fiCategory": fiCategory,
        "fiType": fiType,
        "id": id,
        "source": source,
        "providerName": providerName,
        "name": name,
        "aggregatorAccountNumber": aggregatorAccountNumber,
        "aggregatorId": aggregatorId,
        "aggregator": aggregator.toJson(),
        "aggregatorLogo": aggregatorLogo,
        "amount": amount.toJson(),
      };
}
