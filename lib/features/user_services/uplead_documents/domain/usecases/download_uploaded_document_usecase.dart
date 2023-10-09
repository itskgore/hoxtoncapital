import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../repository/view_document_repository.dart';

class DownloadUploadedDocumentUsecase
    implements UseCase<int, DownloadUploadedDocumentsParams> {
  final ViewDocumentRepository viewDocumentRepository;

  DownloadUploadedDocumentUsecase({required this.viewDocumentRepository});

  @override
  Future<Either<Failure, int>> call(DownloadUploadedDocumentsParams params) {
    return viewDocumentRepository.downloadUploadedDocuments(params.path);
  }
}
