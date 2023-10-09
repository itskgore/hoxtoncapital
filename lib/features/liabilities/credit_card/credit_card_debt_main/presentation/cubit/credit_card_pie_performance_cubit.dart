import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../data/model/credit_card_pie_performance_model.dart';
import '../../domain/repository/credit_card_repository.dart';
import 'credit_card_pie_performance_state.dart';

class CreditCardPiePerformanceCubit
    extends Cubit<CreditCardPiePerformanceState> {
  final GetCreditCardPiePerformance getCreditCardPiePerformance;
  late List<CreditCardPiePerformanceModel> performanceDate;

  CreditCardPiePerformanceCubit({
    required this.getCreditCardPiePerformance,
  }) : super(CreditCardPiePerformanceInitial());

  getCreditCardPiePerformanceData(
      {required String month, required String aggregatorAccountId}) {
    emit(CreditCardPiePerformanceLoading());
    final result = getCreditCardPiePerformance({
      "month": month,
      'aggregatorAccountId': aggregatorAccountId,
    });
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getCreditCardPiePerformanceData(
              month: month, aggregatorAccountId: aggregatorAccountId);
        } else {
          emit(CreditCardPiePerformanceError(l.displayErrorMessage()));
        }
      }, (r) {
        performanceDate = r;
        emit(CreditCardPiePerformanceLoaded(r));
      });
    });
  }
}
