part of 'get_tenant_cubit.dart';

abstract class GetTenantState extends Equatable {
  const GetTenantState();

  @override
  List<Object> get props => [];
}

class GetTenantInitial extends GetTenantState {}

class GetTenantLoading extends GetTenantState {}

class GetTenantLoaded extends GetTenantState {
  final TenantModel tenantEntity;

  const GetTenantLoaded(this.tenantEntity);
}

class GetTenantError extends GetTenantState {
  final String errorMsg;

  const GetTenantError(this.errorMsg);
}
