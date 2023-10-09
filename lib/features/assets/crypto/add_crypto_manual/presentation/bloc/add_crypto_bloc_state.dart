part of 'add_crypto_bloc_cubit.dart';

@immutable
abstract class AddCryptoBlocState {}

class AddCryptoBlocInitial extends AddCryptoBlocState {}

class AddCryptoBlocLoading extends AddCryptoBlocState {}

class AddCryptoBlocLoaded extends AddCryptoBlocState {}

class AddCryptoBlocError extends AddCryptoBlocState {
  AddCryptoBlocError({required this.error});

  final String error;
}
