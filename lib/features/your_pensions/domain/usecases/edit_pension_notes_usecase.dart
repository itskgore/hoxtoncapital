import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/your_pensions/data/model/pension_notes_model.dart';
import 'package:wedge/features/your_pensions/domain/repository/pension_notes_repo.dart';

import '../../../../core/usecases/usecase.dart';

class EditPensionNoteUseCase
    extends UseCase<PensionNotesModel, Map<String, dynamic>> {
  final PensionNotesRepo pensionNotesRepo;

  EditPensionNoteUseCase(this.pensionNotesRepo);

  @override
  Future<Either<Failure, PensionNotesModel>> call(Map<String, dynamic> params) {
    return pensionNotesRepo.editPensionNotes(params['body'], params['id']);
  }
}
