import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/user_services_document_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/user_services/generic_domain/generic_usecases/download_doc_usecase.dart';
import 'package:wedge/features/user_services/generic_domain/generic_usecases/get_documents_usecase.dart';

part 'servicedocuments_state.dart';

class ServiceDocumentsCubit extends Cubit<ServiceDocumentsState> {
  final GetDocumentUsecase getDocumentUsecase;
  final ServiceDownloadDocument serviceDownloadDocument;

  ServiceDocumentsCubit(this.getDocumentUsecase, this.serviceDownloadDocument)
      : super(ServiceDocumentsInitial());

  UserDocumentRecordsEntity? userDocumentRecordsEntity;

  getData({Map<String, dynamic>? body, String? urlParameters}) {
    emit(ServiceDocumentsLoading());
    final result =
        getDocumentUsecase({"body": body, "paramerters": urlParameters});
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getData(body: body, urlParameters: urlParameters);
        } else {
          emit(ServiceDocumentsError(error: l.displayErrorMessage()));
        }
      }, (data) {
        userDocumentRecordsEntity = data;
        List<DocumentRecordsEntity> folders = [];
        List<DocumentRecordsEntity> files = [];
        userDocumentRecordsEntity!.records.forEach((e) {
          if (e.isFolder) {
            folders.add(e);
          } else {
            files.add(e);
          }
        });
        emit(ServiceDocumentsLoaded(
          downloaded: false,
          files: files,
          folders: folders,
          data: data,
        ));
      });
    });
  }

  downloadData({Map<String, dynamic>? body, String? urlParameters}) async {
    emit(ServiceDocumentsLoading());
    final result =
        serviceDownloadDocument({"body": body, "paramerters": urlParameters});
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getData(body: body, urlParameters: urlParameters);
        } else {
          emit(ServiceDocumentsError(error: l.displayErrorMessage()));
        }
      }, (data) {
        List<DocumentRecordsEntity> folders = [];
        List<DocumentRecordsEntity> files = [];
        for (var e in userDocumentRecordsEntity!.records) {
          if (e.isFolder) {
            folders.add(e);
          } else {
            files.add(e);
          }
        }
        emit(ServiceDocumentsLoaded(
          downloaded: true,
          files: files,
          folders: folders,
          data: userDocumentRecordsEntity!,
        ));
      });
    });
  }
}
