import 'package:wedge/core/data_models/aggregator_model.dart';
import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';

class ManualBankAccountsModel extends ManualBankAccountsEntity {
  ManualBankAccountsModel({
    required this.id,
    required this.name,
    required this.country,
    required this.currency,
    required this.currentAmount,
    required this.accountType,
    required this.aggregatorAccountNumber,
    required this.aggregatorLogo,
    required this.aggregatorId,
    required this.aggregatorProviderAccountId,
    required this.aggregatorProviderId,
    required this.availableBalance,
    required this.createdAt,
    required this.currentBalance,
    required this.isDeleted,
    required this.lastUpdated,
    required this.providerName,
    required this.source,
    required this.updatedAt,
    required this.aggregator,
  }) : super(
            id: id,
            name: name,
            country: country,
            currency: currency,
            currentAmount: currentAmount,
            accountType: accountType,
            aggregatorAccountNumber: aggregatorAccountNumber,
            aggregator: aggregator,
            aggregatorId: aggregatorId,
            aggregatorLogo: aggregatorLogo,
            aggregatorProviderAccountId: aggregatorProviderAccountId,
            aggregatorProviderId: aggregatorProviderId,
            availableBalance: availableBalance,
            createdAt: createdAt,
            currentBalance: currentBalance,
            isDeleted: isDeleted,
            lastUpdated: lastUpdated,
            providerName: providerName,
            source: source,
            updatedAt: updatedAt);
  late final String id;
  late final String name;
  late final String country;
  late final String currency;
  final ValueModel currentAmount;
  late dynamic aggregatorId;
  late dynamic aggregatorProviderAccountId;
  late String? providerName;
  final AggregatorModel? aggregator;
  late String? aggregatorAccountNumber;
  late String? aggregatorProviderId;
  late String? accountType;
  late bool? isDeleted;
  final ValueModel? availableBalance;
  final ValueModel? currentBalance;
  late String? lastUpdated;
  late String? aggregatorLogo;
  late String? source;
  late String? createdAt;
  late String? updatedAt;

  factory ManualBankAccountsModel.fromJson(Map<String, dynamic> json) {
    return ManualBankAccountsModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      country: json['country'] ?? "",
      currency: json['currency'] ?? "",
      currentAmount: ValueModel.fromJson(json['currentAmount'] ?? {}),
      aggregator: json['aggregator'] != null
          ? AggregatorModel.fromJson(json['aggregator'])
          : null,
      accountType: json['accountType'] ?? "",
      aggregatorAccountNumber: json['aggregatorAccountNumber'] ?? "",
      aggregatorId: json['aggregatorId'] ?? 0,
      aggregatorLogo: json['aggregatorLogo'] ?? "",
      aggregatorProviderAccountId: json['aggregatorProviderAccountId'] ?? 0,
      aggregatorProviderId: json['aggregatorProviderId'] ?? "",
      availableBalance: ValueModel.fromJson(json['availableBalance'] ?? {}),
      createdAt: json['createdAt'] ?? "",
      currentBalance: ValueModel.fromJson(json['currentBalance'] ?? {}),
      isDeleted: json['isDeleted'] ?? false,
      lastUpdated: json['lastUpdated'] ?? "",
      providerName: json['providerName'] ?? "",
      source: json['source'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['aggregatorId'] = aggregatorId;
    data['aggregatorProviderAccountId'] = aggregatorProviderAccountId;
    data['name'] = name;
    data['aggregator'] = aggregator?.toJson();
    data['providerName'] = providerName;
    data['aggregatorAccountNumber'] = aggregatorAccountNumber;
    data['aggregatorProviderId'] = aggregatorProviderId;
    data['accountType'] = accountType;
    data['isDeleted'] = isDeleted;
    if (currentAmount != null) {
      data['currentAmount'] = currentAmount.toJson();
    }
    if (availableBalance != null) {
      data['availableBalance'] = availableBalance!.toJson();
    }
    if (currentBalance != null) {
      data['currentBalance'] = currentBalance!.toJson();
    }
    data['lastUpdated'] = lastUpdated;
    data['country'] = country;
    data['aggregatorLogo'] = aggregatorLogo;
    data['source'] = source;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }
}
