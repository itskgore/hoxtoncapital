import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/insights_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/calculators/retirement_calculator/domain/usecases/get_calculator_insights.dart';

part 'calculator_insights_state.dart';

class CalculatorInsightsCubit extends Cubit<CalculatorInsightsState> {
  CalculatorInsightsCubit({required this.getCalculatorInsights})
      : super(CalculatorInsightsInitial());

  final GetCalculatorInsights getCalculatorInsights;

  getData() {
    final result = getCalculatorInsights(NoParams());
    result.then((value) {
      value.fold(
          //if failed
          (failure) {
        if (failure is TokenExpired) {
          getData();
        } else {
          emit(CalculatorInsightsError());
        }
      },
          //if success
          (data) {
        emit(CalculatorInsightsLoaded(
          data: data,
        ));
      });
    });
  }
}
