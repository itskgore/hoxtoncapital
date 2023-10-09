part of 'custom_asset_drop_down_cubit.dart';

@immutable
abstract class CustomAssetDropDownState {}

class CustomAssetDropDownInitial extends CustomAssetDropDownState {}

class CustomAssetDropDownLoading extends CustomAssetDropDownState {}

class CustomAssetDropDownLoaded extends CustomAssetDropDownState {
  final List<dynamic> data;

  CustomAssetDropDownLoaded({required this.data});
}

class CustomAssetDropDownError extends CustomAssetDropDownState {
  final String errorMsg;

  CustomAssetDropDownError({required this.errorMsg});
}
