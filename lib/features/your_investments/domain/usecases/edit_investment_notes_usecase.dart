import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/model/investment_notes_model.dart';
import '../repository/investment_notes_repo.dart';

class EditInvestmentNoteUseCase
    extends UseCase<InvestmentNotesModel, Map<String, dynamic>> {
  final InvestmentNotesRepo pensionNotesRepo;

  EditInvestmentNoteUseCase(this.pensionNotesRepo);

  @override
  Future<Either<Failure, InvestmentNotesModel>> call(
      Map<String, dynamic> params) {
    return pensionNotesRepo.editInvestmentNotes(params['body'], params['id']);
  }
}
