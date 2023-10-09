import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/params/add_vehicle_loans_params.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/usecase/add_vehicle_loans_usecase.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/usecase/udpate_vehicle_loans_usecase.dart';

part 'add_vehicle_loans_state.dart';

class AddVehicleLoansCubit extends Cubit<AddVehicleLoansState> {
  final UpdateVehicleLoansUsecase updateVehicleLoansUsecase;
  final AddVehicleLoansUsecase addVehicleLoansUsecase;

  AddVehicleLoansCubit(
      {required this.updateVehicleLoansUsecase,
      required this.addVehicleLoansUsecase})
      : super(AddVehicleLoansInitial());

  void addVehicleLoans(AddVehicleLoansParams params) {
    final result = addVehicleLoansUsecase(params);
    emit(AddVehicleLoansLoading());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          addVehicleLoans(params);
        } else {
          emit(AddVehicleLoansError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) {
        emit(AddVehicleLoansLoaded(data: data));
      });
    });
  }

  void updateVehicleLoans(AddVehicleLoansParams params) {
    final result = updateVehicleLoansUsecase(params);
    emit(AddVehicleLoansLoading());

    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          updateVehicleLoans(params);
        } else {
          emit(AddVehicleLoansError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) {
        emit(AddVehicleLoansLoaded(data: data));
      });
    });
  }
}
