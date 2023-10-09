import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/domain/usecases/delete_vehicle_loans.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/domain/usecases/get_vehicle_loans.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/domain/usecases/unlink_vehicle_loans.dart';

part 'main_vehicle_loans_state.dart';

class MainVehicleLoansCubit extends Cubit<MainVehicleLoansState> {
  MainVehicleLoansCubit(
      {required this.getVehicleLoansUsecase,
      required this.unlinkVehicleLoans,
      required this.deleteVehicleLoansUsecase})
      : super(MainVehicleLoansInitial());
  final GetVehicleLoansUsecase getVehicleLoansUsecase;
  final DeleteVehicleLoansUsecase deleteVehicleLoansUsecase;
  final UnlinkVehicleLoans unlinkVehicleLoans;
  LiabilitiesEntity? liabilitiesEntity;

  getVehicleLoans() {
    final result = getVehicleLoansUsecase(NoParams());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          getVehicleLoans();
        } else {
          emit(MainVehicleLoansError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) {
        liabilitiesEntity = data;
        emit(MainVehicleLoansLoaded(
            liabilitiesEntity: data, showDeleteMsg: false));
      });
    });
  }

  deleteVehicleLoans(DeleteParams params) {
    final result = deleteVehicleLoansUsecase(params);
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          deleteVehicleLoans(params);
        } else {
          emit(MainVehicleLoansError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) {
        emit(MainVehicleLoansLoaded(
            liabilitiesEntity: liabilitiesEntity!, showDeleteMsg: true));
      });
    });
  }

  unlinkVehicleLoansData(UnlinkParams params) {
    final result = unlinkVehicleLoans(params);
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          unlinkVehicleLoansData(params);
        } else {
          emit(MainVehicleLoansError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) {
        liabilitiesEntity!.vehicleLoans
            .removeWhere((element) => element.id == params.loanId);
      });
      emit(MainVehicleLoansUnlinked());
    });
  }
}
