import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/properties/add_properties/domain/repositories/add_properties_repository.dart';

import 'add_property_usecase.dart';

class UpdateProperty implements UseCase<PropertyEntity, PropertiesParams> {
  final AddPropertiesRepository repository;

  UpdateProperty(this.repository);

  @override
  Future<Either<Failure, PropertyEntity>> call(PropertiesParams params) async {
    return await repository.updateProperty(
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
