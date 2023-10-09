part of 'assets_liabilities_main_cubit.dart';

@immutable
abstract class AssetsLiabilitiesMainState {}

class AssetsLiabilitiesMainInitial extends AssetsLiabilitiesMainState {}

class AssetsLiabilitiesMainLoading extends AssetsLiabilitiesMainState {}

class AssetsLiabilitiesMainLoaded extends AssetsLiabilitiesMainState {
  final AssetsEntity assetsData;
  final LiabilitiesEntity liabilitiesData;

  AssetsLiabilitiesMainLoaded(
      {required this.assetsData, required this.liabilitiesData});
}

class AssetsLiabilitiesMainError extends AssetsLiabilitiesMainState {
  final String errorMsg;

  AssetsLiabilitiesMainError(this.errorMsg);
}
