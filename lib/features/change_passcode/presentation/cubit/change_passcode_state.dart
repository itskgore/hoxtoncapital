part of 'change_passcode_cubit.dart';

abstract class ChangePasscodeState extends Equatable {
  const ChangePasscodeState();

  @override
  List<Object> get props => [];
}

class ChangePasscodeInitial extends ChangePasscodeState {}

class ChangePasscodeLoading extends ChangePasscodeState {}

class ChangePasscodeLoaded extends ChangePasscodeState {
  final dynamic data;

  ChangePasscodeLoaded(this.data);
}

class ChangePasscodeError extends ChangePasscodeState {
  final String errorMsg;

  ChangePasscodeError(this.errorMsg);
}
