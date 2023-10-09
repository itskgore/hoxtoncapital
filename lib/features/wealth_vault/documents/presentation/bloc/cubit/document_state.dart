part of 'document_cubit.dart';

@immutable
abstract class DocumentState {}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentLoaded extends DocumentState {
  final List<DocumentValtEntity> docs;
  final bool deleteMessageSent;
  final bool documentUploaded;
  final bool documentDownloaded;
  final bool actionError;
  final String? errorMessage;

  DocumentLoaded(
      {required this.docs,
      required this.deleteMessageSent,
      required this.documentUploaded,
      required this.documentDownloaded,
      required this.actionError,
      required this.errorMessage});
}

class DocumentError extends DocumentState {
  final String errorMsg;

  DocumentError(this.errorMsg);
}
