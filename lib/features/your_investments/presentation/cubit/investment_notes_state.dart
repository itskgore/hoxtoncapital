abstract class InvestmentNotesState {}

class InvestmentNotesInitial extends InvestmentNotesState {}

class InvestmentNotesLoading extends InvestmentNotesState {}

class InvestmentNotesLoaded extends InvestmentNotesState {}

class InvestmentNotesError extends InvestmentNotesState {
  final String errorMsg;

  InvestmentNotesError({required this.errorMsg});
}
