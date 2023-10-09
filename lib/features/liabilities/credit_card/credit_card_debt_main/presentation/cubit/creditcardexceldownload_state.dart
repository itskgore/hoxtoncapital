part of 'creditcardexceldownload_cubit.dart';

abstract class CreditCardExcelDownloadState extends Equatable {
  const CreditCardExcelDownloadState();

  @override
  List<Object> get props => [];
}

class CreditcardexceldownloadInitial extends CreditCardExcelDownloadState {}

class CreditcardexceldownloadLoading extends CreditCardExcelDownloadState {}

class CreditcardexceldownloadLoaded extends CreditCardExcelDownloadState {}

class CreditcardexceldownloadError extends CreditCardExcelDownloadState {
  final String errorMsg;

  const CreditcardexceldownloadError(this.errorMsg);
}
