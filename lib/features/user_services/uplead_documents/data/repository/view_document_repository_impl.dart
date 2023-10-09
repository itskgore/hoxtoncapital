import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../../domain/entities/uploaded_document_entity.dart';
import '../../domain/repository/view_document_repository.dart';
import '../datasource/remote_view_uploaded_documents.dart';

class ViewDocumentRepositoryImpl implements ViewDocumentRepository {
  ViewDocumentRepositoryImpl(
      {required this.remoteViewUploadedDocumentsDatasource});

  final RemoteViewUploadedDocumentsDatasource
      remoteViewUploadedDocumentsDatasource;

  @override
  Future<Either<Failure, int>> downloadUploadedDocuments(String path) async {
    try {
      final result = await remoteViewUploadedDocumentsDatasource
          .downloadUploadedDocuments(path);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<UploadedDocumentEntity>>> getUploadedDocuments(
      String parentFolder) async {
    try {
      final result = await remoteViewUploadedDocumentsDatasource
          .getUploadedDocuments(parentFolder);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
