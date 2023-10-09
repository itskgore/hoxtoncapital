import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../entities/uploaded_document_entity.dart';
import '../repository/view_document_repository.dart';

class GetUploadedDocumentUsecase
    implements
        UseCase<List<UploadedDocumentEntity>, GetUploadedDocumentsParams> {
  final ViewDocumentRepository viewDocumentRepository;

  GetUploadedDocumentUsecase({required this.viewDocumentRepository});

  @override
  Future<Either<Failure, List<UploadedDocumentEntity>>> call(
      GetUploadedDocumentsParams params) {
    return viewDocumentRepository.getUploadedDocuments(params.parentFolder);
  }
}
