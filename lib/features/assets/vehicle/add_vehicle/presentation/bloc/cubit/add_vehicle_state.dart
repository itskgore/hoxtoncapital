part of 'add_vehicle_cubit.dart';

@immutable
abstract class AddVehicleState {}

class AddVehicleLoading extends AddVehicleState {}

class AddVehicleInitial extends AddVehicleState {
  final status;
  final message;
  final VehicleEntity data;

  AddVehicleInitial(
      {required this.status, required this.message, required this.data});
}
