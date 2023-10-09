import 'package:dartz/dartz.dart';
import 'package:wedge/features/your_pensions/data/model/pension_notes_model.dart';

import '../../../../core/error/failures.dart';

abstract class PensionNotesRepo {
  Future<Either<Failure, PensionNotesModel>> editPensionNotes(
      Map<String, dynamic> body, String id);
}
