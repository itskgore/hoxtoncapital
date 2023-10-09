import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calculator_main_page_state.dart';

class CalculatorMainPageCubit extends Cubit<CalculatorMainPageState> {
  CalculatorMainPageCubit() : super(CalculatorMainPageInitial());
}
