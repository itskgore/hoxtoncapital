import '../../../data/Models/assets_liabilities_model.dart';

abstract class AssetsAndLiabilitiesState {}

class AssetsAndLiabilitiesInitial extends AssetsAndLiabilitiesState {}

class AssetsAndLiabilitiesLoading extends AssetsAndLiabilitiesState {}

class AssetsAndLiabilitiesLoaded extends AssetsAndLiabilitiesState {
  final AssetsLiabilitiesModel assetsLiabilitiesData;

  AssetsAndLiabilitiesLoaded({required this.assetsLiabilitiesData});
}

class AssetsAndLiabilitiesError extends AssetsAndLiabilitiesState {
  final String errorMsg;

  AssetsAndLiabilitiesError(this.errorMsg);
}
