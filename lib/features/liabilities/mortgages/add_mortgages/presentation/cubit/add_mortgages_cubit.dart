import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:wedge/core/data_models/mortgages_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/all_accounts_types/presentation/bloc/cubit/mainassetsliabilities_cubit.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/params/mortgages_params.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/usecases/add_mortgages_usecases.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/usecases/update_mortgages_usecase.dart';

part 'add_mortgages_state.dart';

class AddMortgagesCubit extends Cubit<AddMortgagesState> {
  final AddMortgagesUsecases addMortgagesUsecases;
  final UpdateMortgagesUsecases updateMortgagesUsecases;

  AddMortgagesCubit(
      {required this.addMortgagesUsecases,
      required this.updateMortgagesUsecases})
      : super(AddMortgagesInitial());

  addMortgages(
      {required BuildContext context, required AddMortgagesParams params}) {
    final result = addMortgagesUsecases(params);
    emit(AddMortgagesLoading());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          addMortgages(context: context, params: params);
        } else {
          emit(AddMortgagesError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) async {
        await context.read<MainAssetsLiabilitiesCubit>().getData();
        emit(AddMortgagesLoaded(data: r));
      });
    });
  }

  updateMortgages(
      {required BuildContext context, required AddMortgagesParams params}) {
    final result = updateMortgagesUsecases(params);
    emit(AddMortgagesLoading());

    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          updateMortgages(context: context, params: params);
        } else {
          emit(AddMortgagesError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) async {
        await context.read<MainAssetsLiabilitiesCubit>().getData();
        emit(AddMortgagesLoaded(data: r));
      });
    });
  }
}
