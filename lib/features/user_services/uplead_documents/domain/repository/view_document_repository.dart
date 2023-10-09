import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../entities/uploaded_document_entity.dart';

abstract class ViewDocumentRepository {
  Future<Either<Failure, List<UploadedDocumentEntity>>> getUploadedDocuments(
      String parentFolder);

  Future<Either<Failure, int>> downloadUploadedDocuments(String path);
}
