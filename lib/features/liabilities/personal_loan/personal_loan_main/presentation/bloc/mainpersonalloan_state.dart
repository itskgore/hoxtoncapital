part of 'mainpersonalloan_cubit.dart';

@immutable
abstract class MainPersonalLoanState {}

class MainpersonalloanInitial extends MainPersonalLoanState {}

class MainpersonalloanLoading extends MainPersonalLoanState {}

class MainpersonalloanError extends MainPersonalLoanState {
  MainpersonalloanError(this.errorMsg);

  final String errorMsg;
}

class MainpersonalloanLoaded extends MainPersonalLoanState {
  MainpersonalloanLoaded(this.showDeleteMsg, this.data);

  final bool showDeleteMsg;
  final LiabilitiesEntity data;
}
