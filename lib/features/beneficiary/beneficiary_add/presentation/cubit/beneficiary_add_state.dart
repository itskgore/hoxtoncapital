part of 'beneficiary_add_cubit.dart';

abstract class BeneficiaryAddState extends Equatable {
  const BeneficiaryAddState();

  @override
  List<Object> get props => [];
}

class BeneficiaryAddInitial extends BeneficiaryAddState {}

class BeneficiaryAddLoading extends BeneficiaryAddState {}

class BeneficiaryAddLoaded extends BeneficiaryAddState {
  final BeneficiaryMembersEntity beneficiaryMembersEntity;

  BeneficiaryAddLoaded({required this.beneficiaryMembersEntity});
}

class BeneficiaryAddError extends BeneficiaryAddState {
  final String errorMsg;

  BeneficiaryAddError({required this.errorMsg});
}
