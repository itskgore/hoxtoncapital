import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../entities/upload_document_folder_entity.dart';
import '../repository/upload_document_main_repo.dart';

class GetUploadDocumentFoldersUsecase
    implements UseCase<List<UploadDocumentFolderEntity>, NoParams> {
  final UploadDocumentMainRepository uploadDocumentMainRepository;

  GetUploadDocumentFoldersUsecase({required this.uploadDocumentMainRepository});

  @override
  Future<Either<Failure, List<UploadDocumentFolderEntity>>> call(
      NoParams params) {
    return uploadDocumentMainRepository.getDocumentFolders();
  }
}
