part of 'terms_and_conditions_cubit.dart';

abstract class TermsAndConditionsState extends Equatable {
  const TermsAndConditionsState();

  @override
  List<Object> get props => [];
}

class TermsAndConditionsInitial extends TermsAndConditionsState {}

class TermsAndConditionsLoading extends TermsAndConditionsState {}

class TermsAndConditionsLoaded extends TermsAndConditionsState {}

class TermsAndConditionsError extends TermsAndConditionsState {
  final String errorMsg;

  const TermsAndConditionsError(this.errorMsg);
}
