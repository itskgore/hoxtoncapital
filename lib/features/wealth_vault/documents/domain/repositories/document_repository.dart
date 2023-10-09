import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wedge/core/error/failures.dart';

import '../entities/document_entity.dart';

abstract class DocumentRepository {
  Future<Either<Failure, List<DocumentValtEntity>>> getDocument();

  Future<Either<Failure, dynamic>> deleteDocument(String id);

  Future<Either<Failure, dynamic>> uploadDocument(FormData data);

  Future<Either<Failure, int>> downloadDocument(String? savePath);
}
