import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/edit_investment_notes_usecase.dart';
import 'investment_notes_state.dart';

class InvestmentNotesCubit extends Cubit<InvestmentNotesState> {
  final EditInvestmentNoteUseCase editInvestmentNoteUseCase;

  InvestmentNotesCubit({required this.editInvestmentNoteUseCase})
      : super(InvestmentNotesInitial());

  editInvestmentNotesData(Map<String, dynamic> body) {
    final result = editInvestmentNoteUseCase(body);
    emit(InvestmentNotesLoading());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          editInvestmentNotesData(body);
        } else {
          emit(InvestmentNotesError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) => emit(InvestmentNotesLoaded()));
    });
  }
}
