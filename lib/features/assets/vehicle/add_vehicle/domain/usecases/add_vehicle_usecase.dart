import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/domain/repositories/add_vehicle_repository.dart';

class AddVehicle implements UseCase<VehicleEntity, VehicleParams> {
  final AddVehicleRepository repository;

  AddVehicle(this.repository);

  @override
  Future<Either<Failure, VehicleEntity>> call(VehicleParams params) async {
    return await repository.addVehicle(params);
  }
}

class VehicleParams extends Equatable {
  late final String id;
  late final String name;
  late final String country;
  late final bool hasLoan;
  late final List<VehicleLoansEntity> vehicleLoans;
  late final ValueEntity value;

  VehicleParams(
      {required this.id,
      required this.name,
      required this.hasLoan,
      required this.vehicleLoans,
      required this.country,
      required this.value});

  Map<String, dynamic> toJson() => {
        "name": name,
        "country": country,
        "value": value.toJson(),
        "hasLoan": hasLoan,
        "vehicleLoans":
            List<VehicleLoansEntity>.from(vehicleLoans.map((x) => x)),
        "id": id,
      };

  @override
  List<Object> get props => [
        id,
        name,
        country,
        value,
      ];
}
