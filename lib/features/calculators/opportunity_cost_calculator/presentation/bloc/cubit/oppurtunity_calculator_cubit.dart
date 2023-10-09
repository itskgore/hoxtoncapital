import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'oppurtunity_calculator_state.dart';

class OppurtunityCalculatorCubit extends Cubit<OppurtunityCalculatorState> {
  OppurtunityCalculatorCubit()
      : super(OppurtunityCalculatorInitial(
            moneyTospend: 0.0,
            annualInflation: 0,
            annualReturn: 0,
            investmentPeriod: 0,
            totalValue: 0.0,
            interestEarned: 0));

  double _annualReturn = 0.0;
  int _investmentPeriod = 0;
  double _annualInflation = 0.0;
  double _totalValue = 0.0;
  double _interestEarned = 0.0;
  double _moneyTospend = 0.0;

//=(C2*(1+M10)^M11)+(C3*((1+M10)^M11-1)/M10)
  _calculateOP() {
    double inflationAdjustedRate =
        ((1 + (_annualReturn / 100)) / (1 + (_annualInflation / 100)) - 1);

    var _total =
        _moneyTospend * (pow((1 + inflationAdjustedRate), _investmentPeriod));
    _totalValue = double.parse(_total.toStringAsFixed(2));

    _interestEarned =
        double.parse((_totalValue - _moneyTospend).toStringAsFixed(2));
  }

  moneySpentOnchanged(moneyToSpend) {
    _moneyTospend = moneyToSpend;
    _calculateOP();
    emit(OppurtunityCalculatorInitial(
        moneyTospend: _moneyTospend,
        annualInflation: _annualInflation,
        annualReturn: _annualReturn,
        investmentPeriod: _investmentPeriod,
        totalValue: _totalValue,
        interestEarned: _interestEarned));
  }

  increaseAnnualReturn(moneyToSpend) {
    if (_annualReturn < 100) {
      _annualReturn += 0.5;
      _moneyTospend = moneyToSpend;
      _calculateOP();
      emit(OppurtunityCalculatorInitial(
          moneyTospend: _moneyTospend,
          annualInflation: _annualInflation,
          annualReturn: _annualReturn,
          investmentPeriod: _investmentPeriod,
          totalValue: _totalValue,
          interestEarned: _interestEarned));
    }
  }

  decreaseAnnualReturn(moneyToSpend) {
    if (_annualReturn > 0) {
      _annualReturn -= 0.5;
      _moneyTospend = moneyToSpend;

      _calculateOP();
      emit(OppurtunityCalculatorInitial(
          moneyTospend: _moneyTospend,
          annualInflation: _annualInflation,
          annualReturn: _annualReturn,
          investmentPeriod: _investmentPeriod,
          totalValue: _totalValue,
          interestEarned: _interestEarned));
    }
  }

  increaseInflation(moneyToSpend) {
    _moneyTospend = moneyToSpend;

    if (_annualInflation < 100) {
      _annualInflation += 0.5;
      _calculateOP();
      emit(OppurtunityCalculatorInitial(
          moneyTospend: _moneyTospend,
          annualInflation: _annualInflation,
          annualReturn: _annualReturn,
          investmentPeriod: _investmentPeriod,
          totalValue: _totalValue,
          interestEarned: _interestEarned));
    }
  }

  decreaseInflation(moneyToSpend) {
    _moneyTospend = moneyToSpend;

    if (_annualInflation > 0) {
      _annualInflation -= 0.5;
      _calculateOP();
      emit(OppurtunityCalculatorInitial(
          moneyTospend: _moneyTospend,
          annualInflation: _annualInflation,
          annualReturn: _annualReturn,
          investmentPeriod: _investmentPeriod,
          totalValue: _totalValue,
          interestEarned: _interestEarned));
    }
  }

  increaseInvestmentPeriod(moneyToSpend) {
    _moneyTospend = moneyToSpend;

    _investmentPeriod += 1;
    _calculateOP();
    emit(OppurtunityCalculatorInitial(
        moneyTospend: _moneyTospend,
        annualInflation: _annualInflation,
        annualReturn: _annualReturn,
        investmentPeriod: _investmentPeriod,
        totalValue: _totalValue,
        interestEarned: _interestEarned));
  }

  decreaseInvestmentPeriod(moneyToSpend) {
    _moneyTospend = moneyToSpend;

    if (_investmentPeriod > 0) {
      _investmentPeriod -= 1;
      _calculateOP();
      emit(OppurtunityCalculatorInitial(
          moneyTospend: _moneyTospend,
          annualInflation: _annualInflation,
          annualReturn: _annualReturn,
          investmentPeriod: _investmentPeriod,
          totalValue: _totalValue,
          interestEarned: _interestEarned));
    }
  }

  resetCalculator() {
    _annualReturn = 0.0;
    _investmentPeriod = 0;
    _annualInflation = 0.0;
    _totalValue = 0.0;
    _interestEarned = 0.0;
    _moneyTospend = 0.0;
    emit(OppurtunityCalculatorInitial(
        moneyTospend: 0.0,
        annualInflation: 0,
        annualReturn: 0,
        investmentPeriod: 0,
        totalValue: 0.0,
        interestEarned: 0));
  }
}
