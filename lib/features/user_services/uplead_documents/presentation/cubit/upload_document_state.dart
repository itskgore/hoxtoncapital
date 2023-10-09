abstract class UploadDocumentState {}

class UploadDocumentInitial extends UploadDocumentState {}

class UploadDocumentLoading extends UploadDocumentState {}

class UploadDocumentError extends UploadDocumentState {
  final String errorMsg;

  UploadDocumentError(this.errorMsg);
}

class UploadDocumentLoaded extends UploadDocumentState {
  final dynamic uploadDocumentModel;

  UploadDocumentLoaded({required this.uploadDocumentModel});
}
