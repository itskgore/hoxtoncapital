import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../repositories/document_repository.dart';

class DeleteDocument implements UseCase<dynamic, DeleteParams> {
  final DocumentRepository repository;

  DeleteDocument(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(DeleteParams params) async {
    return await repository.deleteDocument(params.id);
  }
}
