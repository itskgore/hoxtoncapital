import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';

class PropertyEntity {
  PropertyEntity(
      {required this.id,
      required this.name,
      required this.country,
      required this.source,
      required this.currentValue,
      required this.purchasedValue,
      required this.hasRentalIncome,
      required this.rentalIncome,
      required this.mortgages,
      required this.hasMortgage});

  late String id;
  late String name;
  late String country;
  late String source;
  late ValueEntity purchasedValue;
  late ValueEntity currentValue;
  late dynamic hasRentalIncome;
  late RentalIncomeEntity rentalIncome;
  late dynamic hasMortgage;
  late List<MortgagesEntity> mortgages;
}

class RentalIncomeEntity {
  late ValueEntity monthlyRentalIncome;

  RentalIncomeEntity({required this.monthlyRentalIncome});

  List<Object> get props => [monthlyRentalIncome];
}
