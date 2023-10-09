part of 'add_vehicle_loans_cubit.dart';

@immutable
abstract class AddVehicleLoansState {}

class AddVehicleLoansInitial extends AddVehicleLoansState {}

class AddVehicleLoansLoading extends AddVehicleLoansState {}

class AddVehicleLoansLoaded extends AddVehicleLoansState {
  AddVehicleLoansLoaded({required this.data});

  final VehicleLoansEntity data;
}

class AddVehicleLoansError extends AddVehicleLoansState {
  AddVehicleLoansError({required this.errorMsg});

  final String errorMsg;
}
