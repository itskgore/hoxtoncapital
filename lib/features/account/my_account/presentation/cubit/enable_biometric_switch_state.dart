part of 'enable_biometric_switch_cubit.dart';

abstract class EnableBiometricSwitchState extends Equatable {
  const EnableBiometricSwitchState();

  @override
  List<Object> get props => [];
}

class EnableBiometricSwitchInitial extends EnableBiometricSwitchState {}

class EnableBiometricSwitchIsSelected extends EnableBiometricSwitchState {}

class EnableBiometricSwitchIsNotSelected extends EnableBiometricSwitchState {}

class EnableBiometricSwitchLoading extends EnableBiometricSwitchState {}

class EnableBiometricSwitchError extends EnableBiometricSwitchState {}
