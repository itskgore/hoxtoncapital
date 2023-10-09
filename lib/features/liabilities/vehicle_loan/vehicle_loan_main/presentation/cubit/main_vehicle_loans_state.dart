part of 'main_vehicle_loans_cubit.dart';

@immutable
abstract class MainVehicleLoansState {}

class MainVehicleLoansInitial extends MainVehicleLoansState {}

class MainVehicleLoansLoading extends MainVehicleLoansState {}

class MainVehicleLoansUnlinked extends MainVehicleLoansState {}

class MainVehicleLoansLoaded extends MainVehicleLoansState {
  MainVehicleLoansLoaded(
      {required this.liabilitiesEntity, required this.showDeleteMsg});

  final LiabilitiesEntity liabilitiesEntity;
  final bool showDeleteMsg;
}

class MainVehicleLoansError extends MainVehicleLoansState {
  MainVehicleLoansError({required this.errorMsg});

  final String errorMsg;
}
