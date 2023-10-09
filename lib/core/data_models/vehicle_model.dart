import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/data_models/vehicle_loans_model.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';

class VehicleModel extends VehicleEntity {
  VehicleModel({
    required this.name,
    required this.country,
    required this.source,
    required this.value,
    required this.hasLoan,
    required this.vehicleLoans,
    required this.id,
  }) : super(
            id: id,
            name: name,
            country: country,
            hasLoan: hasLoan,
            value: value,
            vehicleLoans: vehicleLoans,
            source: source);

  late final String name;
  final String country;
  final String source;
  final ValueModel value;
  bool hasLoan;
  var vehicleLoans;
  final String id;

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        name: json["name"] ?? "",
        country: json["country"] ?? "",
        value: ValueModel.fromJson(json["value"] ?? {}),
        hasLoan: json["hasLoan"] ?? false,
        vehicleLoans: List.from(json['vehicleLoans'] ?? {})
            .map((e) => VehicleLoans.fromJson(e))
            .toList(),
        id: json["id"] ?? "",
        source: json["source"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "country": country,
        "value": value.toJson(),
        "hasLoan": hasLoan,
        "vehicleLoans": List<VehicleLoans>.from(vehicleLoans.map((x) => x)),
        "id": id,
        "source": source
      };
}
