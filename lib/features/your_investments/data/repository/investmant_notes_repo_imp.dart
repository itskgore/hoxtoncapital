import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../../domain/repository/investment_notes_repo.dart';
import '../datasource/remote_investment_notes_datasources.dart';
import '../model/investment_notes_model.dart';

class InvestmentNotesRepoImp implements InvestmentNotesRepo {
  late final RemoteInvestmentNotesDataSource remoteNotesDataSource;

  InvestmentNotesRepoImp({required this.remoteNotesDataSource});

  @override
  Future<Either<Failure, InvestmentNotesModel>> editInvestmentNotes(
      Map<String, dynamic> body, String id) async {
    try {
      final result = await remoteNotesDataSource.editInvestmentNotes(body, id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
