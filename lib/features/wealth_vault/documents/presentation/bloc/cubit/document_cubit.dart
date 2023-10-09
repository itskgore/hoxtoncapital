import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/wealth_vault/documents/domain/entities/document_entity.dart';
import 'package:wedge/features/wealth_vault/documents/domain/usecases/download_document.dart';
import 'package:wedge/features/wealth_vault/documents/domain/usecases/upload_document.dart';

import '../../../domain/usecases/delete_documents.dart';
import '../../../domain/usecases/get_document.dart';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final GetDocument getDocument;
  final DeleteDocument deleteDocument;
  final UploadDocument uploadDocument;
  final DownloadDocument downloadDocument;

  DocumentCubit(
      {required this.getDocument,
      required this.deleteDocument,
      required this.uploadDocument,
      required this.downloadDocument})
      : super(DocumentInitial());

  late List<DocumentValtEntity>
      _docsEntity; // = AssetsEntity(Document: [], otherAssets: [], summary: ,);
  getData() {
    emit(DocumentLoading());
    final _result = getDocument(NoParams());
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(DocumentError(failure.displayErrorMessage()));
        }
      },
          //if success
          (data) {
        _docsEntity = data;
        emit(DocumentLoaded(
            errorMessage: "",
            actionError: false,
            docs: data,
            deleteMessageSent: false,
            documentUploaded: false,
            documentDownloaded: false));
      });
    });
  }

  uploadDocumentvault(FormData data) async {
    final _result = uploadDocument(DocumentUploadParams(data: data));
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        emit(DocumentLoaded(
            errorMessage: failure.displayErrorMessage(),
            actionError: true,
            docs: _docsEntity,
            deleteMessageSent: false,
            documentUploaded: false,
            documentDownloaded: false));
      },
          //if success
          (data) {
        emit(DocumentLoaded(
            errorMessage: "",
            actionError: false,
            docs: _docsEntity,
            deleteMessageSent: false,
            documentUploaded: true,
            documentDownloaded: false));
      });
    });
  }

  deletedocumentValt(String id) {
    final _result = deleteDocument(DeleteParams(id: id));
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          deletedocumentValt(id);
        } else {
          emit(DocumentLoaded(
              errorMessage: "",
              actionError: true,
              docs: _docsEntity,
              deleteMessageSent: false,
              documentUploaded: false,
              documentDownloaded: false));
        }
      },
          //if success
          (data) {
        emit(DocumentLoaded(
            errorMessage: "",
            actionError: false,
            docs: _docsEntity,
            deleteMessageSent: true,
            documentUploaded: false,
            documentDownloaded: false));
      });
    });
  }

  downloadDocumentValt(String path) {
    final _result = downloadDocument(DownloadParams(path: path));
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          downloadDocumentValt(path);
        } else {
          emit(DocumentLoaded(
              errorMessage: failure.displayErrorMessage(),
              actionError: true,
              docs: _docsEntity,
              deleteMessageSent: false,
              documentUploaded: false,
              documentDownloaded: false));
        }
      },
          //if success
          (data) {
        emit(DocumentLoaded(
            errorMessage: "",
            actionError: false,
            docs: _docsEntity,
            deleteMessageSent: false,
            documentUploaded: false,
            documentDownloaded: true));
      });
    });
  }
}
