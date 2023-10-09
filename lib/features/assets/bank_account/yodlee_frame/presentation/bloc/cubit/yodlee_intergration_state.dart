part of 'yodlee_intergration_cubit.dart';

@immutable
abstract class YodleeIntegrationState {}

class YodleeIntegrationInitial extends YodleeIntegrationState {}

class YodleeIntegrationLoading extends YodleeIntegrationState {}

class YodleeIntegrationLoaded extends YodleeIntegrationState {
  final ProviderTokenEntity data;
  final ProviderTokenEntity fixedData;

  YodleeIntegrationLoaded({required this.data, required this.fixedData});
}

class YodleeIntegrationError extends YodleeIntegrationState {
  final String errorMsg;

  YodleeIntegrationError(this.errorMsg);
}
