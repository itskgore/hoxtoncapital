import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/features/your_pensions/domain/usecases/edit_pension_notes_usecase.dart';
import 'package:wedge/features/your_pensions/presentation/cubit/pension_notes_state.dart';

import '../../../../core/error/failures.dart';

class PensionNotesCubit extends Cubit<PensionNotesState> {
  final EditPensionNoteUseCase editPensionNoteUseCase;

  PensionNotesCubit({required this.editPensionNoteUseCase})
      : super(PensionNotesInitial());

  editPensionNotesData(Map<String, dynamic> body) {
    final result = editPensionNoteUseCase(body);
    emit(PensionNotesLoaded());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          editPensionNotesData(body);
        } else {
          emit(PensionNotesError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) => emit(PensionNotesLoaded()));
    });
  }
}
