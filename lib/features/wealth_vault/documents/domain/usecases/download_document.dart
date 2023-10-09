import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../repositories/document_repository.dart';

class DownloadDocument implements UseCase<int, DownloadParams> {
  final DocumentRepository repository;

  DownloadDocument(this.repository);

  @override
  Future<Either<Failure, int>> call(DownloadParams params) async {
    return await repository.downloadDocument(params.path);
  }
}

class DownloadParams {
  final String? path;

  DownloadParams({
    this.path,
  });
}
