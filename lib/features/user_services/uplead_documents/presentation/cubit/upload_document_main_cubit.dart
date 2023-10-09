import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/user_services/uplead_documents/presentation/cubit/upload_document_main_state.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/usecases/get_upload_document_folders_usecase.dart';

class UploadDocumentMainCubit extends Cubit<UploadDocumentMainState> {
  GetUploadDocumentFoldersUsecase getUploadDocumentFoldersUsecase;

  UploadDocumentMainCubit({required this.getUploadDocumentFoldersUsecase})
      : super(UploadDocumentMainInitialState());

  getUploadDocumentFolders() {
    emit(UploadDocumentMainLoadingState());
    final result = getUploadDocumentFoldersUsecase(NoParams());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getUploadDocumentFolders();
        }
        log(l.runtimeType.toString());
        emit(UploadDocumentMainErrorState(l.displayErrorMessage()));
      }, (r) {
        emit(UploadDocumentMainLoadedState(r));
      });
    });
  }
}
