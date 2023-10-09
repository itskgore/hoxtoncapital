import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'retirement_calculator_state.dart';

class RetirementCalculatorCubit extends Cubit<RetirementCalculatorState> {
  RetirementCalculatorCubit() : super(RetirementCalculatorInitial());
}
