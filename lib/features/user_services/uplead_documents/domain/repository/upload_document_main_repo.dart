import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../entities/upload_document_folder_entity.dart';

abstract class UploadDocumentMainRepository {
  Future<Either<Failure, List<UploadDocumentFolderEntity>>>
      getDocumentFolders();
}
