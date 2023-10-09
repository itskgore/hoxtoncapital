import 'package:wedge/core/data_models/aggregator_model.dart';
import 'package:wedge/core/entities/assest_liabiltiy_onboarding_entity.dart';

class AssetLiabilityOnboardingListModel
    extends AssetLiabilityOnboardingListEntity {
  AssetLiabilityOnboardingListModel(super.assetLiabilityOnboardingEntityList);

  factory AssetLiabilityOnboardingListModel.fromJson(List<dynamic>? json) {
    return AssetLiabilityOnboardingListModel(List<Map<String, dynamic>>.from(json ?? [])
        .map((e) => AssetLiabilityOnboardingModel.fromJson(e))
        .toList());
  }
}

class AssetLiabilityOnboardingModel extends AssetLiabilityOnboardingEntity {
  AssetLiabilityOnboardingModel(
      {required super.fiCategory,
      super.fiType,
      required super.source,
      required super.aggregator,
      required super.aggregatorLogo,
      required super.providerName,
      required super.name,
      required super.aggregatorAccountNumber,
      required super.amount});

  factory AssetLiabilityOnboardingModel.fromJson(Map<String, dynamic> json) {
    return AssetLiabilityOnboardingModel(
      fiCategory: json['fiCategory'] ?? '',
      fiType: json['fiType'] ?? '',
      source: json['source'] ?? '',
      aggregator: AggregatorModel.fromJson(json['aggregator'] ?? {}),
      aggregatorLogo: json['aggregatorLogo'] ?? '',
      providerName: json['providerName'] ?? '',
      name: json['name'] ?? '',
      aggregatorAccountNumber: json['aggregatorAccountNumber'] ?? '',
      amount: AmountModel.fromJson(json['amount'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['fiCategory'] = fiCategory;
    data['fiType'] = fiType;
    data['source'] = source;
    data['aggregator'] = aggregator.toJson();
    data['providerName'] = providerName;
    data['name'] = name;
    data['aggregatorAccountNumber'] = aggregatorAccountNumber;
    data['amount'] = amount.toJson();
    return data;
  }
}

class AmountModel extends AmountEntity {
  AmountModel({required super.amount, required super.currency});

  factory AmountModel.fromJson(Map<String, dynamic> json) {
    return AmountModel(
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}
