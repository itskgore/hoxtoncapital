part of 'add_personal_loan_cubit.dart';

@immutable
abstract class AddPersonalLoanState {}

class AddPersonalLoanInitial extends AddPersonalLoanState {}

class AddPersonalLoanLoading extends AddPersonalLoanState {}

class AddPersonalLoanSuccess extends AddPersonalLoanState {
  AddPersonalLoanSuccess({required this.data});

  final PersonalLoanEntity data;
}

class AddPersonalLoanError extends AddPersonalLoanState {
  AddPersonalLoanError({required this.errorMessage});

  final String errorMessage;
}
