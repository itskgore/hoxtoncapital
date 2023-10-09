part of 'mainassetsliabilities_cubit.dart';

@immutable
abstract class MainAssetsLiabilitiesState {}

class MainAssetsLiabilitiesInitial extends MainAssetsLiabilitiesState {}

class MainAssetsLiabilitiesLoading extends MainAssetsLiabilitiesState {}

class MainAssetsLiabilitiesLoaded extends MainAssetsLiabilitiesState {
  final AssetsLiabilitiesModel assetsLiabilitiesData;

  MainAssetsLiabilitiesLoaded({required this.assetsLiabilitiesData});
}

class MainAssetsLiabilitiesError extends MainAssetsLiabilitiesState {
  final String errorMsg;

  MainAssetsLiabilitiesError(this.errorMsg);
}
