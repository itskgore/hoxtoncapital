import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/uploaded_document_entity.dart';
import '../../domain/usecases/download_uploaded_document_usecase.dart';
import '../../domain/usecases/get_uploaded_document_usecase.dart';
import 'document_screen_state.dart';

class DocumentScreenCubit extends Cubit<DocumentScreenState> {
  final GetUploadedDocumentUsecase getUploadedDocumentUsecase;
  final DownloadUploadedDocumentUsecase downloadUploadedDocumentUsecase;

  late List<UploadedDocumentEntity> _documents;

  DocumentScreenCubit(
      {required this.getUploadedDocumentUsecase,
      required this.downloadUploadedDocumentUsecase})
      : super(DocumentScreenInitialState());

  getDocuments(GetUploadedDocumentsParams params) {
    emit(DocumentScreenLoadingState());
    final result = getUploadedDocumentUsecase(params);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getDocuments(params);
        }
        log(l.runtimeType.toString());
        emit(DocumentScreenErrorState(l.displayErrorMessage()));
      }, (r) {
        _documents = r;
        emit(DocumentScreenLoadedState(documents: r, downloaded: false));
      });
    });
  }

  downloadDocument(
      DownloadUploadedDocumentsParams downloadUploadedDocumentsParams) {
    final result =
        downloadUploadedDocumentUsecase(downloadUploadedDocumentsParams);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          downloadDocument(downloadUploadedDocumentsParams);
        }
        log(l.runtimeType.toString());
        emit(DocumentScreenErrorState(l.displayErrorMessage()));
      }, (r) {
        // log(r.toString());
        if (r == 200) {
          emit(DocumentScreenLoadedState(
              downloaded: true, documents: _documents));
        }
      });
    });
  }
}
