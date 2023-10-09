part of 'custom_assets_cubit.dart';

@immutable
abstract class CustomAssetsState {}

class CustomAssetsInitial extends CustomAssetsState {}

class CustomAssetsLoading extends CustomAssetsState {}

class CustomAssetsLoaded extends CustomAssetsState {
  final AssetsEntity assets;
  final bool deleteMessageSent;

  CustomAssetsLoaded({required this.assets, required this.deleteMessageSent});
}

class CustomAssetsError extends CustomAssetsState {
  final String errorMsg;

  CustomAssetsError(this.errorMsg);
}
