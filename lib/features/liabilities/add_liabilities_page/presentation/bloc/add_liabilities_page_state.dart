part of 'add_liabilities_page_cubit.dart';

@immutable
abstract class AddLiabilitiesPageState {}

class AddLiabilitiesPageInitial extends AddLiabilitiesPageState {}

class AddLiabilitiesPageLoading extends AddLiabilitiesPageState {}

class AddLiabilitiesPageLoaded extends AddLiabilitiesPageState {
  AddLiabilitiesPageLoaded({required this.liabilitiesEntity});

  final LiabilitiesEntity liabilitiesEntity;
}

class AddLiabilitiesPageError extends AddLiabilitiesPageState {
  AddLiabilitiesPageError({required this.errorMsg});

  final String errorMsg;
}
