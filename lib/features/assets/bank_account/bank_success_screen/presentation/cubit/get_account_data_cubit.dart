import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/entities/assest_liabiltiy_onboarding_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/domain/usecase/get_account_data_usecase.dart';

part 'get_account_data_state.dart';

class GetAccountDataCubit extends Cubit<GetAccountDataState> {
  GetAccountDataCubit(this.getAccountDataUsecase)
      : super(GetAccountDataLoading());

  final GetAccountDataUsecase getAccountDataUsecase;

  getData(String instituteId) {
    if (instituteId.isEmpty) {
      emit(GetAccountDataLoading());
    }
    final result = getAccountDataUsecase(ProviderParams(param: instituteId));
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData(instituteId);
        } else {
          return emit(GetAccountDataError(failure.displayErrorMessage()));
        }
      },
          //if succes
          (data) {
        if (data.assetLiabilityOnboardingEntityList.isEmpty) {
          emit(GetAccountDataLoadedButEmpty());
        } else {
          emit(GetAccountDataLoaded(data: data));
        }
      });
    });
  }
}
