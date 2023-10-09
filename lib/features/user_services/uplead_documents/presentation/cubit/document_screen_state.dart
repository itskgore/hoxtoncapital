import '../../domain/entities/uploaded_document_entity.dart';

abstract class DocumentScreenState {}

class DocumentScreenInitialState extends DocumentScreenState {}

class DocumentScreenLoadingState extends DocumentScreenState {}

class DocumentScreenErrorState extends DocumentScreenState {
  final String errorMsg;

  DocumentScreenErrorState(this.errorMsg);
}

class DocumentScreenLoadedState extends DocumentScreenState {
  final List<UploadedDocumentEntity> documents;
  final bool downloaded;

  DocumentScreenLoadedState(
      {required this.downloaded, required this.documents});
}
