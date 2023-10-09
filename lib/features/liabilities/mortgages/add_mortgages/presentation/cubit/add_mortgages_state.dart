part of 'add_mortgages_cubit.dart';

@immutable
abstract class AddMortgagesState {}

class AddMortgagesInitial extends AddMortgagesState {}

class AddMortgagesLoaded extends AddMortgagesState {
  AddMortgagesLoaded({required this.data});

  final Mortgages data;
}

class AddMortgagesLoading extends AddMortgagesState {}

class AddMortgagesError extends AddMortgagesState {
  AddMortgagesError({required this.errorMsg});

  final String errorMsg;
}
