part of 'vehicles_cubit.dart';

@immutable
abstract class VehiclesState {}

class VehiclesInitial extends VehiclesState {}

class VehiclesLoading extends VehiclesState {}

class VehiclesUnlink extends VehiclesState {
  VehiclesUnlink({required this.id});

  final String id;
}

class VehiclesLoaded extends VehiclesState {
  final AssetsEntity assets;
  final LiabilitiesEntity liabilitiesEntity;
  final bool deleteMessageSent;

  VehiclesLoaded({
    required this.assets,
    required this.deleteMessageSent,
    required this.liabilitiesEntity,
  });
}

class VehiclesError extends VehiclesState {
  VehiclesError({required this.errorMsg, this.id});

  final String errorMsg;
  String? id;
}
