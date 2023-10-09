import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/common/domain/usecases/refresh_aggregator_usecase.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/domain/usecase/delete_main_personal_loan.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/domain/usecase/get_main_personal_loan.dart';

part 'mainpersonalloan_state.dart';

class MainPersonalLoanCubit extends Cubit<MainPersonalLoanState> {
  final GetMainPersonalLoanUsecase getMainPersonalLoanUsecase;
  final DeleteMainPersonalLoanUsecase deleteMainPersonalLoanUsecase;
  final CommonRefreshAggregatorAccountUseCase
      commonRefreshAgreegatorAccountUsecase;

  MainPersonalLoanCubit(
      {required this.getMainPersonalLoanUsecase,
      required this.commonRefreshAgreegatorAccountUsecase,
      required this.deleteMainPersonalLoanUsecase})
      : super(MainpersonalloanInitial());
  late LiabilitiesEntity _liabilitiesEntity;

  getmainPesonalLoan() {
    final result = getMainPersonalLoanUsecase(NoParams());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          getmainPesonalLoan();
        } else {
          emit(MainpersonalloanError(failure.displayErrorMessage()));
        }
      }, (data) {
        _liabilitiesEntity = data;
        emit(MainpersonalloanLoaded(false, data));
      });
    });
  }

  deletePersonalLoan(String id) {
    final result = deleteMainPersonalLoanUsecase(DeleteParams(id: id));
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          deletePersonalLoan(id);
        } else {
          emit(MainpersonalloanError(failure.displayErrorMessage()));
          emit(MainpersonalloanLoaded(false, _liabilitiesEntity));
        }
      }, (data) {
        emit(MainpersonalloanLoaded(true, _liabilitiesEntity));
      });
    });
  }
}
