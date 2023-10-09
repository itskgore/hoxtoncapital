import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/investment_notes_model.dart';

abstract class InvestmentNotesRepo {
  Future<Either<Failure, InvestmentNotesModel>> editInvestmentNotes(
      Map<String, dynamic> body, String id);
}
