import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/domain/usecases/delete_vehicle_usecase.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/domain/usecases/get_vehicles_usecase.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/domain/usecases/unlink_vehicle_usecase.dart';

import '../../../../../../../core/config/app_config.dart';

part 'vehicles_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> {
  final GetVehicless getVehicless;
  final DeleteVehicles deleteVehicless;
  final UnlinkVehicleUsecase unlinkVehicleUsecase;

  VehiclesCubit(
      {required this.getVehicless,
      required this.deleteVehicless,
      required this.unlinkVehicleUsecase})
      : super(VehiclesInitial());

  late AssetsEntity _assetsEntity;

  getData() {
    final _result = getVehicless(NoParams());
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(VehiclesError(errorMsg: failure.displayErrorMessage()));
        }
      },
          //if success
          (data) async {
        _assetsEntity = data;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        LiabilitiesModel liabilitiesModel = LiabilitiesModel.fromJson(
            json.decode(sharedPreferences
                .getString(RootApplicationAccess.liabilitiesPreference)!));
        emit(VehiclesLoaded(
            assets: data,
            deleteMessageSent: false,
            liabilitiesEntity: liabilitiesModel));
      });
    });
  }

  void unLinkVehicle(UnlinkParams params) {
    final result = unlinkVehicleUsecase(params);
    emit(VehiclesLoading());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          unLinkVehicle(params);
        } else {
          emit(VehiclesError(
              errorMsg: failure.displayErrorMessage(), id: params.loanId));
        }
      }, (data) {
        emit(VehiclesUnlink(id: params.loanId));
      });
    });
  }

  deleteData(id) {
    final _result = deleteVehicless(DeleteParams(id: id));
    _result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          deleteData(id);
        } else {
          emit(VehiclesError(errorMsg: failure.displayErrorMessage()));
        }
      },
          //if success
          (data) async {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        LiabilitiesModel liabilitiesModel = LiabilitiesModel.fromJson(
            json.decode(sharedPreferences
                .getString(RootApplicationAccess.liabilitiesPreference)!));
        emit(VehiclesLoaded(
            assets: _assetsEntity,
            deleteMessageSent: true,
            liabilitiesEntity: liabilitiesModel));
      });
    });
  }
}
