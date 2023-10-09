part of 'ask_auth_cubit.dart';

abstract class AskAuthState extends Equatable {
  const AskAuthState();

  @override
  List<Object> get props => [];
}

class AskAuthInitial extends AskAuthState {}

class AskAuthLoading extends AskAuthState {}

class AskAuthLoaded extends AskAuthState {}
