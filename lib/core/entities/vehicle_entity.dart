import 'package:wedge/core/entities/vehicles_loans_entity.dart';

import 'value_entity.dart';

class VehicleEntity {
  VehicleEntity({
    required this.id,
    required this.name,
    required this.country,
    required this.source,
    required this.value,
    required this.hasLoan,
    required this.vehicleLoans,
  });
  late final String id;
  late final String name;
  late final String source;
  late final String country;
  late final ValueEntity value;
  late final bool hasLoan;
  List<VehicleLoansEntity> vehicleLoans;
}
