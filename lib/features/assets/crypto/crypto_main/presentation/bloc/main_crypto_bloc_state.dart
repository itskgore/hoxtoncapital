part of 'main_crypto_bloc_cubit.dart';

@immutable
abstract class MainCryptoBlocState {}

class MainCryptoBlocInitial extends MainCryptoBlocState {}

class MainCryptoBlocLoading extends MainCryptoBlocState {}

class MainCryptoBlocLoaded extends MainCryptoBlocState {
  bool showDeleteMsg;
  AssetsEntity data;

  MainCryptoBlocLoaded({required this.data, required this.showDeleteMsg});
}

class MainCryptoBlocError extends MainCryptoBlocState {
  String errorMsg;

  MainCryptoBlocError({required this.errorMsg});
}
