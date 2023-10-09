import 'package:wedge/core/data_models/mortgages_model.dart';
import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/property_entity.dart';

class PropertyModel extends PropertyEntity {
  PropertyModel({
    required this.id,
    required this.name,
    required this.country,
    required this.currentValue,
    required this.rentalIncome,
    required this.hasMortgage,
    required this.hasRentalIncome,
    required this.purchasedValue,
    required this.mortgages,
    required this.source,
  }) : super(
            id: id,
            name: name,
            mortgages: mortgages,
            country: country,
            purchasedValue: purchasedValue,
            rentalIncome: rentalIncome,
            currentValue: currentValue,
            hasRentalIncome: hasRentalIncome,
            hasMortgage: hasMortgage,
            source: source);
  late String id;
  late String name;
  late String country;
  late String source;
  final ValueModel purchasedValue;
  final ValueModel currentValue;
  late dynamic hasRentalIncome;
  final RentalIncomeModel rentalIncome;
  late dynamic hasMortgage;
  final List<Mortgages> mortgages;

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      mortgages: List.from(json['mortgages'] ?? {})
          .map((e) => Mortgages.fromJson(e))
          .toList(),
      name: json['name'] ?? "",
      country: json['country'] ?? "",
      purchasedValue: ValueModel.fromJson(json['purchasedValue'] ?? {}),
      rentalIncome: RentalIncomeModel.fromJson(json['rentalIncome'] ?? {}),
      currentValue: ValueModel.fromJson(json['currentValue'] ?? {}),
      hasRentalIncome: json['hasRentalIncome'] ?? "",
      hasMortgage: json['hasMortgage'] ?? false,
      source: json['source'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['country'] = country;
    _data['purchasedValue'] = purchasedValue;
    _data['mortgages'] = mortgages;
    _data['rentalIncome'] = rentalIncome;
    _data['currentValue'] = currentValue;
    _data['hasRentalIncome'] = hasRentalIncome;
    _data['hasMortgage'] = hasMortgage;
    _data['source'] = source;
    return _data;
  }
}

class RentalIncomeModel extends RentalIncomeEntity {
  final ValueModel monthlyRentalIncome;

  RentalIncomeModel({required this.monthlyRentalIncome})
      : super(monthlyRentalIncome: monthlyRentalIncome);

  factory RentalIncomeModel.fromJson(Map<String, dynamic> json) {
    return RentalIncomeModel(
      monthlyRentalIncome:
          ValueModel.fromJson(json['monthlyRentalIncome'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['monthlyRentalIncome'] = monthlyRentalIncome;
    return _data;
  }
}
