import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../repositories/document_repository.dart';

class UploadDocument implements UseCase<dynamic, DocumentUploadParams> {
  final DocumentRepository repository;

  UploadDocument(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(DocumentUploadParams params) async {
    return await repository.uploadDocument(params.data);
  }
}

class DocumentUploadParams {
  final FormData data;

  DocumentUploadParams({required this.data});
}
