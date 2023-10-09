import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/error/failures.dart';
import '../../../domain/repositories/get_bank_accounts_repository.dart';
import 'cash_account_bar_performance_state.dart';

class CashAccountBarPerformanceCubit
    extends Cubit<CashAccountBarPerformanceState> {
  final GetCashAccountBarPerformance getCashAccountBarPerformance;
  late List<dynamic> performanceDate;

  CashAccountBarPerformanceCubit({
    required this.getCashAccountBarPerformance,
  }) : super(CashAccountBarPerformanceInitial());

  getCashAccountBarPerformanceData() {
    emit(CashAccountBarPerformanceLoading());
    final result = getCashAccountBarPerformance({});
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getCashAccountBarPerformanceData();
        } else {
          emit(CashAccountBarPerformanceError(l.displayErrorMessage()));
        }
      }, (r) {
        performanceDate = r;
        emit(CashAccountBarPerformanceLoaded(r));
      });
    });
  }
}
