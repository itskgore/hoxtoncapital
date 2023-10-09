import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wedge/core/error/failures.dart';

import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../data_sources/remote_document_datasource.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentDataSource remoteDocumentDataSource;

  DocumentRepositoryImpl({required this.remoteDocumentDataSource});

  @override
  Future<Either<Failure, List<DocumentValtEntity>>> getDocument() async {
    try {
      final result = await remoteDocumentDataSource.getDocuments();
      return Right(result);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteDocument(String id) async {
    try {
      final result = await remoteDocumentDataSource.deleteDocument(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, dynamic>> uploadDocument(FormData data) async {
    try {
      final result = await remoteDocumentDataSource.uploadDocument(data);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, int>> downloadDocument(String? path) async {
    try {
      final result =
          await remoteDocumentDataSource.downloadDocument(path: path);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
