import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'retirement_withdraw_calculator_state.dart';

class RetirementWithdrawCalculatorCubit
    extends Cubit<RetirementWithdrawCalculatorState> {
  RetirementWithdrawCalculatorCubit()
      : super(RetirementWithdrawCalculatorInitial());
}
