import 'package:wedge/core/data_models/aggregator_model.dart';
import 'package:wedge/core/data_models/asset_liability_onboarding_model.dart';

class AssetLiabilityOnboardingListEntity {
  final List<AssetLiabilityOnboardingEntity> assetLiabilityOnboardingEntityList;
  AssetLiabilityOnboardingListEntity(this.assetLiabilityOnboardingEntityList);
}

class AssetLiabilityOnboardingEntity {
  final String fiCategory;
  final String? fiType;
  final String source;
  final AggregatorModel aggregator;
  final String aggregatorLogo;
  final String providerName;
  final String name;
  final String aggregatorAccountNumber;
  final AmountModel amount;

  AssetLiabilityOnboardingEntity(
      {required this.fiCategory,
      this.fiType,
      required this.source,
      required this.aggregator,
      required this.aggregatorLogo,
      required this.providerName,
      required this.name,
      required this.aggregatorAccountNumber,
      required this.amount});
}

class AmountEntity {
  final num amount;
  final String currency;

  AmountEntity({required this.amount, required this.currency});
}
