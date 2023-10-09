part of 'cash_account_download_cubit.dart';

abstract class CashAccountDownloadState extends Equatable {
  const CashAccountDownloadState();

  @override
  List<Object> get props => [];
}

class CashAccountDownloadInitial extends CashAccountDownloadState {}

class CashAccountDownloadLoading extends CashAccountDownloadState {}

class CashAccountDownloadLoaded extends CashAccountDownloadState {}

class CashAccountDownloadError extends CashAccountDownloadState {
  final String errorMsg;

  const CashAccountDownloadError(this.errorMsg);
}
