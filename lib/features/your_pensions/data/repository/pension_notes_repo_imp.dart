import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/your_pensions/data/model/pension_notes_model.dart';

import '../../domain/repository/pension_notes_repo.dart';
import '../datasource/remote_pension_notes_datasources.dart';

class PensionNotesRepoImp implements PensionNotesRepo {
  late final RemotePensionNotesDataSource remoteNotesDataSource;

  PensionNotesRepoImp({required this.remoteNotesDataSource});

  @override
  Future<Either<Failure, PensionNotesModel>> editPensionNotes(
      Map<String, dynamic> body, String id) async {
    try {
      final result = await remoteNotesDataSource.editPensionNotes(body, id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
