import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/params/add_update_other_liabilities_params.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/usecases/add_other_liabilities_usecase.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/usecases/update_other_liabilities_usecase.dart';

part 'add_other_liabilities_state.dart';

class AddOtherLiabilitiesCubit extends Cubit<AddOtherLiabilitiesState> {
  final AddOtherLiabilitiesUsecase addOtherLiabilitiesUsecase;
  final UpdateOtherLiabilitiesUsecase updateOtherLiabilitiesUsecase;

  AddOtherLiabilitiesCubit(
      {required this.addOtherLiabilitiesUsecase,
      required this.updateOtherLiabilitiesUsecase})
      : super(AddOtherLiabilitiesInitial());

  addOtherLiabilities(AddUpdateOtherLiabilitiesParams params) {
    final result = addOtherLiabilitiesUsecase(params);
    emit(AddOtherLiabilitiesLoading());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          addOtherLiabilities(params);
        } else {
          emit(AddOtherLiabilitiesError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) => emit(AddOtherLiabilitiesLoaded(otherLiabilitiesEntity: r)));
    });
  }

  updateOtherLiabilities(AddUpdateOtherLiabilitiesParams params) {
    final result = updateOtherLiabilitiesUsecase(params);
    emit(AddOtherLiabilitiesLoading());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          updateOtherLiabilities(params);
        } else {
          emit(AddOtherLiabilitiesError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) => emit(AddOtherLiabilitiesLoaded(otherLiabilitiesEntity: r)));
    });
  }
}
