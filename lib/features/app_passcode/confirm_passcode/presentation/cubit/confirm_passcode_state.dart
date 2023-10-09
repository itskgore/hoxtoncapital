part of 'confirm_passcode_cubit.dart';

abstract class ConfirmPasscodeState extends Equatable {
  const ConfirmPasscodeState();

  @override
  List<Object> get props => [];
}

class ConfirmPasscodeInitial extends ConfirmPasscodeState {}

class ConfirmPasscodeLoading extends ConfirmPasscodeState {}

class ConfirmPasscodeLoaded extends ConfirmPasscodeState {
  final String passcode;

  const ConfirmPasscodeLoaded({required this.passcode});
}

class ConfirmPasscodeError extends ConfirmPasscodeState {
  final String errorMsg;

  const ConfirmPasscodeError({
    required this.errorMsg,
  });
}
