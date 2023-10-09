part of 'third_party_cubit.dart';

abstract class ThirdPartyState extends Equatable {
  const ThirdPartyState();

  @override
  List<Object> get props => [];
}

class ThirdPartyInitial extends ThirdPartyState {}

class ThirdPartyLoading extends ThirdPartyState {}

class ThirdPartyLoaded extends ThirdPartyState {
  final List<ThirdPartyAccessEntity> thirdPartyAccessEntity;

  ThirdPartyLoaded(this.thirdPartyAccessEntity);
}

class ThirdPartyError extends ThirdPartyState {
  final String errorMsg;

  ThirdPartyError(this.errorMsg);
}
