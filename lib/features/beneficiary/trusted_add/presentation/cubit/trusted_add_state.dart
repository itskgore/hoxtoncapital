part of 'trusted_add_cubit.dart';

abstract class TrustedAddState extends Equatable {
  const TrustedAddState();

  @override
  List<Object> get props => [];
}

class TrustedAddInitial extends TrustedAddState {}

class TrustedAddLoading extends TrustedAddState {}

class TrustedAddLoaded extends TrustedAddState {
  final TrustedMembersEntity trustedMembersEntity;

  TrustedAddLoaded({required this.trustedMembersEntity});
}

class TrustedAddError extends TrustedAddState {
  final String errorMsg;

  TrustedAddError({required this.errorMsg});
}
