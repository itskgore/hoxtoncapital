import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/user_services/uplead_documents/domain/entities/upload_document_folder_entity.dart';

import '../../domain/repository/upload_document_main_repo.dart';
import '../datasource/remote_upload_document_main_datasource.dart';

class UploadDocumentMainRepositoryImpl implements UploadDocumentMainRepository {
  final RemoteUploadDocumentMainDataSource remoteUploadDocumentMainDataSource;

  UploadDocumentMainRepositoryImpl(
      {required this.remoteUploadDocumentMainDataSource});

  @override
  Future<Either<Failure, List<UploadDocumentFolderEntity>>>
      getDocumentFolders() async {
    try {
      final result =
          await remoteUploadDocumentMainDataSource.getUploadDocumentFolders();
      return Right(result);
    } on Failure catch (e) {
      {
        log(e.toString());
        return Left(e);
      }
    }
  }
}
