part of 'allassets_cubit.dart';

@immutable
abstract class AllAssetsState {}

class AllAssetsInitial extends AllAssetsState {}

class AllAssetsLoaded extends AllAssetsState {
  final AssetsEntity data;

  AllAssetsLoaded({required this.data});
}

class AllAssetsError extends AllAssetsState {
  final String errorMsg;

  AllAssetsError(this.errorMsg);
}

class AllAssetsLoading extends AllAssetsState {}
