import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/features/user_services/uplead_documents/presentation/cubit/upload_document_state.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/usecases/upload_document_usecase.dart';

class UploadDocumentCubit extends Cubit<UploadDocumentState> {
  UploadDocumentCubit({required this.uploadDocumentUseCase})
      : super(UploadDocumentInitial());
  final UploadDocumentUseCase uploadDocumentUseCase;

  updateUploadDocumentDetails(dynamic body,
      {Function(int, int)? onSendProgress, CancelToken? cancelToken}) {
    emit(UploadDocumentLoading());
    final result = uploadDocumentUseCase(body,
        onSendProgress: onSendProgress, cancelToken: cancelToken);
    result.then((value) => value.fold((l) {
          if (l is TokenExpired) {
            updateUploadDocumentDetails(body,
                onSendProgress: onSendProgress, cancelToken: cancelToken);
          } else {
            emit(UploadDocumentError(l.displayErrorMessage()));
          }
        }, (r) {
          emit(UploadDocumentLoaded(
            uploadDocumentModel: r,
          ));
        }));
  }
}
