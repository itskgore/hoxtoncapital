import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/common/domain/usecases/refresh_aggregator_usecase.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/domain/usecases/delete_other_liabilities_usecase.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/domain/usecases/get_other_liabilities_usecase.dart';

part 'main_other_liabilities_state.dart';

class MainOtherLiabilitiesCubit extends Cubit<MainOtherLiabilitiesState> {
  final GetOtherLiabilitiesUsecase getOtherLiabilitiesUsecase;
  final DeleteOtherLiabilitiesUsecase deleteOtherLiabilitiesUsecase;
  final CommonRefreshAggregatorAccountUseCase
      commonRefreshAgreegatorAccountUsecase;

  MainOtherLiabilitiesCubit(
      {required this.getOtherLiabilitiesUsecase,
      required this.commonRefreshAgreegatorAccountUsecase,
      required this.deleteOtherLiabilitiesUsecase})
      : super(MainOtherLiabilitiesInitial());

  LiabilitiesEntity? liabilitiesEntity;

  getOtherLiabilitiesData() {
    emit(MainOtherLiabilitiesLoading());
    final result = getOtherLiabilitiesUsecase(NoParams());
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getOtherLiabilitiesData();
        } else {
          emit(MainOtherLiabilitiesError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        liabilitiesEntity = r;
        emit(MainOtherLiabilitiesLoaded(
            showDeleteMsg: false, liabilitiesEntity: r));
      });
    });
  }

  deleteOtherLiabilitiesData(DeleteParams deleteParams) {
    final result = deleteOtherLiabilitiesUsecase(deleteParams);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          deleteOtherLiabilitiesData(deleteParams);
        } else {
          emit(MainOtherLiabilitiesError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        emit(MainOtherLiabilitiesLoaded(
            showDeleteMsg: true, liabilitiesEntity: liabilitiesEntity!));
      });
    });
  }
}
