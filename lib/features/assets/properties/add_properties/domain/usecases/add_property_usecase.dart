import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/properties/add_properties/domain/repositories/add_properties_repository.dart';

class AddProperty implements UseCase<PropertyEntity, PropertiesParams> {
  final AddPropertiesRepository repository;

  AddProperty(this.repository);

  @override
  Future<Either<Failure, PropertyEntity>> call(PropertiesParams params) async {
    return await repository.addProperty(
        params.id,
        params.name,
        params.country,
        params.purchasedValue,
        params.currentValue,
        params.hasRentalIncome,
        params.rentalIncome,
        params.hasMortgage,
        params.mortgages ?? []);
  }
}

class PropertiesParams extends Equatable {
  final String id;
  final String name;
  final String country;
  final ValueEntity purchasedValue;
  final ValueEntity currentValue;
  final dynamic hasRentalIncome;
  final RentalIncomeEntity rentalIncome;
  final dynamic hasMortgage;
  List<Map<String, dynamic>>? mortgages;

  PropertiesParams(
      {required this.name,
      required this.country,
      required this.purchasedValue,
      required this.currentValue,
      required this.id,
      required this.hasMortgage,
      required this.hasRentalIncome,
      this.mortgages,
      required this.rentalIncome});

  @override
  List<Object> get props => [
        name,
        country,
        id,
        purchasedValue,
        currentValue,
        hasMortgage,
        hasRentalIncome,
        hasMortgage,
        mortgages ?? [],
      ];
}
