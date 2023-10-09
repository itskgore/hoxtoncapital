abstract class PensionNotesState {}

class PensionNotesInitial extends PensionNotesState {}

class PensionNotesLoading extends PensionNotesState {}

class PensionNotesLoaded extends PensionNotesState {}

class PensionNotesError extends PensionNotesState {
  final String errorMsg;

  PensionNotesError({required this.errorMsg});
}
