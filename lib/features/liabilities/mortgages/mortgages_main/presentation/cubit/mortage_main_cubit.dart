import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/common/domain/usecases/refresh_aggregator_usecase.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/data_models/property_model.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/all_accounts_types/presentation/bloc/cubit/mainassetsliabilities_cubit.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/domain/usecases/delete_mortage_usecase.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/domain/usecases/get_mortage_usecase.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/domain/usecases/unlink_mortage_usecase.dart';

import '../../../../../../core/config/app_config.dart';

part 'mortage_main_state.dart';

class MortageMainCubit extends Cubit<MortageMainState> {
  MortageMainCubit(
      {required this.getMortageUsecase,
      required this.deleteMortageUsecase,
      required this.commonRefreshAgreegatorAccountUsecase,
      required this.unlinkMortageUsecase})
      : super(MortageMainInitial());
  final GetMortageUsecase getMortageUsecase;
  final DeleteMortageUsecase deleteMortageUsecase;
  final UnlinkMortageUsecase unlinkMortageUsecase;
  final CommonRefreshAggregatorAccountUseCase
      commonRefreshAgreegatorAccountUsecase;
  LiabilitiesEntity? mortgagesEntity;

  getMortgages(BuildContext context) {
    emit(MortageMainLoading());
    final result = getMortageUsecase(NoParams());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          getMortgages(context);
        } else {
          emit(MortageMainError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) async {
        final properties = await getProperties();
        mortgagesEntity = data;
        emit(MortageMainLoaded(
            liabilitiesEntity: data,
            showDeleteMsg: false,
            properties: properties));
      });
    });
  }

  Future<List<PropertyModel>> getProperties() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return AssetsModel.fromJson(json.decode(sharedPreferences
            .getString(RootApplicationAccess.assetsPreference)!))
        .properties;
  }

  deleteMortages(DeleteParams params, BuildContext context) {
    final result = deleteMortageUsecase(params);
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          deleteMortages(params, context);
        } else {
          emit(MortageMainError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) async {
        await context.read<MainAssetsLiabilitiesCubit>().getData();
        final properties = await getProperties();

        emit(MortageMainLoaded(
            liabilitiesEntity: mortgagesEntity!,
            showDeleteMsg: true,
            properties: properties));
      });
    });
  }

  unlinkMortages(UnlinkParams params) {
    final result = unlinkMortageUsecase(params);
    emit(MortageMainLoading());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          unlinkMortages(params);
        } else {
          emit(MortageMainError(
              errorMsg: failure.displayErrorMessage(), id: params.loanId));
        }
      }, (data) {
        emit(MortageMainUnlinked(id: params.loanId));
      });
    });
  }
}
