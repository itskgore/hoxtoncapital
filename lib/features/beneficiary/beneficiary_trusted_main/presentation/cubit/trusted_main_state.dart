part of 'trusted_main_cubit.dart';

abstract class TrustedMainState extends Equatable {
  const TrustedMainState();

  @override
  List<Object> get props => [];
}

class TrustedMainInitial extends TrustedMainState {}

class TrustedMainLoading extends TrustedMainState {}

class TrustedMainLoaded extends TrustedMainState {
  final bool isDeleted;
  final TrustedMembersEntity trustedMembersEntity;

  TrustedMainLoaded(
      {required this.trustedMembersEntity, required this.isDeleted});
}

class TrustedMainError extends TrustedMainState {
  final String errorMsg;

  TrustedMainError({required this.errorMsg});
}
