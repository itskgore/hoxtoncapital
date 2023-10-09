import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

class GetDocument implements UseCase<List<DocumentValtEntity>, NoParams> {
  final DocumentRepository repository;

  GetDocument(this.repository);

  @override
  Future<Either<Failure, List<DocumentValtEntity>>> call(
      NoParams params) async {
    return await repository.getDocument();
  }
}
