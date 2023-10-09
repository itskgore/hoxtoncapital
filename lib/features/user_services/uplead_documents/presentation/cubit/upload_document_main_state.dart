import '../../domain/entities/upload_document_folder_entity.dart';

abstract class UploadDocumentMainState {}

class UploadDocumentMainInitialState implements UploadDocumentMainState {}

class UploadDocumentMainLoadingState implements UploadDocumentMainState {}

class UploadDocumentMainLoadedState implements UploadDocumentMainState {
  final List<UploadDocumentFolderEntity> folders;

  UploadDocumentMainLoadedState(this.folders);
}

class UploadDocumentMainErrorState implements UploadDocumentMainState {
  final String errorMsg;

  UploadDocumentMainErrorState(this.errorMsg);
}
