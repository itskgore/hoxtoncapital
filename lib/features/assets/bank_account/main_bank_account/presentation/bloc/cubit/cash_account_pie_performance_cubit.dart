import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/error/failures.dart';
import '../../../data/model/cash_account_pie_performance_model.dart';
import '../../../domain/repositories/get_bank_accounts_repository.dart';
import 'cash_account_pie_performance_state.dart';

class CashAccountPiePerformanceCubit
    extends Cubit<CashAccountPiePerformanceState> {
  final GetCashAccountPiePerformance getCashAccountPiePerformance;
  late List<CashAccountPiePerformanceModel> performanceDate;

  CashAccountPiePerformanceCubit({
    required this.getCashAccountPiePerformance,
  }) : super(CashAccountPiePerformanceInitial());

  getCashAccountPiePerformanceData(
      {required String month, required String aggregatorAccountId}) {
    emit(CashAccountPiePerformanceLoading());
    final result = getCashAccountPiePerformance({
      "month": month,
      'aggregatorAccountId': aggregatorAccountId,
    });
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getCashAccountPiePerformanceData(
              month: month, aggregatorAccountId: aggregatorAccountId);
        } else {
          emit(CashAccountPiePerformanceError(l.displayErrorMessage()));
        }
      }, (r) {
        performanceDate = r;
        emit(CashAccountPiePerformanceLoaded(r));
      });
    });
  }
}
