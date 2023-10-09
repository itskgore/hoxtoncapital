import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddPropertiesRepository {
  Future<Either<Failure, PropertyEntity>> addProperty(
      String id,
      String name,
      String country,
      ValueEntity purchasedValue,
      ValueEntity currentValue,
      bool hasRentalIncome,
      RentalIncomeEntity rentalIncome,
      bool hasMortgage,
      List<Map<String, dynamic>> mortgages);

  Future<Either<Failure, PropertyEntity>> updateProperty(
      String id,
      String name,
      String country,
      ValueEntity purchasedValue,
      ValueEntity currentValue,
      bool hasRentalIncome,
      RentalIncomeEntity rentalIncome,
      bool hasMortgage,
      List<Map<String, dynamic>> mortgages);
}
