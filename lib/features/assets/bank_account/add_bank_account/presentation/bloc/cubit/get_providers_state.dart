part of 'get_providers_cubit.dart';

@immutable
abstract class GetProvidersState {}

class GetProvidersInitial extends GetProvidersState {}

class GetProvidersLoading extends GetProvidersState {}

class GetProvidersLoaded extends GetProvidersState {
  final ProviderResponseEntity data;
  final ProviderResponseEntity searchData;
  final bool textFieldClicked;

  GetProvidersLoaded(
      {required this.data,
      required this.searchData,
      required this.textFieldClicked});
}

class GetProvidersError extends GetProvidersState {
  final String errorMsg;

  GetProvidersError(this.errorMsg);
}
