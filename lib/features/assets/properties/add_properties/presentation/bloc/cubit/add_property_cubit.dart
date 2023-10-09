import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/properties/add_properties/domain/usecases/add_property_usecase.dart';
import 'package:wedge/features/assets/properties/add_properties/domain/usecases/update_property_usecase.dart';

part 'add_property_state.dart';

class AddPropertyCubit extends Cubit<AddPropertyState> {
  final AddProperty addProperty;
  final UpdateProperty updateProperty;

  AddPropertyCubit({required this.addProperty, required this.updateProperty})
      : super(AddPropertyInitial(
            status: false,
            message: "",
            data: PropertyEntity(
                mortgages: [],
                id: "",
                name: "",
                country: "",
                purchasedValue: ValueEntity(amount: 0.0, currency: ""),
                currentValue: ValueEntity(amount: 0.0, currency: ""),
                hasMortgage: false,
                hasRentalIncome: false,
                rentalIncome: RentalIncomeEntity(
                    monthlyRentalIncome:
                        ValueEntity(amount: 0.0, currency: "")),
                source: '')));

  final _otherAsset = PropertyEntity(
      id: "",
      mortgages: [],
      name: "",
      country: "",
      purchasedValue: ValueEntity(amount: 0.0, currency: ""),
      currentValue: ValueEntity(amount: 0.0, currency: ""),
      hasMortgage: false,
      hasRentalIncome: false,
      rentalIncome: RentalIncomeEntity(
          monthlyRentalIncome: ValueEntity(amount: 0.0, currency: "")),
      source: '');

  addData(
      name,
      country,
      purchasedValue,
      currentValue,
      hasRentalIncome,
      rentalIncome,
      hasMortgage,
      currentCurrency,
      purchasedCurrency,
      incomeCurrency,
      List<Map<String, dynamic>> mortgages) {
    final result = addProperty(PropertiesParams(
      id: "",
      name: name,
      country: country,
      mortgages: mortgages,
      purchasedValue: ValueEntity(
          amount: double.parse(purchasedValue), currency: purchasedCurrency),
      currentValue: ValueEntity(
          amount: double.parse(currentValue), currency: currentCurrency),
      hasMortgage: hasMortgage,
      hasRentalIncome: hasRentalIncome,
      rentalIncome: hasRentalIncome
          ? RentalIncomeEntity(
              monthlyRentalIncome: ValueEntity(
                  amount: double.parse(rentalIncome), currency: incomeCurrency))
          : RentalIncomeEntity(
              monthlyRentalIncome: ValueEntity(amount: 0.0, currency: "")),
    ));
    emit(AddPropertyLoading());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          addData(
              name,
              country,
              purchasedValue,
              currentValue,
              hasRentalIncome,
              rentalIncome,
              hasMortgage,
              currentCurrency,
              purchasedCurrency,
              incomeCurrency,
              mortgages);
        } else {
          emit(AddPropertyInitial(
              status: false,
              message: failure.displayErrorMessage(),
              data: _otherAsset));
        }
      },
          //if success
          (data) {
        emit(AddPropertyInitial(status: true, message: "", data: data));
      });
    });
  }

  updateData(
      id,
      name,
      country,
      purchasedValue,
      currentValue,
      hasRentalIncome,
      rentalIncome,
      hasMortgage,
      currentCurrency,
      purchasedCurrency,
      incomeCurrency,
      List<Map<String, dynamic>> mortgages) {
    final result = updateProperty(PropertiesParams(
      id: id,
      name: name,
      country: country,
      mortgages: mortgages,
      purchasedValue: ValueEntity(
          amount: double.parse(purchasedValue), currency: purchasedCurrency),
      currentValue: ValueEntity(
          amount: double.parse(currentValue), currency: currentCurrency),
      hasMortgage: hasMortgage,
      hasRentalIncome: hasRentalIncome,
      rentalIncome: RentalIncomeEntity(
          monthlyRentalIncome: ValueEntity(
              amount: double.parse(rentalIncome), currency: incomeCurrency)),
    ));
    emit(AddPropertyLoading());

    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          updateData(
              id,
              name,
              country,
              purchasedValue,
              currentValue,
              hasRentalIncome,
              rentalIncome,
              hasMortgage,
              currentCurrency,
              purchasedCurrency,
              incomeCurrency,
              mortgages);
        } else {
          emit(
            AddPropertyInitial(
                status: false,
                message: failure.displayErrorMessage(),
                data: _otherAsset),
          );
        }
      },
          //if success
          (data) {
        emit(AddPropertyInitial(status: true, message: "", data: data));
      });
    });
  }
}
