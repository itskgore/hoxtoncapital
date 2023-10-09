import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/all_accounts_types/presentation/bloc/cubit/mainassetsliabilities_cubit.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/domain/usecases/add_vehicle_usecase.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/domain/usecases/update_vehicle_usecase.dart';

part 'add_vehicle_state.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  final AddVehicle addVehicle;
  final UpdateVehicle updateVehicle;

  AddVehicleCubit({required this.addVehicle, required this.updateVehicle})
      : super(AddVehicleInitial(
            status: false,
            message: "",
            data: VehicleEntity(
                name: "",
                id: '',
                country: '',
                value: ValueEntity(amount: 0, currency: ""),
                hasLoan: false,
                vehicleLoans: [],
                source: '')));

  final _investments = VehicleEntity(
      name: "",
      id: '',
      country: '',
      value: ValueEntity(amount: 0, currency: ""),
      hasLoan: false,
      vehicleLoans: [],
      source: '');

  addAsset(name, country, value, initCurrency, hasLoan, vehicleLoans,
      BuildContext context) {
    final _result = addVehicle(VehicleParams(
      name: name,
      value: ValueEntity(amount: double.parse(value), currency: initCurrency),
      id: "",
      hasLoan: hasLoan,
      vehicleLoans: vehicleLoans,
      country: country,
    ));
    emit(AddVehicleLoading());
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          addAsset(name, country, value, initCurrency, hasLoan, vehicleLoans,
              context);
        } else {
          emit(AddVehicleInitial(
              status: false,
              message: failure.displayErrorMessage(),
              data: _investments));
        }
      },
          //if success
          (data) async {
        await updateLiabilities(context);

        emit(AddVehicleInitial(status: true, message: "", data: data));
      });
    });
  }

  Future<void> updateLiabilities(BuildContext context) async {
    await context.read<MainAssetsLiabilitiesCubit>().getData();
  }

  updateAsset(id, name, country, value, initCurrency, hasLoan, vehicleLoans,
      BuildContext context) {
    final _result = updateVehicle(VehicleParams(
        name: name,
        value: ValueEntity(amount: double.parse(value), currency: initCurrency),
        country: country,
        hasLoan: hasLoan,
        vehicleLoans: vehicleLoans,
        id: id));
    emit(AddVehicleLoading());

    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          updateAsset(id, name, country, value, initCurrency, hasLoan,
              vehicleLoans, context);
        } else {
          emit(
            AddVehicleInitial(
                status: false,
                message: failure.displayErrorMessage(),
                data: _investments),
          );
        }
      },
          //if success
          (data) async {
        await updateLiabilities(context);
        emit(AddVehicleInitial(status: true, message: "", data: data));
      });
    });
  }
}
