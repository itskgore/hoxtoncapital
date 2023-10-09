part of 'main_other_liabilities_cubit.dart';

@immutable
abstract class MainOtherLiabilitiesState {}

class MainOtherLiabilitiesInitial extends MainOtherLiabilitiesState {}

class MainOtherLiabilitiesLoading extends MainOtherLiabilitiesState {}

class MainOtherLiabilitiesLoaded extends MainOtherLiabilitiesState {
  MainOtherLiabilitiesLoaded(
      {required this.showDeleteMsg, required this.liabilitiesEntity});

  final bool showDeleteMsg;
  final LiabilitiesEntity liabilitiesEntity;
}

class MainOtherLiabilitiesError extends MainOtherLiabilitiesState {
  MainOtherLiabilitiesError({required this.errorMsg});

  final String errorMsg;
}
