part of 'create_passcode_cubit.dart';

abstract class CreatePasscodeState extends Equatable {
  const CreatePasscodeState();

  @override
  List<Object> get props => [];
}

class CreatePasscodeInitial extends CreatePasscodeState {}

class CreatePasscodeLoading extends CreatePasscodeState {}

class CreatePasscodeLoaded extends CreatePasscodeState {
  final String passcodeEntered;

  CreatePasscodeLoaded({required this.passcodeEntered});
}

class CreatePasscodeError extends CreatePasscodeState {
  final String errorMsg;
  final String passcodeEntered;

  CreatePasscodeError({required this.errorMsg, required this.passcodeEntered});
}
