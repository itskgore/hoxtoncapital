part of 'add_other_liabilities_cubit.dart';

@immutable
abstract class AddOtherLiabilitiesState {}

class AddOtherLiabilitiesInitial extends AddOtherLiabilitiesState {}

class AddOtherLiabilitiesLoading extends AddOtherLiabilitiesState {}

class AddOtherLiabilitiesLoaded extends AddOtherLiabilitiesState {
  AddOtherLiabilitiesLoaded({required this.otherLiabilitiesEntity});

  final OtherLiabilitiesEntity otherLiabilitiesEntity;
}

class AddOtherLiabilitiesError extends AddOtherLiabilitiesState {
  AddOtherLiabilitiesError({required this.errorMsg});

  final String errorMsg;
}
