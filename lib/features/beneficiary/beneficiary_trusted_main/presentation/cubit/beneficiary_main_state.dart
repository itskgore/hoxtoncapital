part of 'beneficiary_main_cubit.dart';

abstract class BeneficiaryMainState extends Equatable {
  const BeneficiaryMainState();

  @override
  List<Object> get props => [];
}

class BeneficiaryMainInitial extends BeneficiaryMainState {}

class BeneficiaryMainLoading extends BeneficiaryMainState {}

class BeneficiaryMainLoaded extends BeneficiaryMainState {
  final bool isDeleted;
  final BeneficiaryMembersEntity beneficiaryMembersEntity;

  BeneficiaryMainLoaded({
    required this.isDeleted,
    required this.beneficiaryMembersEntity,
  });
}

class BeneficiaryMainError extends BeneficiaryMainState {
  final String errorMsg;

  BeneficiaryMainError({required this.errorMsg});
}
